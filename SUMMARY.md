# VWA Project Handoff Summary

## Project

- App name: Vehicle Washing App (VWA).
- Flutter project path: `/home/kalind7/visual_studio_projects/new_vwa/VWA`.
- Target platforms: Android and iOS only.
- Package/bundle ID: `com.kauwatech.vwa`.
- User runs on Android device:
  - Device: `M2006C3LI`
  - Device ID: `OJUSLVIVT4BE75JZ`
  - Command: `flutter run -d OJUSLVIVT4BE75JZ`
- Do not build APK/IPA unless the user explicitly requests it.

## User Rules

- Build UI first, API integration later.
- Static UI must replicate the Figma design before any API integration.
- Code must be modular and avoid repeated UI code.
- Update `PLAN.md` and `PROJECT_CONTEXT.txt` as the project progresses.
- Work in small testable milestones. Stop after each milestone for user testing.
- Use fonts, colors, spacing, and component styles from Figma.
- Keep UI responsive across small, large, and wide devices.
- User explicitly allowed the assistant to run the app after Milestone 3 to check runtime errors or UI mismatches.
- Do not commit unless the user explicitly asks.

## Figma

- Figma design: `Bike-wash`.
- URL: `https://www.figma.com/design/16x5FR5xF6mJQ550ZNbMmU/Bike-wash?node-id=7-3&p=f&t=jls461dL5JPLsXBX-0`
- File key: `16x5FR5xF6mJQ550ZNbMmU`.
- Starting node: `7:3`.
- Figma MCP data was fetched successfully.
- Important observed fonts:
  - Poppins
  - Inter
  - SF Pro Text
  - Montserrat
  - Roboto
  - Public Sans
  - Protest Strike
  - Mulish
- Important observed color tokens:
  - `#FFFFFF`
  - `#000000`
  - Gray scale
  - `Secondary/500 #1A1C1E`
  - `Secondary/400 #6C7278`
  - `Indigo/600 #444CE7`
  - `Error/500 #F04438`
  - Input border `#EDF1F3`

## Current Architecture

- State management: Provider.
- API client: Dio with soft HTTP error handling (`validateStatus` < 500) on station calls.
- Auth and app prefs: `shared_preferences` via `LocalStorageService` (access token, onboarding flag, remember-me credentials).
- `USE_MOCK_DATA` toggle in `assets/env/.env` switches auth between mock and live API.
- Local cache: Hive (planned/legacy; auth prefs are not in secure storage alone).
- Notifications: Firebase Core, Firebase Messaging, Flutter Local Notifications.
- Maps: Google Maps dependency is present; map search route is disabled during static/API early phase — Home search shows a toast instead.
- Payments planned: Khalti and eSewa.
- Fonts package: `google_fonts`.
- Feedback: `bot_toast` via `AppToast` (success green, error red, neutral gray400, bottom aligned).
- Loading UX: center-screen `AppLoadingOverlay` with `AppLogoProgressIndicator` (not button text spinners).

## Firebase

- Firebase project: `vehicle-washing-application`.
- Android Firebase app ID: `1:544772728837:android:9dedbae23c26ca8fa2d46c`.
- iOS Firebase app ID: `1:544772728837:ios:0466e254df1c2697a2d46c`.
- Native config files present:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- Flutter options file present:
  - `lib/firebase_options.dart`

## Completed Milestones

### Milestone 1: Design System and App Shell

Completed:

- Figma-derived colors: `lib/config/app_colors.dart`.
- Figma-derived text styles: `lib/config/app_text_styles.dart`.
- Spacing tokens: `lib/config/app_spacing.dart`.
- Radius tokens: `lib/config/app_radius.dart`.
- Responsive breakpoints: `lib/config/app_breakpoints.dart`.
- Theme updated: `lib/config/app_theme.dart`.
- Route shell added: `lib/app/app_routes.dart`.
- Reusable widgets:
  - `lib/shared/widgets/app_screen.dart`
  - `lib/shared/widgets/app_button.dart`
  - `lib/shared/widgets/app_text_field.dart`
  - `lib/shared/widgets/auth_tab_switcher.dart`
  - `lib/shared/widgets/app_logo_mark.dart`

Verification passed:

- `dart format`
- `flutter analyze`
- `flutter test`

### Milestone 2: Splash and Onboarding Flow

Completed:

- App starts at `SplashScreen`.
- Onboarding carousel has three slides:
  - Find nearby washing station
  - Easy payment and offers
  - Track your history
- Login and Sign Up buttons route to auth screens.
- Figma assets extracted:
  - `assets/images/onboarding/splash_logo.png`
  - `assets/images/onboarding/easy_payment.png`
  - `assets/images/onboarding/share_location.png`
  - `assets/images/onboarding/track_history.png`
- Assets registered in `pubspec.yaml`.

**Api-integration update:** Splash no longer uses a fixed delay or always routes to onboarding. `SplashNavigationResolver` + `has_seen_onboarding` in `LocalStorageService` decide: main shell (valid token), onboarding (first launch), or login.

Verification passed:

