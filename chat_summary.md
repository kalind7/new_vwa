# VWA Chat Summary

## Project Snapshot

- Project: Vehicle Washing App (VWA), a Flutter app for Android and iOS.
- Workspace: `/home/kalind7/visual_studio_projects/new_vwa/VWA`.
- Package/bundle ID: `com.kauwatech.vwa`.
- Preferred Android test device: `M2006C3LI`, device ID `OJUSLVIVT4BE75JZ`.
- Run command: `flutter run -d OJUSLVIVT4BE75JZ`.
- Do not build APK/IPA unless explicitly requested.
- Static Figma UI phases largely complete; API integration in progress on `Api-integration`.

## Figma Context

- Figma project: `Bike-wash`.
- File key: `16x5FR5xF6mJQ550ZNbMmU`.
- Starting node: `7:3`.
- Main rule: match Figma colors, fonts, icons, spacing, and UX as closely as possible.
- Important observed tokens:
  - `Secondary/500 #1A1C1E`
  - `Secondary/400 #6C7278`
  - `Indigo/600 #444CE7`
  - `Error/500 #F04438`
  - `Brand/500 #FF5656`
  - Input border `#EDF1F3`
- Important fonts observed: Poppins, Inter, SF Pro Text, Montserrat, Roboto, Public Sans, Protest Strike, Mulish.

## Branches And Remote

- `main`: initial project baseline.
- `authentication-fixes`: auth UI fixes (merged/superseded by later work).
- `phase-4-main-shell`: main shell + Home UI.
- `phase-5-static-flow`: static booking/payment/review flows.
- **`Api-integration`**: current working branch — auth API + home stations API.
- Remote origin: `https://github.com/kalind7/new_vwa.git`.
- Do not commit unless the user explicitly asks.

## Completed Work (Prior Milestones)

### Milestone 1: Foundation

- Design tokens under `lib/config/`.
- Shared widgets: `AppScreen`, `AppButton`, `AppTextField`, `AuthTabSwitcher`, `AppLogoMark`.
- Named routing in `lib/app/app_routes.dart`.
- Responsive baseline using Figma width `430`.

### Milestone 2: Splash And Onboarding

- Onboarding carousel (three slides), assets in `pubspec.yaml`.
- **Updated:** Splash uses `SplashNavigationResolver` — not always → onboarding; no fixed 2.4s delay.

### Milestone 3: Auth Static Screens

- Full static auth screen set, validators, OTP boxes, multi-vehicle add, keyboard-safe layouts.
- Subagent: `vwa-ui-form-guardian.md`.

### Milestone 4: Main App Shell

- Home / My wash / Profile bottom nav; Droplet-style Home; Provider state; map search (route later disabled).
- `WashStationRepository` abstraction.

### Milestone 5: Static Booking Flow

- Checkout, billing, payment confirmed, booking success/info, leave review, feedback thanks.
- Map route disabled with toast; `AppScreenHeader` back placement ~24px below status bar.
- Subagent: `vwa-popup-flow-guardian.md`.

## Latest Session: Api-integration (Auth + Home Stations)

### Auth flow finalization

- **Onboarding once:** `has_seen_onboarding` in `LocalStorageService` (`shared_preferences`); splash uses `SplashNavigationResolver`.
- **Token storage:** Migrated to `LocalStorageService` / `shared_preferences` (not sole `flutter_secure_storage`).
- **Splash:** Removed artificial delay; instant token check → `mainShell` / onboarding / login.
- **Login success** → `mainShell` (dashboard).
- **Register success** → `addVehicle` (OTP skipped for now).
- **Remember Me:** Saves email+password when checked; prefills on return; **not** cleared on logout.
- **Logout:** Clears token only via `AuthRepository.logout()`; onboarding + remember-me persist; restart → login (not onboarding).
- **Loading UX:** Center-screen `AppLoadingOverlay` + `AppLogoProgressIndicator` (CircularProgressIndicator + logo); not button text spinners.
- **Toasts:** `bot_toast` via `AppToast` — success green, error red, neutral gray400; bottom aligned.
- **Subagent created:** `.cursor/agents/vwa-auth-flow-coordinator.md`.

### API integration batch 1 — Auth

- Login + register with fpdart `Either<Failure, T>`, `AppToast`, token persistence.
- `USE_MOCK_DATA` toggle in `assets/env/.env`.

### API integration batch 2 — Home stations

- Three tabs in one row: **All** | **Nearby** | **Less distance** + filter (Expanded/Flexible, no overflow).
- Endpoints:
  - All → `GET service-stations`
  - Nearby → `GET service-stations/nearest` (lat/lng/radius)
  - Less distance → `GET suggest-nearest` (Postman path; **not** `service-stations/suggest-nearest` — 404)
- `suggest-nearest` requires auth + saved user location via `POST locations` before fetch.
- Response `data.suggested_stations[]` parsed by `ServiceStationMapper`.
- `ApiWashStationRepository` with soft HTTP error handling (`validateStatus` < 500).
- Per-tab empty states; `HomeProvider.loadStations()` uses try/finally so loading always clears.

### Testing discipline

- **33 passing tests**, including: local storage, splash resolver, auth navigation, service station mapper, auth token persistence.
- Going forward: unit + widget tests one feature at a time.

## Important New/Updated Files (This Session)

- `lib/core/storage/local_storage_service.dart`
- `lib/features/onboarding/domain/splash_navigation_resolver.dart`
- `lib/shared/widgets/app_toast.dart`
- `lib/shared/widgets/app_loading_overlay.dart`
- `lib/shared/widgets/app_logo_progress_indicator.dart`
- `lib/features/main/data/api_wash_station_repository.dart`
- `lib/features/main/data/models/service_station_mapper.dart`
- `lib/core/network/api_paths.dart` (`suggest-nearest`, `locations`)
- `lib/core/di/app_dependencies.dart`
- `test/` — storage, splash, auth nav, mapper, token tests
- `.cursor/agents/vwa-auth-flow-coordinator.md`

## Current Verification Status

- `flutter test` — 33 tests passing.
- User runs live tests on device `OJUSLVIVT4BE75JZ`.
- Map search still disabled; Home search shows toast.

## Current Git State

- Branch: `Api-integration` (from `phase-5-static-flow`).
- API auth + home stations integrated; docs updated this session.
- Do not commit unless the user explicitly asks.

## Next Best Step

- Device review: splash routing (token / onboarding / login), remember-me, login → main shell, register → add vehicle, logout → login on restart.
- Home: test All / Nearby / Less distance tabs; confirm Less distance after location POST succeeds.
- Confirm next API batch with user (OTP, profile/vehicles, station detail, booking, etc.).
- Re-enable map when map/location API work begins.
