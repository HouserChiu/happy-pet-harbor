# Happy Pet Harbor

Pre-launch pet supplies website for RaeHouser Trading LLC.

- Contact: houserchiu@gmail.com
- Initial category: pet leashes
- Planned expansion: pet hair removal supplies and other pet accessories
- Hosting: Cloudflare Workers Static Assets, worker `happy-pet-harbor`
- Live URL: https://raehouser.com
- Alternate URL: https://www.raehouser.com (301-redirects to https://raehouser.com, handled in `src/worker.mjs`)
- Workers URL: disabled (`workers_dev: false`) so only the canonical domain is indexed
- Custom domains configured: raehouser.com and www.raehouser.com
- Cloudflare zone and certificates active; HTTPS verified on both custom domains. HTTP automatically redirects to HTTPS.

## Local preview

From this folder: `python3 -m http.server 4178 --bind 127.0.0.1 --directory dist`

## Deploy

From this folder: `npm run deploy`

Only `dist/` is published; no secrets are needed for the current static website.

## Remaining launch information

Online payments are NOT connected. Before enabling sales, obtain actual product specifications and images, price and currency, stock/dispatch date, shipping destinations/costs, return/refund terms, and a merchant-owned payment provider account or hosted payment link. A mailto enquiry is not an order. Use provider-hosted checkout; never collect payment card data in email or a static form. Update the homepage, store information and privacy notice together when checkout is enabled.

Domain registration remains with Wyoming Registered Agent Services / DomainRegistry.com. On 2026-09-23, nameservers were changed to `addyson.ns.cloudflare.com` and `sri.ns.cloudflare.com`. Cloudflare zone `f0019c899470f16279f74c39fbeb49e6` is active. Both apex and www custom domains are attached to this Worker. Public DNS checks confirmed the original MX, SPF, DKIM, DMARC, and psrp CNAME records remain in place. The original records are backed up in `ops/raehouser-dns-before-cloudflare.zone`.

HTTPS verified on 2026-09-23: Cloudflare lists all managed certificates as Active, Chrome reports a secure connection, and both custom domains return HTTP 200 with certificate verification enabled. Always Use HTTPS is enabled; HTTP requests to both hostnames and the privacy page return 301 redirects to their HTTPS equivalents, followed by HTTP 200. No payment provider is connected.

## Assets

Lifestyle photograph: Real Natures Food / Unsplash
Source: https://unsplash.com/photos/a-dog-sitting-on-a-couch-TnEytxj87dc/
License: https://unsplash.com/license
The lifestyle photo does not represent a specific product for sale.

Fonts: DM Sans and Manrope, downloaded from Google Fonts and served locally.

## Rope leash product — 2026-09-25

Product preview: `/products/padded-rope-leash/`. User-supplied blue, pink and green product photos are served unchanged as JPG files (replacing the earlier screenshots). Supplier reference: https://detail.1688.com/offer/864785270212.html (page could not be accessed; specifications unverified). Copy describes only visible design. No material, length, strength, reflective performance, price or inventory claims. Price, fulfillment terms and checkout remain pending user input. Color gallery uses native radio inputs and CSS, without scripts.

2026-09-25 update: User confirmed $5.00 USD, 1.5 m length, 1.0 cm width, free shipping and dispatch from Addison, Illinois, USA. Public copy uses city/state only. Delivery destinations, inventory, timing, returns and payment provider remain unconfirmed; checkout stays closed. These details supersede the earlier pending price and size notes.

Product videos: `dist/assets/videos/leash-rotate.mp4` (three-color studio showcase) and `leash-sway.mp4` (handle and clasp close-up), both user-provided 720×1280 portrait (10 s and 6 s) H.264/AAC MP4 with audio, posters at `dist/assets/video-poster-*.jpg`. Native player controls, no autoplay; labeled as product showcase videos rather than live-use demonstrations.

2026-09-26: Removed pre-launch messaging across public pages at user request. Website presents the current collection and email purchase enquiries. Checkout remains unconnected; no inventory or delivery guarantees were added.

2026-10-08: User approved the proposed policies. Added terms/user agreement, shipping, payment/billing, returns/refunds, and support pages; refreshed privacy. Processing 1–3 business days; contiguous-US transit 3–7 business days; AK/HI and special addresses require pre-purchase confirmation. Returns requested within 30 calendar days of receipt; unused/unwashed with original packaging for change-of-mind; buyer pays change-of-mind return postage, seller covers defective/damaged/wrong items; approved refunds initiated in 3–5 business days after return inspection (or approval if no return required), bank posting time varies. All pages identify Happy Pet Harbor and RaeHouser Trading LLC. Payment link remains unconnected.

## Redesign — 2026-10-22

New visual system and page layouts (cream/ink palette, tangerine accent, Manrope 800 display + DM Sans body; Manrope 400 file no longer referenced). Homepage: hero with color tiles, trust strip, shop-by-color cards, features, spec band, story, shipping/returns cards, FAQ, contact band. Product page: single-image stage with color thumbnails (CSS radios), sticky buy box with per-color Stripe button, specs/delivery accordions, horizontal detail-image rail, videos. `/products/padded-rope-leash/#blue|#pink|#green` preselects a color (small inline script). Policy pages keep their text unchanged, inside a shared policy sidebar layout. Worker-rendered account/cart pages use the same header/footer (`header`/`footer` constants in `src/worker.mjs`).

