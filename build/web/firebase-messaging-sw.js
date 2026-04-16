// Firebase Messaging Service Worker
// 앱이 백그라운드 또는 종료된 상태에서 수신된 FCM 메시지를 처리합니다.
// Flutter 웹 빌드 시 web/ 폴더 내 파일이 build/web/ 으로 복사됩니다.

importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Firebase 앱 초기화 (firebase_config.dart 와 동일한 값 사용)
firebase.initializeApp({
  apiKey: 'AIzaSyDm9UfHNLibksg2sYYm1o1NE89cwtYPQZs',
  authDomain: 'kindly-god.firebaseapp.com',
  projectId: 'kindly-god',
  storageBucket: 'kindly-god.firebasestorage.app',
  messagingSenderId: '377587650257',
  appId: '1:377587650257:web:70626937031928290ffff0',
});

const messaging = firebase.messaging();

// 백그라운드/종료 상태에서 수신된 메시지 → 브라우저 알림으로 표시
messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification;
  if (!notification) return;

  const title = notification.title || 'Kindly-God';
  const options = {
    body: notification.body || '',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: payload.data || {},
    // 같은 tag는 기존 알림을 교체 (중복 방지)
    tag: payload.data?.tag || 'kindly-god-notification',
  };

  self.registration.showNotification(title, options);
});

// 알림 클릭 시 앱으로 포커스 또는 새 탭 열기
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  const urlToOpen = event.notification.data?.url || '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url === urlToOpen && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});
