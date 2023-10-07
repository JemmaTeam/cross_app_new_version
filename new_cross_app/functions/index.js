/*
 1. Customer transfer to Jemma
*/
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');
// 获取SendGrid API密钥
const sendgridApiKey = functions.config().sendgrid.key;
sgMail.setApiKey(sendgridApiKey);
admin.initializeApp();

const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(express.json());
const Stripe = require('stripe');
const stripe = require("stripe")('sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI');
const endpointSecret = 'whsec_j8jlLf5euoIVW2LESEFPp7mxWuXwpZqD';



const sendLink=function(accountLinks){
    return accountLinks.url
}
const cors = require('cors')({ origin: true });
//Stripe TODO: 1. connect stripe with other page 2.add webhook to monitor status and send notification 3.mobile side stripe debug and setting

//TODO: pass user id and return url to redirect

//This is function for onboarding tradies
exports.createConnectAccount = functions.https.onRequest(async (req, res) => {cors(req, res,async () => {
    const userId = req.body
    try {
        // create stripe account
        const account = await stripe.accounts.create({
          type: 'express',
        });
        // create stripe account link for onboarding
        const accountLinks = await stripe.accountLinks.create({
            account: account.id,
            refresh_url: 'https://jemma-b0fcd.web.app/#/create_success',
            return_url: 'https://jemma-b0fcd.web.app/#/create_success',
            type: 'account_onboarding',
        });
        // return account id to store on firebase and account link for redirection

        return res.send({
            url:accountLinks.url,
            id: account.id
        })
      } catch (error) {
        console.error(error);
        return res.send({error: error.message});
      }
  });
});

//NOTE: this is function for checkout
exports.StripeCheckOut = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const { price, userId, product_name } = req.body;
    try {
      const session = await stripe.checkout.sessions.create({
        metadata: {
            userId: userId, // Record userId
          },
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: 'aud',
              unit_amount: parseInt(price),
              product_data: {
                name: product_name
              }
            },
            quantity: 1
          }
        ],
        success_url: 'https://jemma-b0fcd.web.app/#/',
        cancel_url: 'https://jemma-b0fcd.web.app/#/',
      });

      // 返回 session.url 和 session.amount_total
      return res.send({
        url: session.url,
        amount: session.amount_total
      });
    } catch (error) {
      console.error(error);
      return res.send({ error: error.message });
    }
  });
});

//Note: this is function for transfer to tradies account
exports.Transfer = functions.https.onRequest(async (req, res)=>{cors(req, res, async()=>{
    const {accountId, amount}= req.body;
    try{
        const transfer = await stripe.transfers.create({
          amount: parseInt(amount),
          currency: 'aud',
          destination: accountId,
        });
        return res.send(transfer.amount);
    }catch(error){
        console.error(error)
        return res.send({error:error.message})
    }
    });
});


//Old code, reserve until the end of semester
const calculateOrderAmount = (items) => {
  const prices = []; // Add 'let' before variable declaration
  const catalog = [ // Add 'let' before variable declaration
    {"id": "0", "price": 20},
    {"id": "1", "price": 20},
    {"id": "2", "price": 4.99},
    {"id": "3", "price": 5.99},
    {"id": "4", "price": 6.99},
  ];

  items.forEach((item) =>{
    const price = catalog.find((x) => x.id == item.id).price;
    prices.push(price);
  });

  return parseInt(prices.reduce((a, b) => a + b) * 100);
};

const generateResponse = function(intent) {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.client_secret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        "error": "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      console.log("Payment succeeded");
      return {clientSecret: intent.client_secret, status: intent.status};
    default:
      return {error: "Failed"};
  }
};

