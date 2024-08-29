const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const {logger} = require("firebase-functions");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Define the Cloud Function to handle new notifications
// eslint-disable-next-line max-len
exports.sendNotification = onDocumentCreated("notifications/{notificationId}", async (event) => {
  const snap = event.data;
  const notification = snap.data();

  const payload = {
    notification: {
      title: notification.title,
      body: notification.body,
    },
    token: notification.token, // Owner's FCM token
  };

  try {
    const response = await admin.messaging().send(payload);
    logger.info("Successfully sent message:", {response});
    return null;
  } catch (error) {
    logger.error("Error sending message:", {error});
    return null;
  }
});
