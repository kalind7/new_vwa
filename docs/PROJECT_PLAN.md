# Vehicle Washing App Project Plan

## Delivery Rules

- Target platforms are Android and iOS only.
- State management will use Provider.
- The app will use live APIs from Postman as the source of truth.
- Firebase is configured for Android and iOS and will be used for push notifications.
- I will not build APKs or create release builds unless you explicitly request it.
- The user explicitly allowed `flutter run -d OJUSLVIVT4BE75JZ` after Milestone 3 for runtime/UI smoke testing.
- After each feature integration, I will run static verification such as `flutter analyze` and focused tests.

## Foundation

1. Configure dependencies for API, Provider state, secure storage, local cache, maps, Firebase notifications, and tests.
2. Keep environment values in `assets/env/.env` during development, then move real secrets to secure CI or platform config before release.
3. Use a feature-first structure under `lib/features`.
4. Use shared infrastructure under `lib/core`, `lib/config`, and `lib/shared`.

## Feature Order

1. Authentication
   - Email/password login.
   - Sign up.
   - Token storage with `flutter_secure_storage`.
   - Dio authorization interceptor.

2. Home, Stations, and Search
   - Station list API.
   - Search and filter.
   - Station detail page.
   - Loading, empty, and error states.

3. Google Maps
   - Location permission handling.
   - Show washing stations as map markers.
   - Navigate to selected station using external maps.

4. Booking
   - Service selection.
   - Date/time slot selection.
   - Booking confirmation.
   - Booking history.

5. Payments
   - Khalti integration.
   - eSewa integration.
   - Backend payment verification before marking booking as paid.

6. Notifications
   - Firebase Cloud Messaging setup.
   - Foreground local notification display.
   - Device token registration API.

7. Polish and Release Readiness
   - Figma UI matching.
   - Error handling and validations.
   - Unit and widget tests for auth, booking, and payments.
   - Android/iOS configuration review.

## Verification After Each Feature

- `flutter analyze`
- Focused unit/widget tests for the touched feature
- Manual run from the user side unless the user explicitly allows assistant runtime smoke testing.

## Current Setup Status

- Flutter app created as `vwa`.
- Android package path is `com.kauwatech.vwa`.
- Provider foundation added.
- Firebase notification dependencies, native config files, and service skeleton added.
- Android Firebase app ID: `1:544772728837:android:9dedbae23c26ca8fa2d46c`.
- iOS Firebase app ID: `1:544772728837:ios:0466e254df1c2697a2d46c`.
- API client and secure token storage skeleton added.
- Milestone 1 design system and app shell completed.
- Milestone 2 splash/onboarding flow completed.
- Milestone 3 static auth screens implemented with no API integration.
- Current branch `authentication-fixes` adjusts splash duration, auth white panel height on larger phones, add-vehicle multiple number entry, tap-to-dismiss keyboards, 10-digit phone validation, and six-box OTP entry before Milestone 4.
- Current branch `phase-4-main-shell` adds the static logged-in Home/My wash/Profile shell, reworks Home from the attached Droplet page, requests location automatically inside Home, resolves the displayed location into area/city text, adds compact station tabs and a filter icon, fixes station-card overflow, moves Phase 4 main state into Provider, introduces a station repository boundary for later API data, and routes search/station cards to marker-based map/detail placeholders.
- Latest verification passed: `dart format`, `flutter analyze`, and `flutter test`.
