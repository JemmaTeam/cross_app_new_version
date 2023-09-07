/*
 1. Customer transfer to Jemma
*/
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const stripe = require("stripe")('sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI');
// const stripe = require('stripe')(functions.config().stripe.secret_key);
const sendLink=function(accountLinks){
    return accountLinks.url
}
const cors = require('cors')({ origin: true });
//Stripe TODO: 1. connect stripe with other page 2.add webhook to monitor status and send notification 3.mobile side stripe debug and setting

//TODO: pass user id and return url to redirect
//NOTE: This is function for onboarding tradies
exports.createConnectAccount = functions.https.onRequest(async (req, res) => {cors(req, res,async () => {
    try {
        // 使用 Stripe API 创建 Connect 账号
        const account = await stripe.accounts.create({
          type: 'express',
        });
        const accountLinks = await stripe.accountLinks.create({
            account: account.id,
            refresh_url: 'https://jemma-b0fcd.web.app/#/refresh',
            return_url: 'https://jemma-b0fcd.web.app/#/',
            type: 'account_onboarding',
        });
        // TODO: return account id
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
        success_url: 'http://localhost:3000/success',
        cancel_url: 'https://jemma-b0fcd.web.app/#/cancel',
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
          amount: parseInt(amount)*0.95,
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


//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//admin.initializeApp();
//
//// const stripe = require('stripe')('sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI');
//
//exports.createPayment = functions.https.onCall(async (data, context) => {
//  // check if the user login
//  if (!context.auth) {
//    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//  }
//
//  const paymentMethodId = data.paymentMethodId;
//  const destinationAccountId = data.destinationAccountId;
//
//  try {
//    const paymentIntent = await stripe.paymentIntents.create({
//      payment_method: paymentMethodId,
//      amount: 1000, // Amount in cents
//      currency: 'usd',
//      confirmation_method: 'manual',
//      confirm: true,
//      application_fee_amount: 100, // Application fee in cents
//      transfer_data: {
//        destination: destinationAccountId,
//      },
//    });
//
//    return {status: 'success'};
//  } catch (error) {
//    console.error(error);
//    throw new functions.https.HttpsError('internal', 'Failed to create the payment: ' + error.message);
//  }
//});

/*
//发送电子邮件提醒
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

// 配置电子邮件发送
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: functions.config().email.auth.user,
    pass: functions.config().email.auth.pass
  }
});

exports.onNewMessage = functions.firestore
  .document('chatRoom/{chatRoomId}/chats/{messageId}')
  .onCreate(async (snapshot, context) => {
    const newMessage = snapshot.data();
    const recipientId = newMessage['sendBy'];  // 假设字段名为'sendBy'

    // 获取接收者的电子邮件地址（您需要根据您的数据库结构进行调整）
    const recipientDoc = await admin.firestore().collection('users').doc(recipientId).get();
    const recipientEmail = recipientDoc.data().email;

    // 设置电子邮件内容
    const mailOptions = {
      from: 'your-email@gmail.com',
      to: recipientEmail,
      subject: 'New Message Notification',
      text: `You have a new message from ${newMessage['sendBy']}`
    };

    // 发送电子邮件
    return transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        return console.log(error);
      }
      console.log('Message sent: %s', info.messageId);
    });
  });
*/