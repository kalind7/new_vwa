import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import '../../../shared/widgets/app_svg_icon.dart';

class StationProductMock {
  const StationProductMock({required this.id, required this.name, this.price});

  final int id;
  final String name;
  final String? price;
}

/// Presentation model for station cards/detail. When `USE_MOCK_DATA=false`, instances
/// are built only from [ServiceStation] API JSON via [ServiceStationMapper].
class WashStationMock {
  const WashStationMock({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.distance,
    required this.price,
    required this.slots,
    required this.slotsColor,
    required this.latitude,
    required this.longitude,
    this.reviewCount = 52,
    this.availableSlotsCount = 5,
    this.services = const [],
    this.products = const [],
    this.operatingHours = const [],
  });

  final String id;
  final String name;
  final String location;
  final String rating;
  final String distance;
  final String price;
  final String slots;
  final Color slotsColor;
  final double latitude;
  final double longitude;
  final int reviewCount;
  final int availableSlotsCount;
  final List<String> services;
  final List<StationProductMock> products;
  final List<String> operatingHours;

  List<String> get serviceNames {
    if (services.isNotEmpty) {
      return services;
    }
    return products.map((product) => product.name).toList();
  }

  WashStationMock copyWith({
    String? id,
    String? name,
    String? location,
    String? rating,
    String? distance,
    String? price,
    String? slots,
    Color? slotsColor,
    double? latitude,
    double? longitude,
    int? reviewCount,
    int? availableSlotsCount,
    List<String>? services,
    List<StationProductMock>? products,
    List<String>? operatingHours,
  }) {
    return WashStationMock(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      price: price ?? this.price,
      slots: slots ?? this.slots,
      slotsColor: slotsColor ?? this.slotsColor,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reviewCount: reviewCount ?? this.reviewCount,
      availableSlotsCount: availableSlotsCount ?? this.availableSlotsCount,
      services: services ?? this.services,
      products: products ?? this.products,
      operatingHours: operatingHours ?? this.operatingHours,
    );
  }
}

class WashBookingMock {
  const WashBookingMock({
    this.id,
    required this.station,
    required this.location,
    required this.status,
    required this.date,
    required this.time,
    required this.service,
    required this.vehicle,
    required this.price,
    required this.canCancel,
    this.stationId,
    this.vehicleId,
    this.paymentMethod,
  });

  final String? id;
  final String? stationId;
  final String? vehicleId;
  final String station;
  final String location;
  final String status;
  final String date;
  final String time;
  final String service;
  final String vehicle;
  final String price;
  final bool canCancel;
  final String? paymentMethod;
}

extension WashBookingMockProgress on WashBookingMock {
  /// Dev Handoff steps: 0 Booking, 1 Washing, 2 Finish (all done).
  int get washProgressStep {
    switch (status) {
      case 'Completed':
        return 2;
      case 'Washing':
        return 1;
      default:
        return 0;
    }
  }
}

class ProfileMenuSectionMock {
  const ProfileMenuSectionMock({required this.title, required this.items});

  final String title;
  final List<ProfileMenuItemMock> items;
}

class ProfileMenuItemMock {
  const ProfileMenuItemMock({
    required this.icon,
    required this.title,
    required this.route,
  });

  final AppSvgIconName icon;
  final String title;
  final String route;
}

const nearbyStations = [
  WashStationMock(
    id: '1',
    name: 'Clean Wave Station',
    location: 'Thamel, Kathmandu',
    rating: '4.5',
    distance: '0.8 km',
    price: 'Rs. 100',
    slots: '5 slots available',
    slotsColor: Color(0xFFFFF7ED),
    latitude: 27.7154,
    longitude: 85.3123,
    reviewCount: 52,
    availableSlotsCount: 5,
    services: ['Basic Wash', 'Premium Wash'],
    operatingHours: ['Sun–Sat: 7:00 AM – 8:00 PM'],
  ),
  WashStationMock(
    id: '2',
    name: 'Annapurna Daju Bhai Washing Station',
    location: 'Thamel, Kathmandu',
    rating: '4.2',
    distance: '1 miles away',
    price: 'Nrs 100',
    slots: '25 slots available',
    slotsColor: AppColors.success50,
    latitude: 27.7172,
    longitude: 85.3153,
    availableSlotsCount: 25,
    services: ['Express Wash', 'Detailing'],
    operatingHours: ['Mon–Sun: 6:00 AM – 9:00 PM'],
  ),
  WashStationMock(
    id: '3',
    name: 'Sparkle Bike Wash',
    location: 'Tudikhel, Kathmandu',
    rating: '4.5',
    distance: '2 miles away',
    price: 'Nrs 120',
    slots: '5 slots available',
    slotsColor: Color(0xFFFFF7ED),
    latitude: 27.7047,
    longitude: 85.3157,
    services: ['Standard Wash'],
    operatingHours: [
      'Mon–Fri: 8:00 AM – 7:00 PM',
      'Sat–Sun: 9:00 AM – 6:00 PM',
    ],
  ),
];

const washBookings = [
  WashBookingMock(
    id: '1',
    station: 'Sparkle Bike Wash',
    location: 'Jhamsikhel, Laltipur',
    status: 'Booked',
    date: 'Today',
    time: '10:00 AM',
    service: 'Exterior Wash',
    vehicle: 'Ba-pa 1097',
    price: 'Rs 250',
    canCancel: true,
  ),
  WashBookingMock(
    id: '2',
    station: 'Sparkle Bike Wash',
    location: 'Jhamsikhel, Laltipur',
    status: 'Completed',
    date: 'December 20',
    time: '10:00 AM',
    service: 'Full Bike Wash',
    vehicle: 'Ba-pa 1097',
    price: 'Rs 250',
    canCancel: false,
  ),
];

const stationServices = ['Exterior Wash', 'Interior Clean', 'Wax Polish'];

const profileMenuSections = [
  ProfileMenuSectionMock(
    title: 'Profile',
    items: [
      ProfileMenuItemMock(
        icon: AppSvgIconName.profile,
        title: 'Profile Setting',
        route: AppProfileRoutes.profileSetting,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.profile,
        title: 'Vehicle number',
        route: AppProfileRoutes.myVehicle,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.bookmark,
        title: 'Saved',
        route: AppProfileRoutes.saved,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.card,
        title: 'Payments History',
        route: AppProfileRoutes.paymentHistory,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.wash,
        title: 'Wash History',
        route: AppProfileRoutes.washHistoryTab,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.star,
        title: 'To review',
        route: AppProfileRoutes.reviews,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.profile,
        title: 'About Us',
        route: AppProfileRoutes.aboutUs,
      ),
    ],
  ),
  ProfileMenuSectionMock(
    title: 'Legal',
    items: [
      ProfileMenuItemMock(
        icon: AppSvgIconName.card,
        title: 'Terms and Conditions',
        route: AppProfileRoutes.terms,
      ),
      ProfileMenuItemMock(
        icon: AppSvgIconName.card,
        title: 'Privacy Policy',
        route: AppProfileRoutes.privacyPolicy,
      ),
    ],
  ),
];

class AppProfileRoutes {
  const AppProfileRoutes._();

  static const String profileSetting = '/profile-setting';
  static const String myVehicle = '/my-vehicle';
  static const String saved = '/saved';
  static const String paymentHistory = '/payment-history';
  static const String reviews = '/reviews';
  static const String aboutUs = '/about-us';
  static const String terms = '/terms';
  static const String privacyPolicy = '/privacy-policy';

  /// Switches main shell to My wash tab (not a named route).
  static const String washHistoryTab = '__wash_history_tab__';
}