- `dart format`
- `flutter analyze`
- `flutter test`

## Responsive Foundation

Completed before Milestone 3:

- `AppBreakpoints` added with Figma design width `430`.
- `AppScreen` now centers and constrains content on wide devices.
- Narrow devices use tighter horizontal padding.
- Onboarding artwork scales by available height through `LayoutBuilder`.
- Auth screens use scrollable layouts to avoid small-phone overflow.

Verification passed:

- `dart format`
- `flutter analyze`
- `flutter test`

## Current State

- **Branch:** `Api-integration` (from `phase-5-static-flow`).
- **Phase:** Static UI largely complete; API integration in progress (auth + home stations done).
- **Current app entry routing:**
  - `SplashScreen` → instant token/onboarding check (no artificial delay)
  - Valid token → `mainShell` (dashboard)
  - No token + not seen onboarding → `OnboardingScreen`
  - No token + seen onboarding → `LoginScreen`
- **Post-auth routing:**
  - Login success → `mainShell`
  - Register success → `addVehicle` (OTP flow skipped for now)
- **Remember Me:** When checked, email and password saved in `LocalStorageService`; prefilled on return; **not** cleared on logout.
- **Logout:** `AuthRepository.logout()` clears access token only; onboarding flag and remember-me persist; app restart → login (not onboarding).
- Static auth route flow remains wired (login, sign up, forgot/reset, verify screens, add vehicle).
- Milestone 4 main shell: Home, My wash, Profile; Provider-backed `MainShellProvider`, `HomeProvider`, `StationSearchProvider`.
- Milestone 5 static booking/payment/review flows complete on prior branch; map search still disabled with toast.
- **API batch 1 (auth):** Login + register with fpdart `Either`, `AppToast`, token persistence via `LocalStorageService`.
- **API batch 2 (home stations):** `ApiWashStationRepository` with three tabs — All | Nearby | Less distance — and per-tab empty states.
- **Tests:** 33 passing (local storage, splash resolver, auth navigation, service station mapper, auth token persistence, and related unit/widget coverage).
- User runs live tests on device `OJUSLVIVT4BE75JZ`.

## API Integration (In Progress)

### Auth (complete for batch 1)

- Live login and register when `USE_MOCK_DATA=false`.
- Token saved/read through `LocalStorageService`.
- Subagent: `.cursor/agents/vwa-auth-flow-coordinator.md`.

### Home stations (complete for batch 1)

- **All** → `GET service-stations`
- **Nearby** → `GET service-stations/nearest` (lat/lng/radius)
- **Less distance** → `GET suggest-nearest` (Postman path; **not** `service-stations/suggest-nearest`, which returns 404)
- `suggest-nearest` requires auth + user location saved via `POST locations` before fetch.
- Response `data.suggested_stations[]` parsed by `ServiceStationMapper`.
- `HomeProvider.loadStations()` uses try/finally so loading always clears.

### Not started / next

- OTP send/verify, forgot-password API, vehicles/profile APIs.
- Station detail, booking, payments, notifications.
- Re-enable map screen when location/API map work begins.

## Next Required Work

- Continue API integration in small batches (confirm next endpoint group with user).
- Device review on `OJUSLVIVT4BE75JZ` for auth flows, remember-me, splash routing, and home station tabs (including Less distance after location POST).
- Add widget/unit tests one feature at a time as new APIs land.
- Re-enable map screen when API/location integration is ready.
- Do not build APK/IPA unless requested.

Latest verification:

- `flutter test` — 33 tests passing.
- Do not commit unless user asks.

## Important Files

- `PLAN.md`: detailed milestone plan.
- `PROJECT_CONTEXT.txt`: running project memory and latest instructions.
- `chat_summary.md`: detailed session log.
- `README.md`: project overview and run instructions.
- `lib/app/app_routes.dart`: route definitions.
- `lib/app/vwa_app.dart`: app shell.
- `lib/config/`: design tokens, theme, assets, responsive breakpoints.
- `lib/core/storage/local_storage_service.dart`: token, onboarding, remember-me prefs.
- `lib/core/network/api_paths.dart`: API paths including `suggest-nearest`, `locations`.
- `lib/core/di/app_dependencies.dart`: DI wiring for API repos and storage.
- `lib/features/onboarding/domain/splash_navigation_resolver.dart`: splash routing logic.
- `lib/features/onboarding/`: splash/onboarding implementation.
- `lib/features/auth/`: auth screens, repository, API integration.
- `lib/features/main/data/api_wash_station_repository.dart`: live station list per tab.
- `lib/features/main/data/models/service_station_mapper.dart`: API → domain mapping.
- `lib/shared/widgets/app_toast.dart`, `app_loading_overlay.dart`, `app_logo_progress_indicator.dart`.
- `test/`: unit and widget tests (storage, splash, auth nav, mapper, token persistence).
- `.cursor/agents/vwa-auth-flow-coordinator.md`, `vwa-api-integration.md`, `vwa-ui-form-guardian.md`, `vwa-popup-flow-guardian.md`.
