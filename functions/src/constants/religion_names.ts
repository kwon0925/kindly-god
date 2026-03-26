/**
 * religionId → 언어별 표시 이름 매핑.
 * Flutter lib/models/religion.dart 의 defaultReligions 와 동기화 유지.
 */
const RELIGION_NAMES: Record<string, Record<string, string>> = {
  ko: {
    christianity: '기독교',
    catholicism: '천주교',
    islam: '이슬람교',
    buddhism: '불교',
    hinduism: '힌두교',
    judaism: '유대교',
    sikhism: '시크교',
    shinto: '신토',
    taoism: '도교',
    confucianism: '유교',
    mormonism: '몰몬교',
    jehovah: '여호와의 증인',
    atheism: '무신론',
    other: '기타 종교',
  },
  en: {
    christianity: 'Christianity',
    catholicism: 'Catholicism',
    islam: 'Islam',
    buddhism: 'Buddhism',
    hinduism: 'Hinduism',
    judaism: 'Judaism',
    sikhism: 'Sikhism',
    shinto: 'Shinto',
    taoism: 'Taoism',
    confucianism: 'Confucianism',
    mormonism: 'Mormonism',
    jehovah: "Jehovah's Witnesses",
    atheism: 'Atheism',
    other: 'Other',
  },
  zh: {
    christianity: '基督教',
    catholicism: '天主教',
    islam: '伊斯兰教',
    buddhism: '佛教',
    hinduism: '印度教',
    judaism: '犹太教',
    sikhism: '锡克教',
    shinto: '神道教',
    taoism: '道教',
    confucianism: '儒教',
    mormonism: '摩门教',
    jehovah: '耶和华见证人',
    atheism: '无神论',
    other: '其他',
  },
};

/**
 * 종교 ID를 언어에 맞는 이름으로 반환.
 * 해당 언어가 없으면 영어 → 그것도 없으면 ID 그대로 반환.
 */
export function getReligionName(religionId: string, lang = 'ko'): string {
  return (
    RELIGION_NAMES[lang]?.[religionId] ??
    RELIGION_NAMES['en']?.[religionId] ??
    religionId
  );
}
