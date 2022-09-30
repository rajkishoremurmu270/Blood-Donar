const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

exports.sendNotification = functions.https.onCall((data, context) => {
  var tokens = data.Token;
  var seekerName= data.seekerName;


	var payload = {
		notification: {
			title: 'Request for blood donation',
			body:  seekerName+' has requested you for blood donation',
			sound: 'default',
		},
		
	};

	try {
		const response =  admin.messaging().sendToDevice(tokens, payload);
		console.log('Notification sent successfully');
    return { msg: "function executed succesfully" };
	} catch (err) {
		console.log(err);
    return { msg: "error in execution" };
	}
  });

  