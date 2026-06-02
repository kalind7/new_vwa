# API integration issues (live checks)

Base URL in app: `http://bike.yarsanptech.com/api/v1/`  
Postman collection: `Service Station Booking API` (local base `http://localhost:8000/api` — app uses `/v1/` prefix on production).

Checked: 2026-06-03

## Verified working (HTTP 200, no auth unless noted)

| Method | Path | Notes |
|--------|------|--------|
| GET | `service-stations` | Returns `success`, `data[]` with `products`, `operating_hours`, `services` |
| GET | `service-stations/{id}` | Full detail; use for saved-station resolution |

## Path corrections applied in app

| Old path | New path (Postman) | Status |
|----------|-------------------|--------|
| `user/ratings` | `ratings/my-ratings` | Old path **404** on production |
| `promo-codes/validate` | `bookings/validate-promo` | Updated per Postman |
| `locations` (alias `saveLocation`) | `locations` | Renamed constant only |

## Auth required (expected 401 without token)

| Method | Path |
|--------|------|
| GET | `ratings/my-ratings` |
| GET | `vehicles` |
| GET | `bookings` |
| GET | `auth/me` |
| POST | `auth/login` |

## Missing from backend (not in Postman collection)

| Feature | Issue |
|---------|--------|
| **Saved / favorite stations** | No `POST/GET/DELETE` favorites endpoint. App stores **station IDs only** locally and loads each via `GET service-stations/{id}`. |

## Not yet wired in mobile app

| Area | Postman paths |
|------|----------------|
| Rewards | `rewards/balance`, `rewards/transactions`, `rewards/redeem` |
| Admin | `admin/check-role`, `admin/bookings`, `admin/bookings/{id}/status`, `admin/queue` |
| OTP / reset password | Deferred by product (SMTP) |

## Data model notes

- API models live in `lib/features/main/data/models/service_station_api_models.dart` (from live JSON).
- `WashStationMock` is a **presentation** shape for existing widgets; when `USE_MOCK_DATA=false`, it is filled only from `ServiceStationMapper.toPresentation()` after parsing API JSON.
- `operating_hours[]` uses `day_of_week`, `open_time`, `close_time`, `is_closed`.
- `services[]` uses `service_name` / `name` (separate from `products[]`).

## Backend follow-ups for you

1. Confirm `bookings/validate-promo` and `payments/initiate` with a valid booking + auth token.
2. Confirm vehicle `POST`/`PUT` accept **JSON** (Postman uses JSON; older app used form-urlencoded).
3. Add favorites API if saved stations should sync across devices.
4. Confirm FCM route (`fcm-token` vs another path).
