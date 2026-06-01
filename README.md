# Vehicle Washing App (VWA)

VWA is a Flutter mobile application for a service-oriented vehicle washing business. The app will let users search washing stations, view station details, book washing services, pay through Nepali wallets, receive Firebase notifications, and navigate to stations using Google Maps.

## Platforms

This project targets Android and iOS only.

Current package/bundle identifier:

- Android: `com.kauwatech.vwa`
- iOS: `com.kauwatech.vwa`

## Tech Stack

- Flutter
- Provider for state management
- Dio for API integration
- Firebase Core and Firebase Messaging for notifications
- Flutter Local Notifications for foreground notifications
- Google Maps and Geolocator for maps/location features
- Flutter Secure Storage for auth tokens
- Hive for local caching
- Khalti and eSewa integrations planned for payments

## Current Status

- Flutter project created as `vwa`.
- Android and iOS platforms are configured.
- Firebase apps are registered and configured for `com.kauwatech.vwa`.
- Provider foundation is in place.
- API client and secure token storage skeletons are available.
- Static design system, splash/onboarding, and auth screens are implemented.
- Auth screens are static/mock only: login, sign up, forgot password, verify email, verify OTP, reset password, and add vehicle number.
- Current pre-Phase-4 branch: `authentication-fixes`, covering splash timing, auth panel height consistency, multi-vehicle number entry, keyboard dismissal, 10-digit phone validation, and six-box OTP verification.
- Project plan is documented in `docs/PROJECT_PLAN.md`.

## Running Locally

List available devices:

```bash
flutter devices
```

Run on the connected Android phone:

```bash
flutter run -d OJUSLVIVT4BE75JZ
```

Do not run on Linux for this project.

## Verification

After feature integrations, use:

```bash
flutter analyze
flutter test
```

The assistant must not build APK/IPA files unless explicitly requested. The user explicitly allowed an Android runtime smoke check after Milestone 3.
