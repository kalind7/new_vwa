import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

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
}

class WashBookingMock {
  const WashBookingMock({
    required this.station,
    required this.status,
    required this.date,
    required this.time,
    required this.service,
    required this.vehicle,
    required this.canCancel,
  });

  final String station;
  final String status;
  final String date;
  final String time;
  final String service;
  final String vehicle;
  final bool canCancel;
}

class ProfileMenuMock {
  const ProfileMenuMock({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const nearbyStations = [
  WashStationMock(
    name: 'Clean Wave Station',
    location: 'Thamel, Kathmandu',
    rating: '4.2/5',
    distance: '1 miles away',
    price: 'Nrs 100',
    slots: '5 slots available',
    slotsColor: Color(0xFFFFF7ED),
    latitude: 27.7154,
    longitude: 85.3123,
  ),
  WashStationMock(
    name: 'Annapurna Daju Bhai Washing Station',
    location: 'Thamel, Kathmandu',
    rating: '4.2/5',
    distance: '1 miles away',
    price: 'Nrs 100',
    slots: '25 slots available',
    slotsColor: AppColors.success50,
    latitude: 27.7172,
    longitude: 85.3153,
  ),
  WashStationMock(
    name: 'Sparkle Bike Wash',
    location: 'Tudikhel, Kathmandu',
    rating: '4.5/5',
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
    status: 'Booked',
    date: 'Dec 25, 2026',
    time: '11:00 AM',
    service: 'Exterior Wash',
    vehicle: 'BA-PA 1097',
    canCancel: true,
  ),
  WashBookingMock(
    station: 'Sparkle Bike Wash',
    status: 'Completed',
    date: 'Dec 12, 2026',
    time: '09:30 AM',
    service: 'Full Bike Wash',
    vehicle: 'BA-PA 1097',
    canCancel: false,
  ),
];

const profileMenus = [
  ProfileMenuMock(
    icon: Icons.person_outline_rounded,
    title: 'Profile Setting',
    subtitle: 'Manage your personal information',
  ),
  ProfileMenuMock(
    icon: Icons.credit_card_rounded,
    title: 'Payments History',
    subtitle: 'View completed wallet payments',
  ),
  ProfileMenuMock(
    icon: Icons.star_border_rounded,
    title: 'Reviews',
    subtitle: 'Ratings you gave to stations',
  ),
  ProfileMenuMock(
    icon: Icons.logout_rounded,
    title: 'Log out',
    subtitle: 'Return to the login screen',
  ),
];
