import { onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getMessaging } from 'firebase-admin/messaging';
import { getFirestore } from 'firebase-admin/firestore';
import { getReligionName } from '../constants/religion_names';

const FCM_TOKENS_COLLECTION = 'fcm_tokens';
/** FCM multicast 1회 최대 허용 토큰 수 */
const FCM_BATCH_SIZE = 500;

// ── 유틸 ─────────────────────────────────────────────────────────────────────

/** points 맵에서 최고 점수 종교 ID 반환. 없으면 null. */
function getTopReligion(points: Record<string, number>): string | null {
  const entries = Object.entries(points).filter(([, v]) => typeof v === 'number' && v > 0);
  if (entries.length === 0) return null;
  return entries.reduce((best, curr) => (curr[1] > best[1] ? curr : best))[0];
}

/** points 맵에서 상위 N개 종교 정렬해서 반환 */
function getTopN(
  points: Record<string, number>,
  n: number
): Array<{ id: string; pts: number }> {
  return Object.entries(points)
    .filter(([, v]) => typeof v === 'number' && v > 0)
    .sort(([, a], [, b]) => b - a)
    .slice(0, n)
    .map(([id, pts]) => ({ id, pts }));
}

interface TokenDoc {
  token: string;
  lang: string;
  religionId?: string;
}

/** Firestore fcm_tokens 컬렉션에서 모든 유효 토큰 조회 */
async function getAllTokens(): Promise<TokenDoc[]> {
  const db = getFirestore();
  const snap = await db.collection(FCM_TOKENS_COLLECTION).get();
  return snap.docs
    .map((doc) => {
      const d = doc.data();
      return {
        token: d['token'] as string,
        lang: (d['languageCode'] as string) || 'ko',
        religionId: d['religionId'] as string | undefined,
      };
    })
    .filter((t) => !!t.token);
}

/**
 * FCM 멀티캐스트 전송 (500개씩 배치).
 * 실패한 토큰은 로그만 출력 (재시도·삭제 로직은 필요 시 추가).
 */
async function sendMulticast(tokens: string[], title: string, body: string): Promise<void> {
  if (tokens.length === 0) return;
  const messaging = getMessaging();

  for (let i = 0; i < tokens.length; i += FCM_BATCH_SIZE) {
    const batch = tokens.slice(i, i + FCM_BATCH_SIZE);
    try {
      const res = await messaging.sendEachForMulticast({
        tokens: batch,
        notification: { title, body },
        webpush: {
          notification: {
            icon: '/icons/Icon-192.png',
            badge: '/icons/Icon-192.png',
            requireInteraction: false,
          },
          fcmOptions: { link: '/' },
        },
      });
      console.log(
        `[FCM] batch ${Math.floor(i / FCM_BATCH_SIZE) + 1}: ` +
          `success=${res.successCount} fail=${res.failureCount}`
      );
    } catch (err) {
      console.error('[FCM] sendMulticast error:', err);
    }
  }
}

// ── Cloud Functions ───────────────────────────────────────────────────────────

/**
 * aggregates/religionPoints 문서가 변경됐을 때 1위 종교 변동 감지.
 * 1위가 바뀌었으면 모든 사용자(로그인·비로그인)에게 알림 발송.
 */
export const onReligionPointsUpdated = onDocumentUpdated(
  'aggregates/religionPoints',
  async (event) => {
    const before = (event.data?.before?.data() ?? {}) as Record<string, number>;
    const after = (event.data?.after?.data() ?? {}) as Record<string, number>;

    const topBefore = getTopReligion(before);
    const topAfter = getTopReligion(after);

    // 1위 변동 없으면 알림 불필요
    if (!topAfter || topBefore === topAfter) return;

    const allTokens = await getAllTokens();

    // 언어별 토큰 분류
    const koTokens = allTokens.filter((t) => t.lang === 'ko').map((t) => t.token);
    const enTokens = allTokens.filter((t) => t.lang === 'en').map((t) => t.token);
    const zhTokens = allTokens.filter((t) => t.lang === 'zh').map((t) => t.token);
    const etcTokens = allTokens
      .filter((t) => !['ko', 'en', 'zh'].includes(t.lang))
      .map((t) => t.token);

    await Promise.all([
      sendMulticast(
        koTokens,
        '🏆 순위 변동!',
        `${getReligionName(topAfter, 'ko')}이(가) 1위로 올라섰습니다!`
      ),
      sendMulticast(
        enTokens,
        '🏆 Ranking Update!',
        `${getReligionName(topAfter, 'en')} is now #1!`
      ),
      sendMulticast(
        zhTokens,
        '🏆 排名更新！',
        `${getReligionName(topAfter, 'zh')}荣登第一！`
      ),
      // 기타 언어는 영어 메시지
      sendMulticast(
        etcTokens,
        '🏆 Ranking Update!',
        `${getReligionName(topAfter, 'en')} is now #1!`
      ),
    ]);
  }
);

/**
 * 매일 오전 9시(한국 시간) 종교 랭킹 Top 3 요약 알림.
 * 모든 사용자(로그인·비로그인)에게 발송.
 */
export const sendDailyRankingSummary = onSchedule(
  { schedule: '0 9 * * *', timeZone: 'Asia/Seoul' },
  async () => {
    const db = getFirestore();
    const snap = await db.collection('aggregates').doc('religionPoints').get();
    if (!snap.exists) return;

    const data = snap.data() as Record<string, number>;
    const top3 = getTopN(data, 3);
    if (top3.length === 0) return;

    const allTokens = await getAllTokens();

    const koTokens = allTokens.filter((t) => t.lang === 'ko').map((t) => t.token);
    const enTokens = allTokens.filter((t) => t.lang === 'en').map((t) => t.token);
    const zhTokens = allTokens.filter((t) => t.lang === 'zh').map((t) => t.token);
    const etcTokens = allTokens
      .filter((t) => !['ko', 'en', 'zh'].includes(t.lang))
      .map((t) => t.token);

    const rankBadge = ['🥇', '🥈', '🥉'];
    const bodyKo = top3
      .map((r, i) => `${rankBadge[i]} ${getReligionName(r.id, 'ko')}: ${r.pts.toLocaleString()}P`)
      .join(' · ');
    const bodyEn = top3
      .map((r, i) => `${rankBadge[i]} ${getReligionName(r.id, 'en')}: ${r.pts.toLocaleString()}P`)
      .join(' · ');
    const bodyZh = top3
      .map((r, i) => `${rankBadge[i]} ${getReligionName(r.id, 'zh')}: ${r.pts.toLocaleString()}P`)
      .join(' · ');

    await Promise.all([
      sendMulticast(koTokens, '📊 오늘의 종교 랭킹', bodyKo),
      sendMulticast(enTokens, '📊 Daily Religion Ranking', bodyEn),
      sendMulticast(zhTokens, '📊 今日宗教排行', bodyZh),
      sendMulticast(etcTokens, '📊 Daily Religion Ranking', bodyEn),
    ]);
  }
);
