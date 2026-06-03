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

## API error responses (use in app toasts)

Laravel-style JSON on failed requests (401, 403, 404, 422, 5xx). The app reads these via `messageFromApiResponse` / `mapDioException` — do not replace with generic login copy.

| Status | Typical `message` | App failure type |
|--------|-------------------|------------------|
| 401 | `Unauthenticated.` (no token) or `These credentials do not match our records.` (login) | `UnauthorizedFailure` |
| 403 | Permission denied text from API | `UnknownFailure` |
| 404 | e.g. `Service station not found.` | `UnknownFailure` |
| 422 | `message` may be generic (`Validation error`); **prefer** `errors: { field: ["…"] }` joined for toast | `ValidationFailure` (API field rules only) |

When `errors` has multiple fields, the app shows one compact toast: `msg1 · msg2` (not the generic headline alone).
| 500+ | Server message when present | `ServerFailure` |

Client-side form checks (empty name, missing vehicle plate) stay as local `ValidationFailure` strings in repositories — not mixed with HTTP 422 handling.

Success responses use `success: true` and `data` (200/201); errors are not shown as toasts on success.

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
