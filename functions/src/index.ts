import { initializeApp } from 'firebase-admin/app';

// Firebase Admin SDK 초기화 (Cloud Functions 환경에서 자격증명 자동 처리)
initializeApp();

export { onReligionPointsUpdated, sendDailyRankingSummary } from './notifications/ranking_notifications';