exports.StripePayEndpointMethodId =
functions.https.onRequest(async (req, res)=>{
  const {useStripeSdk, paymentMethodId, currency, items} = req.body;
  // calculate Order Amount
  const orderAmount = calculateOrderAmount(items);

  try {
    if (paymentMethodId) {
      // Create a new PaymentIntent
      const params = {
        amount: orderAmount,
        confirm: true,
        confirmation_method: "manual",
        payment_method: paymentMethodId,
        currency: currency,
        use_stripe_sdk: useStripeSdk,
      };
      // Create a intent object
      const intent = await stripe.paymentIntents.create(params);

      console.log(`Intent: ${intent}`);

      return res.send(generateResponse(intent));

    }
    return res.sendStatus(400);
  } catch (e) {
    return res.send({error: e.message});
  }
});


exports.StripePayEndpointIntentId =
functions.https.onRequest(async (req, res)=>{
  const {paymentIntentId} = req.body;

  try {
    if (paymentIntentId) {
      // Create a intent object
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  } catch (e) {
    return res.send({error: e.message});
  }
});

exports.StripeTransfer=
functions.https.onRequest(async(req, res)=>{
    const {destination_id, amount} = req.body;

    try{
        const params = {
            amount: amount,
            currency: 'aud',
            destination: destination_id,
        }
        const transfer = await stripe.transfers.create(params);
        return res.send(transfer);
    } catch (e) {
        return res.send({error: e.message});
    }
});

/*
 2. Jemma transfer to Tradie
*/
exports.StripeConnectTransfer =
functions.https.onRequest(async (req, res) => {
  const {destination_id, amount} = req.body;
  // TODO：check the status of booking
  try {
    const params = {
      amount: amount,
      currency: 'usd',
      destination: destination_id,
    };
    // TODO：change to tradie's Stripe account
    const transfer = await stripe.transfers.create(params);

    return res.send(transfer);
  } catch (e) {
    return res.send({error: e.message});
  }
});

// Cloud Function to monitor bookings
exports.monitorBookingNotifications = functions.firestore
    .document('bookings/{bookingId}')
    .onCreate(async (snapshot, context) => {
        // Get booking data from snapshot
        const bookingData = snapshot.data();

        if (!bookingData) {
            console.error('Booking data not found.');
            return null;
        }

        // Use consumerId
        const consumerId = bookingData.consumerId;
        const eventName = bookingData.eventName;


        if (!consumerId) {
            console.error('ConsumerId not found in booking data.');
            return null;
        }
        
        // Formulate your notification message
        const notificationMessage = `Your booking for ${eventName} is successful, the status is ${bookingData.status}`;

        // Check if the user has NeedEmailInformed set to true
        const userSnapshot = await admin.firestore().collection('users').doc(consumerId).get();
        const userData = userSnapshot.data();
        const ConsumerfullName = userData ? userData.fullName : null;
        if (userData && userData.NeedEmailInformed) {
            // Send an email to the user using SendGrid
            const email = userData.email; // Assuming the user document has an email field

            // Formulate your email message
        const emailMessage = `
        <html>
        <head>
            <style>
            body {
              font-family: Arial, sans-serif; /* Optional: Set a default font */
          }
          .content {
              background-color: white; /* White background for the text content */
              padding: 20px;
              margin: 20px;
              border-radius: 5px; /* Optional: Rounded corners for the content box */
          }
          .logo-container {
              text-align: center; 
              margin-bottom: 20px;
              max-width: 100%; /* Ensure the container doesn't exceed the viewport width */
          }
          .logo-container img {
              width: 100%; /* Make the logo take up the full width of its container */
          }
            </style>
        </head>
        <body>
            <div class="logo-container">
                <img src="https://storage.googleapis.com/jemma-b0fcd.appspot.com/Logo/logo.png" alt="Company Logo">
            </div>
            <hr>
            <div class="content">
                Dear ${ConsumerfullName},<br><br>
                We hope this email finds you well.<br><br>
                Your booking for ${eventName} is successful. Below is the status of your booking:<br><br>
                <strong style="font-size: 1.3em;">${bookingData.status}</strong><br><br>
                Please do not hesitate to reach out if you have any questions or require further information.<br><br>
                Kind regards,<br>
                Jemma
            </div>
        </body>
        </html>
    `;
            
            const msg = {
                to: email,
                from: 'jemmaaugroup@gmail.com', // Your verified sender address
                subject: 'Booking Notification',
                html: emailMessage,
                // html: '<strong>Optional HTML content</strong>', // Optional HTML content
            };

            try {
                await sgMail.send(msg);
            } catch (error) {
                console.error('Error sending email:', error);
            }
        }

        // Store this notification in a user-specific notifications collection
        await admin.firestore().collection('users').doc(consumerId).collection('notifications').add({
            message: notificationMessage,
            timestamp: admin.firestore.FieldValue.serverTimestamp(), // for chronological order
            read: false // to mark if the user has read the notification
        });

        return null;
    });

// Cloud Function to monitor bookings
exports.monitorBookingStatusChange = functions.firestore
    .document('bookings/{bookingId}')
    .onUpdate(async (change, context) => {
        // Get the data before and after the change
        const beforeData = change.before.data();
        const afterData = change.after.data();

        // Check if the status has changed
        if (beforeData.status !== afterData.status) {
            // Assuming there's a field in bookingData for user ID (like consumerId)
            const consumerId = afterData.consumerId;
            const tradieId = afterData.tradieId;  // Assuming tradieId exists in your booking data
            const eventName = afterData.eventName;

            // Formulate your notification message
            const notificationMessage = `Your booking for ${eventName} status has changed to ${afterData.status}`;

            // Check if the consumer has NeedEmailInformed set to true
            const consumerSnapshot = await admin.firestore().collection('users').doc(consumerId).get();
            const consumerData = consumerSnapshot.data();
            const ConsumerfullName = consumerData? consumerData.fullName : null;
            if (consumerData && consumerData.NeedEmailInformed) {
                // Send an email to the consumer using SendGrid
                const email = consumerData.email;
                const emailMessage = `
                <html>
                <head>
                    <style>
                    body {
                      font-family: Arial, sans-serif; /* Optional: Set a default font */
                  }
                  .content {
                      background-color: white; /* White background for the text content */
                      padding: 20px;
                      margin: 20px;
                      border-radius: 5px; /* Optional: Rounded corners for the content box */
                  }
                  .logo-container {
                      text-align: center; 
                      margin-bottom: 20px;
                      max-width: 100%; /* Ensure the container doesn't exceed the viewport width */
                  }
                  .logo-container img {
                      width: 100%; /* Make the logo take up the full width of its container */
                  }
                    </style>
                </head>
                <body>
                    <div class="logo-container">
                        <img src="https://storage.googleapis.com/jemma-b0fcd.appspot.com/Logo/logo.png" alt="Company Logo">
                    </div>
                    <hr>
                    <div class="content">
                        Dear ${ConsumerfullName},<br><br>
                        We hope this email finds you well.<br><br>
                        Your booking for ${eventName} status has changed. Below is the updated status of your booking:<br><br>
                        <strong style="font-size: 1.3em;">${afterData.status}</strong><br><br>
                        Please do not hesitate to reach out if you have any questions or require further information.<br><br>
                        Kind regards,<br>
                        Jemma
                    </div>
                </body>
                </html>
            `;
                
                const msg = {
                    to: email,
                    from: 'jemmaaugroup@gmail.com', // Your verified sender address
                    subject: 'Booking Status Change Notification',
                    html: emailMessage,
                };

                try {
                    await sgMail.send(msg);
                } catch (error) {
                    console.error('Error sending email to consumer:', error);
                }
            }

            // Check if the tradie has NeedEmailInformed set to true
            const tradieSnapshot = await admin.firestore().collection('users').doc(tradieId).get();
            const tradieData = tradieSnapshot.data();
            const tradiefullName = tradieData ? tradieData.fullName : null;
            if (tradieData && tradieData.NeedEmailInformed) {
                // Send an email to the tradie using SendGrid
                const email = tradieData.email;
                const emailMessage = `
                <html>
                <head>
                    <style>
                    body {
                      font-family: Arial, sans-serif; /* Optional: Set a default font */
                  }
                  .content {
                      background-color: white; /* White background for the text content */
                      padding: 20px;
                      margin: 20px;
                      border-radius: 5px; /* Optional: Rounded corners for the content box */
                  }
                  .logo-container {
                      text-align: center; 
                      margin-bottom: 20px;
                      max-width: 100%; /* Ensure the container doesn't exceed the viewport width */
                  }
                  .logo-container img {
                      width: 100%; /* Make the logo take up the full width of its container */
                  }
                    </style>
                </head>
                <body>
                    <div class="logo-container">
                        <img src="https://storage.googleapis.com/jemma-b0fcd.appspot.com/Logo/logo.png" alt="Company Logo">
                    </div>
                    <hr>
                    <div class="content">
                        Dear ${tradiefullName},<br><br>
                        We hope this email finds you well.<br><br>
                        Your booking for ${eventName} status has changed. Below is the updated status of your booking:<br><br>
                        <strong style="font-size: 1.3em;">${afterData.status}</strong><br><br>
                        Please do not hesitate to reach out if you have any questions or require further information.<br><br>
                        Kind regards,<br>
                        Jemma
                    </div>
                </body>
                </html>
            `;
                
                const msg = {
                    to: email,
                    from: 'jemmaaugroup@gmail.com', // Your verified sender address
                    subject: 'Booking Status Change Notification',
                    html: emailMessage,
                };

                try {
                    await sgMail.send(msg);
                } catch (error) {
                    console.error('Error sending email to tradie:', error);
                }
            }

            // Send notification to the consumer in Firestore
            await admin.firestore().collection('users').doc(consumerId).collection('notifications').add({
                message: notificationMessage,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
                read: false
            });

            // Send notification to the tradie in Firestore
            await admin.firestore().collection('users').doc(tradieId).collection('notifications').add({
                message: notificationMessage,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
                read: false
            });
        }
        return null;
    });

// Cloud Function to monitor new messages in chats subcollection
exports.monitorNewMessages = functions.firestore
    .document('chatRoom/{chatRoomId}/chats/{chatId}')
    .onCreate(async (snapshot, context) => {
        // Get message data from snapshot
        const messageData = snapshot.data();

        if (!messageData) {
            console.error('Message data not found.');
            return null;
        }

        // Extract fields from message data
        const isRead = messageData.Isread;
        const message = messageData.message;
        const senderId = messageData.sendBy;
        const time = messageData.time;

        // Get sender's name
        const senderSnapshot = await admin.firestore().collection('users').doc(senderId).get();
        const senderData = senderSnapshot.data();
        const senderName = senderData ? senderData.fullName : 'Unknown';

        // Get chat room data to find the other user
        const chatRoomId = context.params.chatRoomId;
        const chatRoomSnapshot = await admin.firestore().collection('chatRoom').doc(chatRoomId).get();
        const chatRoomData = chatRoomSnapshot.data();

        if (!chatRoomData || !chatRoomData.users) {
            console.error('Chat room data or users field not found.');
            return null;
        }

        const users = chatRoomData.users;
        const receiverId = users.find(userId => userId !== senderId);

        if (!receiverId) {
            console.error('ReceiverId not found in chat room data.');
            return null;
        }

        // Formulate your notification message
        const notificationMessage = `New message from ${senderName}.`;

        // Send notification to the receiver
        await admin.firestore().collection('users').doc(receiverId).collection('notifications').add({
            message: notificationMessage,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            read: false
        });

        // Check if the receiver has NeedEmailInformed set to true
        const receiverSnapshot = await admin.firestore().collection('users').doc(receiverId).get();
        const receiverData = receiverSnapshot.data();
        const receiverName = receiverData ? receiverData.fullName : 'Unknown';  // Get the receiver's full name
        if (receiverData && receiverData.NeedEmailInformed) {
            // Send an email to the receiver using SendGrid
            const email = receiverData.email; // Assuming the user document has an email field
            const emailMessage = `
            <html>
            <head>
                <style>
                    body {
                        font-family: Arial, sans-serif; /* Optional: Set a default font */
                    }
                    .content {
                        background-color: white; /* White background for the text content */
                        padding: 20px;
                        margin: 20px;
                        border-radius: 5px; /* Optional: Rounded corners for the content box */
                    }
                    .logo-container {
                        text-align: center; 
                        margin-bottom: 20px;
                        max-width: 100%; /* Ensure the container doesn't exceed the viewport width */
                    }
                    .logo-container img {
                        width: 100%; /* Make the logo take up the full width of its container */
                    }
                </style>
            </head>
            <body>
                <div class="logo-container">
                    <img src="https://storage.googleapis.com/jemma-b0fcd.appspot.com/Logo/logo.png" alt="Company Logo">
                </div>
                <hr> <!-- Horizontal line to separate the logo and the content -->
                <div class="content">
                    Dear ${receiverName},<br><br>
            
                    We hope this email finds you well.<br><br>
            
                    You have received a new message from ${senderName}. Below is the content of the message:<br><br>
            
                    <strong style="font-size: 1.3em;">${message}</strong><br><br>  <!-- Increased font size and made it bold -->
            
                    Please do not hesitate to reach out if you have any questions or require further information.<br><br>
            
                    Kind regards,<br>
                    Jemma
                </div>
            </body>
            </html>            
`;

            const msg = {
                to: email,
                from: 'jemmaaugroup@gmail.com', // Your verified sender address
                subject: 'New Chat Message Notification',
                html: emailMessage, // Use the HTML content
            };

            try {
                await sgMail.send(msg);
            } catch (error) {
                console.error('Error sending email:', error);
            }
        }

        return null;
    });


app.use(bodyParser.json({
  verify: (req, res, buf) => {
    req.rawBody = buf.toString();
  }
}));
app.use((req, res, next) => {
  if (req.originalUrl === "/webhook") {
    next();
  } else {
    bodyParser.json()(req, res, next);
  }
});

//Account webhook
exports.handleStripeWebhooks = functions.https.onRequest(async (req, res) => {
    let event;
    const signature = req.headers["stripe-signature"];
    let message = '';
    try {
        event = stripe.webhooks.constructEvent(req.rawBody, signature, endpointSecret);
    } catch (err) {
        res.status(400).send(`Webhook Error: ${err.message}`);
        return;
    }

    switch (event.type) {
        case 'checkout.session.completed':
            message = 'Checkout completed.';
            break;
        case 'charge.succeeded':
            message = 'Charge has been successful.';
            break;
        case 'payment_intent.succeeded':
            message = 'Payment intent was successful.';
            break;
        case 'payment_intent.created':
            message = 'A new payment intent was created.';
            break;
        default:
            console.log(`Unhandled event type ${event.type}`);
            res.json({received: true});
            return;
    }

    const userId = event.data.object.metadata.userId;

    // Check if the user has NeedEmailInformed set to true
    const userSnapshot = await admin.firestore().collection('users').doc(userId).get();
    const userData = userSnapshot.data();

    if (userData && userData.NeedEmailInformed) {
        const emailMessage = `
        <html>
        //email template like above
        </html>
    `;

        const msg = {
            to: userData.email,
            from: 'jemmaaugroup@gmail.com',
            subject: 'Stripe Notification',
            html: emailMessage,
        };

        try {
            await sgMail.send(msg);
        } catch (error) {
            console.error('Error sending email:', error);
        }
    }

    await admin.firestore().collection('users').doc(userId).collection('notifications').add({
        message: message,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        read: false
    });

    res.json({received: true});
});


