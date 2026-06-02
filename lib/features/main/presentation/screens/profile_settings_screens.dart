import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../../shared/widgets/shimmers/app_shimmer.dart';
import '../../../../shared/widgets/shimmers/station_card_shimmer.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/booking_flow_mock_data.dart';
import '../providers/saved_stations_provider.dart';
import '../widgets/edit_vehicle_bottom_sheet.dart';
import '../widgets/station_card.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  var _isSaving = false;
  var _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _bindProfile(UserProfileProvider provider) {
    if (_initialized || provider.profile == null) {
      return;
    }

    final profile = provider.profile!;
    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      AppToast.showError(context, 'Name and email are required.');
      return;
    }

    setState(() => _isSaving = true);
    final result = await context.read<UserProfileProvider>().updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      AppToast.showSuccess(context, 'Profile updated.');
      Navigator.of(context).maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    _bindProfile(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Edit Profile'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gray25, width: 2),
                          color: AppColors.gray100,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D101828),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            'Add',
                            style: AppTextStyles.textXsMedium.copyWith(
                              color: AppColors.gray700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'Your Profile',
                  style: AppTextStyles.textXlSemiBold.copyWith(
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppTextField(
                  label: 'Name',
                  hintText: 'Your name',
                  controller: _nameController,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email',
                  hintText: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Phone',
                  hintText: '98XXXXXXXX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                AppButton(label: 'Save changes', onPressed: _save),
              ],
            ),
          ),
          if (_isSaving || profileProvider.isLoading) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  List<VehicleMock> _vehicles = const [];
  var _isLoading = true;
  var _isMutating = false;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);

    final result = await context.read<UserRepository>().fetchVehicles();
    if (!mounted) {
      return;
    }

    result.fold((failure) {
      AppToast.showError(context, failure.message);
      final profileVehicles =
          context.read<UserProfileProvider>().profile?.vehicles ?? const [];
      _vehicles = profileVehicles
          .map(
            (vehicle) => VehicleMock(
              id: '${vehicle.id}',
              plate: vehicle.vehicleNumber,
              isDefault: vehicle.isDefault,
            ),
          )
          .toList();
    }, (loaded) => _vehicles = loaded);

    setState(() => _isLoading = false);
  }

  Future<void> _editVehicle(VehicleMock vehicle) async {
    final updatedPlate = await showEditVehicleBottomSheet(
      context: context,
      vehicle: vehicle,
    );
    if (updatedPlate == null || updatedPlate == vehicle.plate || !mounted) {
      return;
    }

    setState(() => _isMutating = true);
    final result = await context.read<UserRepository>().updateVehicle(
      vehicleId: vehicle.id,
      vehicleNumber: updatedPlate,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isMutating = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      AppToast.showSuccess(context, 'Vehicle updated.');
      _loadVehicles();
      context.read<UserProfileProvider>().loadProfile();
    });
  }

  Future<void> _deleteVehicle(VehicleMock vehicle) async {
    final shouldDelete = await showAppFlowModal(
      context: context,
      message: 'Remove ${vehicle.plate} from your vehicles?',
    );
    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() => _isMutating = true);
    final result = await context.read<UserRepository>().deleteVehicle(
      vehicle.id,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isMutating = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      AppToast.showSuccess(context, 'Vehicle removed.');
      _loadVehicles();
      context.read<UserProfileProvider>().loadProfile();
    });
  }

  Future<void> _setDefault(VehicleMock vehicle) async {
    if (vehicle.isDefault) {
      return;
    }

    setState(() => _isMutating = true);
    final result = await context.read<UserRepository>().setDefaultVehicle(
      vehicle.id,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isMutating = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      AppToast.showSuccess(context, 'Default vehicle updated.');
      _loadVehicles();
    });
  }

  void _addVehicle() {
    Navigator.of(context).pushNamed(AppRoutes.addVehicle).then((_) {
      if (mounted) {
        _loadVehicles();
        context.read<UserProfileProvider>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'My vehicle number'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVehicle,
        backgroundColor: AppColors.brand500,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add vehicle'),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: List.generate(
                3,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppShimmerBox(
                    width: double.infinity,
                    height: 88,
                    borderRadius: AppRadius.md,
                  ),
                ),
              ),
            )
          else if (_vehicles.isEmpty)
            EmptyStateView(
              title: 'No vehicles yet',
              message:
                  'Add your bike plate number to book washes faster at any station.',
              icon: Icons.two_wheeler_outlined,
              actionLabel: 'Add vehicle',
              onAction: _addVehicle,
            )
          else
            RefreshIndicator(
              onRefresh: _loadVehicles,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxxl * 3,
                ),
                itemCount: _vehicles.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  return _VehicleCard(
                    vehicle: vehicle,
                    onEdit: () => _editVehicle(vehicle),
                    onDelete: () => _deleteVehicle(vehicle),
                    onSetDefault: () => _setDefault(vehicle),
                  );
                },
              ),
            ),
          if (_isMutating) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final VehicleMock vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: vehicle.isDefault ? AppColors.brand25 : AppColors.gray25,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: vehicle.isDefault ? AppColors.brand500 : AppColors.gray200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: AppSvgIcon(
                      AppSvgIconName.bike,
                      color: AppColors.gray700,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.plate,
                        style: AppTextStyles.textMdSemiBold.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        vehicle.vehicleType.toUpperCase(),
                        style: AppTextStyles.textXsMedium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (vehicle.isDefault)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.brand500,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      child: Text(
                        'Default',
                        style: AppTextStyles.textXsMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                if (!vehicle.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('Set as default'),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: AppColors.gray600,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SavedStationsScreen extends StatelessWidget {
  const SavedStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Saved'),
      body: Consumer<SavedStationsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: StationListShimmer(itemCount: 3),
            );
          }

          if (provider.stations.isEmpty) {
            return const EmptyStateView(
              title: 'No saved stations',
              message:
                  'Tap the bookmark icon on a station detail page to save it here for quick access.',
              icon: Icons.bookmark_border,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadSavedStations,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              itemCount: provider.stations.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final station = provider.stations[index];
                return StationCard(
                  station: station,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.stationDetail, arguments: station),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'About Us',
      body:
          'Bike wash helps riders discover nearby washing stations, book slots, '
          'and track completed washes.',
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'Terms and Conditions',
      body:
          'These terms govern your use of the Bike wash application. '
          'By continuing to use the app, you agree to the published terms.',
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'Privacy Policy',
      body:
          'We collect only the information needed to provide booking and account '
          'services. Contact support for data requests.',
    );
  }
}

class _StaticProfileContentScreen extends StatelessWidget {
  const _StaticProfileContentScreen({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: title),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Text(
          body,
          style: AppTextStyles.textMdRegular.copyWith(color: AppColors.gray600),
        ),
      ),
    );
  }
}
