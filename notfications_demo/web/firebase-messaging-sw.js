importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
    apiKey: "AIzaSyANPiBSp88mirUgLxn0yYEexScm1uCgJcQ",
    authDomain: "webapp-a31ae.firebaseapp.com",
    projectId: "webapp-a31ae",
    storageBucket: "webapp-a31ae.appspot.com",
    messagingSenderId: "529367101886",
    appId: "1:529367101886:web:8b6eb7164a47ff660bc9ef",
    measurementId: "G-GLXQZLSNLG"
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });