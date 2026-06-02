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
- API client: Dio.
- Secure token storage: `flutter_secure_storage`.
- Local cache: Hive.
- Notifications: Firebase Core, Firebase Messaging, Flutter Local Notifications.
- Maps: Google Maps dependency is present; current static map UI uses Flutter Map/OpenStreetMap with Geolocator and Geocoding.
- Payments planned: Khalti and eSewa.
- Fonts package: `google_fonts`.

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
- Splash auto-navigates to `OnboardingScreen`.
- Onboarding carousel has three slides:
  - Find nearby washing station
  - Easy payment and offers
  - Track your history
- Login and Sign Up buttons route to temporary placeholder auth screens.
- Figma assets extracted:
  - `assets/images/onboarding/splash_logo.png`
  - `assets/images/onboarding/easy_payment.png`
  - `assets/images/onboarding/share_location.png`
  - `assets/images/onboarding/track_history.png`
- Assets registered in `pubspec.yaml`.

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
- Auth screens in Milestone 3 should use scrollable layouts to avoid small-phone overflow.

Verification passed:

- `dart format`
- `flutter analyze`
- `flutter test`

## Current State

- Current app entry:
  - `SplashScreen` -> `OnboardingScreen`
- Login and Sign Up routes now open real static auth screens.
- Static auth route flow is wired:
  - Login
  - Sign up
  - Forgot password / send OTP
  - Verify email
  - Verify OTP
  - Reset password
  - Add vehicle number
  - Back-to-login transitions
- API integration has not started.
- Milestone 3 implementation has received a pre-Milestone-4 auth finalization pass on branch `authentication-fixes`.
- Latest fixes increase static splash visibility, make auth white content panels fill the remaining screen height on larger phones, allow multiple vehicle numbers with plus/minus controls, dismiss keyboards on scaffold taps, enforce exactly 10-digit phone numbers, and add validated six-box OTP entry.
- Milestone 4 main app shell has started on branch `phase-4-main-shell`.
- Static logged-in shell now includes Home, My wash, and Profile tabs. Home was reworked from the attached Droplet page: blue-to-white header, Figma station imagery, red `Brand/500 #FF5656` active nav state, automatic in-Home location permission request, geocoded area/city location label, compact `Nearby Station`/`Less distance` tabs, filter icon, marker-based map search route, and station-to-detail route.
- Phase 4 main state is now Provider-backed through `MainShellProvider`, `HomeProvider`, and `StationSearchProvider`. Station data is read through `WashStationRepository` / `MockWashStationRepository` so later API integration can replace the mock source without rewriting the UI.
- Milestone 5 has advanced on branch `phase-5-static-flow` with Figma-aligned station detail, profile/settings sub-pages, full post-booking static flow (checkout, billing, payment confirmed, booking success/info, leave review, feedback thanks), My Wash detail with checkout wiring, and shared popup/header components.
- Map search route is disabled during static UI phase; Home search shows a toast instead of opening the map screen.
- `AppScreenHeader` back button placement fixed to ~24px below the status bar across detail and booking screens.

## Next Required Work

Finish Milestone 5 device review:

- Run the app on the connected Android phone to check the full flow: station detail → book → service → slot → checkout → billing → payment confirmed → leave review → feedback thanks.
- Test My Wash detail → Check out → same checkout flow.
- Confirm header back button placement and success/confirmation screen layouts against Figma screenshots.
- Re-enable map screen and integrate live APIs only after static UI approval.
- Do not integrate APIs yet.
- Do not build APK/IPA.

Latest verification (post-booking flow pass):

- `dart analyze` — no issues.
- `flutter test` — passed.

## Important Files

- `PLAN.md`: detailed milestone plan.
- `PROJECT_CONTEXT.txt`: running project memory and latest instructions.
- `README.md`: project overview and run instructions.
- `lib/app/app_routes.dart`: route definitions.
- `lib/app/vwa_app.dart`: app shell.
- `lib/config/`: design tokens, theme, assets, responsive breakpoints.
- `lib/features/onboarding/`: splash/onboarding implementation.
- `lib/features/auth/presentation/screens/`: Milestone 3 static auth screens.
- `lib/features/auth/presentation/widgets/`: reusable auth layout, form helpers, and OTP boxes.