Derived display assets (originals untouched): `rope-leash-green-studio.jpg` (green photo with the grey backdrop lifted to white, so it blends on tinted tiles) and `leash-in-hand.jpg` (centre crop of `detail-craftsmanship.webp` without the supplier caption text).

Note: the two stale expectations in `tests/shop-flow.py` were updated on 2026-10-23.

## Customer accounts and carts

Worker entry: `src/worker.mjs`; schema: `schema.sql`; dedicated D1 database `happy-pet-harbor-shop`. Public browsing and color selection remain static. Same-origin POST forms handle registration/login, server-backed account cart, address save/delete, password change and logout. Passwords use native scrypt (N=32768, r=8, p=3), random salt; sessions use random tokens stored as hashes, 14-day Secure/HttpOnly/SameSite cookies. Auth/action throttling and origin checks protect mutations. Prices are server-controlled ($5 USD). Payments and paid orders remain unconnected. No email verification/reset provider exists; UI states this explicitly.

Apply schema with `npm run db:migrate:remote`. Never log credentials, session tokens, addresses or password hashes.

Validation: 24 functional checks passed locally and against https://raehouser.com, including anonymous add-to-login continuation, two-account isolation, cart persistence after a new login, address save/delete, bad credentials, invalid SKU/quantity, cross-origin rejection and password-change session revocation. Browser confirmed pink selection redirects to login with pending color retained. Production QA accounts were deleted after testing.

## Independent project

Repository: https://github.com/HouserChiu/happy-pet-harbor

Install dependencies with `npm ci`. Start with `npm run dev`; deploy with `npm run deploy`. This checkout is independent of invest-tools. Cloudflare Worker, custom domains and production database remain unchanged.

## Checkout funnel, Stripe webhook and come-back offer — 2026-10-23

All buy buttons (product page and `/checkout/`) go through `/checkout/pay?color=…`, which counts the click and redirects to the color's Stripe Payment Link. For signed-in customers it appends `client_reference_id=<customer id>_<color>` and `prefilled_email`, plus `prefilled_promo_code` when an offer is active.

Funnel counters (daily, no personal data) live in the `events` table: `cart_add`, `checkout_view_address`, `checkout_view_no_address`, `pay_click`, `pay_click_guest`, `paid`, `paid_with_discount`, `offer_issued`. View the last 14 days with `npm run stats`. List the latest 50 paid orders with shipping details with `npm run orders`.

`POST /stripe/webhook` verifies the Stripe signature and, on a paid `checkout.session.completed`, stores the order (`orders`: Stripe session id, customer id, color, amount, discount, plus the email and shipping address collected by the Payment Link and the phone number — Stripe's, else the saved account address's) and removes that color from the customer's account cart. Without `STRIPE_WEBHOOK_SECRET` it answers 503 and the checkout page keeps the "cart will not clear automatically" note.

Come-back offer: if a signed-in customer with a saved address clicked a pay button, still has items in the cart and has no paid order 1 hour later, their next page view creates a single-use $0.50 Stripe promotion code that expires 48 hours later and shows it in a banner on every page (static pages via HTMLRewriter). One offer per customer, ever. It requires `STRIPE_SECRET_KEY` (restricted key, Promotion Codes write) and `STRIPE_COUPON_ID` (a $0.50 USD, duration "once" coupon); without them no offer is shown. Each Payment Link must have "Allow promotion codes" enabled.

Setup: `npm run db:migrate:remote` (an `orders` table created before the shipping columns also needs `npx wrangler d1 execute happy-pet-harbor-shop --remote --file=migrations/2026-10-23-order-shipping.sql`, once, before deploying), then `npx wrangler secret put STRIPE_WEBHOOK_SECRET` / `STRIPE_SECRET_KEY` / `STRIPE_COUPON_ID`. Webhook endpoint: `https://raehouser.com/stripe/webhook`, event `checkout.session.completed`. Tests: `HPH_WEBHOOK_SECRET=… python3 tests/shop-flow.py` also exercises a signed webhook (29 checks locally; set `NO_PROXY=localhost` if a proxy is configured).

Reminder email (Resend): a `*/15 * * * *` cron finds the same due customers, issues the offer and sends one email per customer from `hello@raehouser.com` (reply-to houserchiu@gmail.com) with `List-Unsubscribe` one-click headers; `/email/unsubscribe?t=…` opts out (`email_prefs`). It stays off until both secrets exist: `RESEND_API_KEY` and `MAIL_POSTAL_ADDRESS` (full postal address, required by CAN-SPAM in the footer). raehouser.com must be verified in Resend (DKIM `resend._domainkey` TXT and the `send` MX/SPF records in Cloudflare DNS). Counter: `offer_emailed`. Privacy notice updated 2026-10-23 for Stripe order records, Cloudflare Web Analytics, store-step counters and reminder emails.
