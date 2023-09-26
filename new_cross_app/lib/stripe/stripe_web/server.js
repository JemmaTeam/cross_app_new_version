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





