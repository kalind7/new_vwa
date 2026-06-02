# VWA Chat Summary

## Project Snapshot

- Project: Vehicle Washing App (VWA), a Flutter app for Android and iOS.
- Workspace: `/home/kalind7/visual_studio_projects/new_vwa/VWA`.
- Package/bundle ID: `com.kauwatech.vwa`.
- Preferred Android test device: `M2006C3LI`, device ID `OJUSLVIVT4BE75JZ`.
- Run command: `flutter run -d OJUSLVIVT4BE75JZ`.
- Do not build APK/IPA unless explicitly requested.
- Build static Figma UI first. API integration starts only after static UI is reviewed and accepted.

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
- `authentication-fixes`: finalized auth UI fixes and pushed to `origin/authentication-fixes`.
- `phase-4-main-shell`: current working branch for Phase 4.
- Remote origin: `https://github.com/kalind7/new_vwa.git`.
- `gh` CLI is not installed, so PR creation from terminal was blocked. GitHub branch push worked.

## Completed Work

### Milestone 1: Foundation

- Added design tokens under `lib/config/`.
- Added shared widgets:
  - `AppScreen`
  - `AppButton`
  - `AppTextField`
  - `AuthTabSwitcher`
  - `AppLogoMark`
- Added named routing in `lib/app/app_routes.dart`.
- Added responsive baseline using Figma width `430`.

### Milestone 2: Splash And Onboarding

- App starts at `SplashScreen`, then routes to onboarding.
- Splash duration is currently extended by one second for static review.
- Onboarding has three slides and routes to login/sign-up.
- Onboarding assets are registered in `pubspec.yaml`.

### Milestone 3: Auth Static Screens

- Implemented static/mock auth screens:
  - Login
  - Sign up
  - Forgot password / send OTP
  - Verify email
  - Verify OTP
  - Reset password
  - Add vehicle number
- Added reusable auth layout/widgets under `lib/features/auth/presentation/widgets`.
- Added static validators under `lib/features/auth/presentation/utils/auth_form_validators.dart`.
- Added form validation, workable mock buttons, keyboard-safe layouts, and tap-outside keyboard dismiss behavior.
- Phone input is digits-only, max 10 digits, and validates exactly 10 digits.
- OTP now uses reusable six-square editable OTP boxes with validation.
- Add-vehicle supports multiple vehicle numbers with plus/minus controls.
- Completed auth/profile setup routes into the main shell.
- Created project subagent `.cursor/agents/vwa-ui-form-guardian.md` for future form validation/button/keyboard reviews.

### Milestone 4: Main Shell In Progress

- Current branch: `phase-4-main-shell`.
- Added static logged-in shell with bottom nav:
  - Home
  - My wash
  - Profile
- After user tested the first Home implementation, the UI was corrected to use the attached Droplet/Home Figma page as the base.
- User approved the corrected Home direction, then requested location/map fixes and a Provider refactor before moving on.
- Home now includes:
  - Blue-to-white header.
  - Avatar and greeting: `Hello`, `Ankit Shrestha`.
  - Search and notification icons.
  - White station-list body.
  - Large vertical nearby station cards.
  - Figma station image asset.
  - Red selected navbar color `#FF5656`.
- Home now requests location permission automatically after entering the Home tab; there is no separate location gate screen between auth and Home.
- The Home location pill resolves the device location with `geolocator`/`geocoding` into area/city text. It no longer falls back to showing raw latitude/longitude in the UI.
- If location permission is denied once, Home automatically asks again. If permission is permanently denied, it prompts the user to open app settings.
- The Home station heading was changed into compact tabs: `Nearby Station` and `Less distance`.
- Added the missing Home filter/tune icon with mock-only feedback.
- Station cards were adjusted to avoid render overflow in the rating/distance/price/slots row.
- Search opens a marker-based Flutter Map/OpenStreetMap station search page.
- The map page initially shows only the map and station markers. Search results appear only while searching; selecting a result moves the map and opens a bottom station sheet that routes to station detail.
- Phase 4 main state has been moved from local `setState` into Provider:
  - `MainShellProvider` for bottom-tab selection.
  - `HomeProvider` for location, station loading, and Home station tabs.
  - `StationSearchProvider` for map search query, results visibility, and selected station.
