const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('chats/{message}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('chats', {
        notification: {
            title: snapshot.data().username,
            body: snapshot.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
    });
  });

  exports.myFunction1 = functions.firestore
    .document('new match/{message}')
    .onWrite((snapshot, context) => {
      return admin.messaging().sendToTopic('chats', {
                notification: {
                    title: 'Predict for the Next Match!',
                    body: 'New match has been updated',
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
            });
    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
