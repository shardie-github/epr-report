# Test Plan — Subscription lifecycle & webhooks


## 1) Install flow
- Open: GET /auth/install?shop=dev-store.myshopify.com
- Accept OAuth, receive access token stored in DB

## 2) Create subscription
- POST /billing/graphql/create with shop & returnUrl
- Expect response.confirmationUrl (merchant must visit to accept)

## 3) Accept subscription in Shopify
- After merchant accepts, Shopify will send app subscription update webhook
- Verify webhook received at /billing/graphql/webhook
- Check DB: subscription status changed to ACTIVE and provider_subscription_id stored

## 4) Simulate webhook (use sample JSON files below)
- POST sample webhook JSON to /billing/graphql/webhook with X-Shopify-Hmac-Sha256 header computed using SHOPIFY_API_SECRET

## 5) Uninstall flow
- Shopify sends app/uninstalled webhook to /webhooks/app/uninstalled
- Verify app marks shop as inactive and schedules data purge (per retention policy)

## 6) Failure & recovery
- Simulate webhook HMAC mismatch -> expect 401
- Simulate DB failure during reconcile -> expect 500 and webhook retried by Shopify
