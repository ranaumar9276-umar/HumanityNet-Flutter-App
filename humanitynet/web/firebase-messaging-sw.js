// web/firebase-messaging-sw.js

importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyDbIconu0XiO_8zDi9MyXmmY0-M02GnsFc',
  appId: '1:640600471882:web:4044c91c737c7c187869b3',
  messagingSenderId: '640600471882',
  projectId: 'humanity-net',
  authDomain: 'humanity-net.firebaseapp.com',
  databaseURL: 'https://humanity-net-default-rtdb.firebaseio.com',
  storageBucket: 'humanity-net.firebasestorage.app',
});

const messaging = firebase.messaging();