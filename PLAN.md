# Vehicle Washing App Implementation Plan

## Primary Workflow

The project will be built in two major phases:

1. Static UI/UX replica from Figma.
2. API integration after all screens are visually complete.

No API integration should begin until the Figma-based static screens are completed, reviewed, and accepted.

## Phase 1: Static Figma UI/UX Replica

Goal: Build a pixel-perfect Flutter implementation of the Figma design using static/mock data only.

### Rules

- Match the Figma design as closely as possible before adding backend behavior.
- Keep UI code modular, reusable, and feature-based.
- Use Provider only where screen state is needed for UI interactions.
- Avoid hardcoding repeated styles inside screens.
- Extract shared colors, typography, spacing, buttons, inputs, cards, and layout components.
- Use mock models/data for lists, cards, bookings, station details, and profile screens.
- Keep the app Android/iOS focused.
- Use fonts, colors, spacing, and component styles extracted from the Figma file instead of guessed values.
- Build the UI in small testable milestones; do not attempt the full UI in one large pass.

### Suggested UI Structure

```text
lib/
├── app/
├── config/
│   ├── app_theme.dart
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_spacing.dart
├── core/
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   └── data/mock/
│   ├── home/
│   ├── stations/
│   ├── booking/
│   ├── payments/
│   ├── profile/
│   ├── notifications/
│   └── onboarding/
└── shared/
    ├── widgets/
    ├── models/
    └── mock/
```

### UI Development Order

1. Design system
   - Colors from Figma.
   - Typography.
   - Spacing.
   - Border radius.
   - Shadows.
   - Icons/assets.

2. Shared components
   - Primary/secondary buttons.
   - Text fields.
   - Password fields.
   - App bars.
   - Bottom navigation.
   - Cards.
   - Loading placeholders.
   - Empty/error states.

3. Static screens
   - Splash/onboarding if present in Figma.
   - Login.
   - Sign up.
   - Forgot password if present.
   - Home.
   - Station list/search.
   - Station detail.
   - Map screen shell.
   - Service selection.
   - Date/time selection.
   - Booking summary.
   - Payment method selection.
   - Payment success/failure.
   - Booking history.
   - Profile.
   - Notifications.
   - Support/help if present.

4. Static flow wiring
   - Add navigation between screens.
   - Use mock data.
   - Preserve visual behavior without live APIs.
   - Validate responsive behavior on different phone sizes.

5. UI review checkpoint
   - Compare all screens against Figma.
   - Fix spacing, typography, colors, and alignment.
   - Only after approval, proceed to API integration.

## Phase 2: API Integration

Goal: Replace mock data with live APIs from the Postman collection.

### API Integration Order

1. Authentication
   - Login.
   - Sign up.
   - Token storage.
   - Logout.

2. User and profile
   - Fetch user profile.
   - Update user profile.

3. Stations
   - Station list.
   - Search/filter.
   - Station detail.

4. Booking
   - Services.
   - Time slots.
   - Create booking.
   - Booking history.

5. Payments
   - Khalti.
   - eSewa.
   - Backend payment verification.

6. Maps and location
   - Live station coordinates.
   - User location.
   - External navigation.

7. Firebase notifications
   - FCM token.
   - Register token with backend.
   - Foreground notification handling.

## Verification Strategy

After each feature or group of screens:

- Run static analysis when possible: `flutter analyze`.
- Run focused widget tests where useful.
- The assistant should not run the app during Milestones 1 and 2.
- After Milestone 3, the user has explicitly allowed the assistant to run the app for runtime/UI mismatch checks.
- Do not build APK/IPA from the assistant side.
- The user will run manually on the Android device.
- Keep UI responsive across small, large, and wide devices by constraining content to the Figma mobile design width and allowing safe scrolling where needed.

## Responsive Layout Rules

- Use the Figma design width of `430` as the mobile content baseline.
- Center and constrain mobile content on wide screens instead of stretching layouts.
- Use adaptive horizontal padding: smaller padding on narrow phones, Figma padding on normal phones.
- Use `LayoutBuilder` for image-heavy screens so artwork scales down on compact-height devices.
- Prefer safe scrolling for long auth forms to avoid overflow on small phones.
- Milestone 3 auth screens must follow these rules from the start.

