"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendDailyRankingSummary = exports.onReligionPointsUpdated = void 0;
const app_1 = require("firebase-admin/app");
// Firebase Admin SDK 초기화 (Cloud Functions 환경에서 자격증명 자동 처리)
(0, app_1.initializeApp)();
var ranking_notifications_1 = require("./notifications/ranking_notifications");
Object.defineProperty(exports, "onReligionPointsUpdated", { enumerable: true, get: function () { return ranking_notifications_1.onReligionPointsUpdated; } });
Object.defineProperty(exports, "sendDailyRankingSummary", { enumerable: true, get: function () { return ranking_notifications_1.sendDailyRankingSummary; } });
//# sourceMappingURL=index.js.map