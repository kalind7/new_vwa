# Vehicle Washing App Project Plan

## Delivery Rules

- Target platforms are Android and iOS only.
- State management will use Provider.
- The app will use live APIs from Postman as the source of truth.
- Firebase is configured for Android and iOS and will be used for push notifications.
- I will not build APKs or create release builds unless you explicitly request it.
- The user explicitly allowed `flutter run -d OJUSLVIVT4BE75JZ` after Milestone 3 for runtime/UI smoke testing.
- After each feature integration, I will run static verification such as `flutter analyze` and focused tests.
- Do not commit unless the user explicitly asks.

## Foundation

1. Configure dependencies for API, Provider state, local preferences, local cache, maps, Firebase notifications, and tests.
2. Keep environment values in `assets/env/.env` during development (`USE_MOCK_DATA` toggle), then move real secrets to secure CI or platform config before release.
3. Use a feature-first structure under `lib/features`.
4. Use shared infrastructure under `lib/core`, `lib/config`, and `lib/shared`.

## Feature Order

1. Authentication
   - Email/password login. **Done (batch 1).**
   - Sign up. **Done (batch 1).**
   - Token storage with `LocalStorageService` (`shared_preferences`). **Done.**
   - Remember Me, onboarding-once flag, splash resolver, logout (token-only). **Done.**
   - Dio authorization interceptor. **In use.**
   - OTP send/verify, forgot-password API. **Not started.**

2. Home, Stations, and Search
   - Station list API (All / Nearby / Less distance tabs). **Done (batch 2).**
   - `POST locations` before suggest-nearest. **Done.**
   - Search/filter UI (filter icon present; map search disabled with toast). **Partial.**
   - Station detail API. **Not started.**
   - Loading, empty, and error states per tab. **Done for list.**

3. Google Maps
   - Location permission handling (in-Home geolocation for label and nearest APIs). **Partial.**
   - Show washing stations as map markers. **Not started — map route disabled.**
   - Navigate to selected station using external maps. **Static UI only.**

4. Booking
   - Service selection.
   - Date/time slot selection.
   - Create booking.
   - Booking history.
   - Static UI complete; APIs not started.

5. Payments
   - Khalti integration.
   - eSewa integration.
   - Backend payment verification before marking booking as paid.
   - Static billing UI complete; APIs not started.

6. Notifications
   - Firebase Cloud Messaging setup.
   - Foreground local notification display.
   - Device token registration API.

7. Polish and Release Readiness
   - Figma UI matching.
   - Error handling and validations (`AppToast`, soft HTTP on stations).
   - Unit and widget tests — **33 passing**; add per feature going forward.
   - Android/iOS configuration review.

## Verification After Each Feature

- `flutter analyze` when code changes.
- Focused unit/widget tests for the touched feature (one feature at a time).
- Manual run from the user side on device `OJUSLVIVT4BE75JZ`.

## Current Setup Status

- Flutter app created as `vwa`.
- Android package path is `com.kauwatech.vwa`.
- Provider foundation added.
- Firebase notification dependencies, native config files, and service skeleton added.
- Milestones 1–5 static UI completed across branches `authentication-fixes`, `phase-4-main-shell`, `phase-5-static-flow`.
- **Current branch: `Api-integration`** — API work in progress.
- **API batch 1 (auth):** Login/register with fpdart `Either`, `AppToast`, `AppLoadingOverlay`, token via `LocalStorageService`, `SplashNavigationResolver`, remember-me, onboarding-once, post-auth routes (login → main shell, register → add vehicle).
- **API batch 2 (home stations):** `ApiWashStationRepository`, three tabs (All → `service-stations`, Nearby → `service-stations/nearest`, Less distance → `suggest-nearest`), `ServiceStationMapper`, `api_paths.dart` including `locations` POST.
- Map search route remains disabled; Home search shows toast.
- Latest verification: `flutter test` — 33 tests passing.
- Remaining API work: OTP, profile/vehicles, station detail, booking, payments, FCM; re-enable map when location/map APIs begin.
- User runs live device tests; assistant does not commit unless asked.