## Current Decision

The next implementation work should focus only on modular static UI/UX based on the Figma design. API integration comes after the static UI is complete.

## Figma Access Status

- The target design is expected to be the `Bike-wash` Figma project.
- Figma file key: `16x5FR5xF6mJQ550ZNbMmU`.
- Starting node: `7:3`.
- Figma data has been fetched through MCP.
- The implementation must use Figma fonts and colors. Primary observed fonts include Poppins, Inter, SF Pro Text, Montserrat, Roboto, Public Sans, Protest Strike, and Mulish.

## Testable UI Milestones

### Milestone 1: Design System and App Shell

Build only the reusable UI foundation first.

- Status: Complete and ready for user testing.
- Extracted Figma colors into `lib/config/app_colors.dart`.
- Extracted Figma typography into `lib/config/app_text_styles.dart`.
- Added spacing/radius constants in shared config files.
- Replaced the default counter shell with a clean app shell and named route structure.
- Added reusable base components:
  - App button.
  - App text field.
  - Auth tab switcher.
  - Screen scaffold/safe-area wrapper.
- Added a visible foundation preview screen for local testing.
- Verification passed: `flutter analyze` and `flutter test`.

Review checkpoint: you run the app and confirm the foundation loads without visual/runtime issues.

### Milestone 2: Splash and Onboarding Flow

Build the first user-facing flow with static data.

- Status: Complete and ready for user testing.
- Splash screen added as the app entry route.
- Onboarding carousel added from the Figma sequence.
- Login and Sign Up buttons added.
- Static navigation from splash/onboarding to login/signup placeholder routes added.
- Figma assets extracted:
  - `assets/images/onboarding/splash_logo.png`
  - `assets/images/onboarding/easy_payment.png`
  - `assets/images/onboarding/share_location.png`
  - `assets/images/onboarding/track_history.png`
- Verification passed: `flutter analyze` and `flutter test`.

Review checkpoint: you test the startup flow and onboarding navigation.

### Milestone 3: Auth Static Screens

Build all auth-related screens without APIs.

- Status: Implemented with static validation and keyboard-safe form behavior; Android runtime smoke check in progress.
- Added static Figma-inspired auth layout with dark header, rounded white content sheet, tab switcher, form inputs, OTP boxes, password rules, and setup-profile vehicle screen.
- Replaced placeholder auth routes with real static routes:
  - Login.
  - Sign up.
  - Forgot password / send OTP.
  - Verify email.
  - Verify OTP.
  - Reset password.
  - Add vehicle number.
  - Back-to-login transitions.
- Kept behavior static/mock only. No API integration has started.
- Added static form validation for login, sign up, forgot password/send OTP, reset password, and add vehicle number.
- Connected current buttons, links, resend controls, upload picture, and preview controls to validation, navigation, or mock feedback.
- Updated auth and profile setup layouts to stay scrollable and visible when the keyboard is open.
- Added project subagent `.cursor/agents/vwa-ui-form-guardian.md` for future auth/UI validation, button, and keyboard safety reviews.
- Verification passed so far: `dart format`, `flutter analyze`, and `flutter test`.
- Remaining Milestone 3 verification: finish `flutter run -d OJUSLVIVT4BE75JZ --no-resident` for Android runtime/UI smoke testing if the device run completes.
- Current user request also asks to create or reuse a GitHub repository named `new-vwa` and push the code there after verification.

Review checkpoint: you test all auth navigation paths and form visuals.

### Milestone 4: Main App Shell

Build the static logged-in area.

- Home page.
- Bottom navbar with three tabs.
- Home tab with location info and search button.
- Wash tab with bike wash status.
- Settings/Profile tab.

Review checkpoint: you test navbar switching and static screen layout.

### Milestone 5: Map and Wash Detail Static Screens

Build the remaining static screens needed before API integration.

- Map page reached from home search button.
- Wash summary/status detail.
- Wash detail screens.
- Profile/settings sub-pages visible in Figma.

Review checkpoint: full static UI flow is reviewed against Figma before API work begins.
