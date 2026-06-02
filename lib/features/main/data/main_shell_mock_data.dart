import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import '../../../shared/widgets/app_svg_icon.dart';

class WashStationMock {
  const WashStationMock({
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
  });

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
}

class WashBookingMock {
  const WashBookingMock({
    required this.station,
    required this.location,
    required this.status,
    required this.date,
    required this.time,
    required this.service,
    required this.vehicle,
    required this.price,
    required this.canCancel,
  });

  final String station;
  final String location;
  final String status;
  final String date;
  final String time;
  final String service;
  final String vehicle;
  final String price;
  final bool canCancel;
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
  ),
  WashStationMock(
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
  ),
  WashStationMock(
    name: 'Sparkle Bike Wash',
    location: 'Tudikhel, Kathmandu',
    rating: '4.5',
    distance: '2 miles away',
    price: 'Nrs 120',
    slots: '5 slots available',
    slotsColor: Color(0xFFFFF7ED),
    latitude: 27.7047,
    longitude: 85.3157,
  ),
];

const washBookings = [
  WashBookingMock(
    station: 'Sparkle Bike Wash',
    location: 'Jhamsikhel, Laltipur',
    status: 'Pending',
    date: 'Today',
    time: '10:00 AM',
    service: 'Exterior Wash',
    vehicle: 'Ba-pa 1097',
    price: 'Rs 250',
    canCancel: true,
  ),
  WashBookingMock(
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

const stationServices = [
  'Exterior Wash',
  'Interior Clean',
  'Wax Polish',
];

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
        title: 'My vehicle number',
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
}
