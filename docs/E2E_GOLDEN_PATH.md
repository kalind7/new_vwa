# Golden-path E2E validation (local)

## Prerequisites

1. Backend: `cd /home/kalind7/workspace/bike-wash && make up`
2. Flutter `.env`: `API_BASE_URL=http://localhost:8000/api/v1/` (or LAN IP for physical device)
3. Run `bash docs/api_smoke.sh` in bike-wash

## Mobile flow

1. Login as `user@user.com` / `secret`
2. Home → pick station → Book a slot → service → slot → checkout → COD
3. Admin: http://localhost:8000/admin/bookings → confirm booking status
4. My Wash → open booking → status updates within 30s (poll) or after pull-to-refresh
5. Notifications bell → booking update appears
6. Complete booking in admin → leave review from payment success path

## Admin flow

1. Dashboard shows today's KPIs and recent bookings
2. Bookings queue: filter by status, update to `confirmed` → `in_wash` → `completed`
3. Customer receives mobile notification on each status change