- Added `WashStationRepository` with `MockWashStationRepository` so the current mock station data can later be replaced by API data with less UI churn.
- Station cards open a static station detail page.
- My wash tab has booked/completed summary and static wash booking cards.
- Profile tab has avatar/add affordance, user identity, profile setting, payments history, reviews, and logout rows.

### Milestone 5: Static Booking Flow Started

- Current branch: `phase-5-static-flow`.
- Added `flutter_svg` and shared `AppSvgIcon` wrapper so new/main visible icons use an SVG pathway rather than ad hoc Material icons.
- Added route-managed static screens:
  - Service selection.
  - Slot selection.
  - Booking summary.
  - Payment method.
  - Payment result.
  - Wash detail.
- Added `BookingFlowProvider` and static booking mock models for Provider-backed service, slot, and payment selection.
- Added shared modal components:
  - `AppConfirmationDialog` / `showAppConfirmationDialog`.
  - `AppActionBottomSheet` / `showAppActionBottomSheet`.
- Added exit confirmation dialogs on Login and Main Shell with centered logo mark and exactly `Yes` / `No`.
- Added logout confirmation dialog in Profile.
- Booking payment confirmation and cancel booking mock action now use the shared bottom-sheet component.
- Added `.cursor/agents/vwa-popup-flow-guardian.md` for popup/dialog/bottom-sheet consistency reviews.

## Important New Files

- `lib/features/main/data/main_shell_mock_data.dart`
- `lib/features/main/data/wash_station_repository.dart`
- `lib/features/main/presentation/providers/home_provider.dart`
- `lib/features/main/presentation/providers/main_shell_provider.dart`
- `lib/features/main/presentation/providers/station_search_provider.dart`
- `lib/features/main/presentation/screens/main_shell_screen.dart`
- `lib/features/main/presentation/screens/home_tab.dart`
- `lib/features/main/presentation/screens/my_wash_tab.dart`
- `lib/features/main/presentation/screens/profile_tab.dart`
- `lib/features/main/presentation/screens/station_search_map_screen.dart`
- `lib/features/main/presentation/screens/station_detail_screen.dart`
- `lib/features/main/presentation/widgets/main_bottom_nav.dart`
- `lib/features/main/presentation/widgets/station_card.dart`
- `lib/features/main/presentation/widgets/wash_booking_card.dart`
- `assets/images/main/home-avatar.png`
- `assets/images/main/station-bike-wash.png`

## Current Verification Status

## Latest Session (Post-Booking Static UI)

User provided Figma screenshots for missing post-booking screens and requested:

- Complete static UI for checkout, billing method, payment confirmed, booking success, booking info, leave review, and feedback thanks.
- Wire navigation from station booking popup and My Wash detail checkout.
- Fix detail page back/save header placement (~20–30px from top).
- Disable map page with toast on navigation attempt.
- Run `dart analyze` / `flutter test` (not `flutter run` or APK build).
- Update project context docs.

Implemented:

- `booking_summary_screen.dart` — Figma checkout with wash summary (station + duration), expandable promo code, Apply button.
- `payment_method_screen.dart` — billing method list (Khalti, eSewa, Cash on Delivery); tap + confirm navigates forward.
- `payment_result_screen.dart` — Payment Confirmed with green check, Go to home, Leave a review.
- `booking_success_screen.dart` / `BookingInfoScreen` — slot booked success variants.
- `leave_review_screen.dart` / `feedback_thanks_screen.dart` — star rating, comment, submit, thank-you Done.
- `AppScreenHeader` / `buildAppScreenHeader` — back button ~24px below status bar.
- `AppSuccessIcon`, `AppFlowCloseHeader` shared widgets.
- `map_navigation.dart` — toast stub; map route disabled in `app_routes.dart`.
- My Wash detail Check out → `AppRoutes.bookingSummary` via `bookingDraftFromWashBooking`.
- Cash on Delivery → booking info screen; Khalti/eSewa → payment confirmed.

Verification:

- `dart analyze` — no issues.
- `flutter test` — passed.

## Current Git State

- Branch: `phase-5-static-flow`.
- Uncommitted Phase 5 changes include post-booking screens, header fixes, map disable stub, route wiring, and doc updates.
- Do not commit unless the user explicitly asks.

## Next Best Step

Device review on Android:

- Full booking flow from station detail through payment/review.
- My Wash checkout entry.
- Header placement and success screen visuals vs Figma.
- If approved → API integration phase; re-enable map when ready.

