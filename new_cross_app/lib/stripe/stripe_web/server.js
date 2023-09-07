const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const stripe = require('stripe')('whsec_HYcaIOWRNgAFJJLoeUnx9HTen0S2kGVi');

exports.createConnectAccount = functions.https.onRequest(async (req, res) => {
  try {
    // 使用 Stripe API 创建 Connect 账号
    const account = await stripe.accounts.create({
      type: 'standard',
    });

    // 将 Connect 账号 ID 存储到 Firebase 实时数据库或 Firestore
    await admin.database().ref('connectAccounts').push({ account_id: account.id });

    res.json({ account_id: account.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: '创建账号时出错' });
  }
});


// Connect webhook notification function 1.Define a new Firebase Cloud Function to handle webhooks:
exports.handleStripeWebhooks = functions.https.onRequest(async (req, res) => {
  // Handle Stripe webhook event here
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.rawBody,
      req.headers['stripe-signature'],
      // This is the all events webhook's Signing secret
      whsec_HYcaIOWRNgAFJJLoeUnx9HTen0S2kGVi
    );
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      // Handle successful payment here
      break;
    // Add more cases for other events
    default:
      // Unexpected event type
      return res.status(400).end();
  }

  // Return a successful response to Stripe
  res.json({ received: true });
});


// 2. Add the Webhook Handling Cloud Function:
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
    let event;

    try {
        // Construct event from request body
        event = stripe.webhooks.constructEvent(
            req.rawBody,
            req.headers['stripe-signature'],
            'whsec_HYcaIOWRNgAFJJLoeUnx9HTen0S2kGVi'  // You'll get this when setting up webhooks in Stripe dashboard
        );
    } catch (err) {
        console.error('⚠️ Webhook Error:', err.message);
        res.status(400).send(`Webhook Error: ${err.message}`);
        return;
    }

    // Handle different types of events
    switch (event.type) {
        case 'payment_intent.succeeded':
            const paymentIntent = event.data.object;
            console.log(`PaymentIntent was successful!`);
            break;
        case 'payment_method.attached':
            const paymentMethod = event.data.object;
            console.log('PaymentMethod was attached to a Customer!');
            break;
        // ... add more event types to handle as needed
        default:
            // Unhandled event type
            console.log(`Unhandled event type ${event.type}`);
    }

    // Return a 200 response to Stripe
    res.json({received: true});
});


