/// Route arguments for [AddVehicleScreen].
class AddVehicleRouteArgs {
  const AddVehicleRouteArgs({this.fromProfile = false});

  /// When true, hides onboarding profile-photo UI and returns to the previous screen.
  final bool fromProfile;
}
