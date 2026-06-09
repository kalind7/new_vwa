import 'package:flutter/foundation.dart';

import '../../../booking/domain/booking_flow_helpers.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';

class BookingFlowProvider extends ChangeNotifier {
  BookingFlowProvider({
    required WashStationMock station,
    VehicleMock? vehicle,
    WashServiceMock? initialService,
    WashSlotMock? initialSlot,
    PaymentMethodMock? initialPaymentMethod,
  }) : _station = station,
       _vehicle = vehicle ?? vehicles[2],
       _selectedService =
           initialService ?? servicesFromStation(station).firstOrNull ?? washServices.first,
       _selectedSlot =
           initialSlot ?? slotsFromStation(station).firstOrNull ?? washSlots.first,
       _selectedPaymentMethod = initialPaymentMethod ?? paymentMethods.first;

  final WashStationMock _station;
  final VehicleMock _vehicle;
  WashServiceMock _selectedService;
  WashSlotMock _selectedSlot;
  PaymentMethodMock _selectedPaymentMethod;

  WashStationMock get station => _station;
  VehicleMock get vehicle => _vehicle;
  WashServiceMock get selectedService => _selectedService;
  WashSlotMock get selectedSlot => _selectedSlot;
  PaymentMethodMock get selectedPaymentMethod => _selectedPaymentMethod;

  BookingDraft get draft {
    return BookingDraft(
      station: _station,
      service: _selectedService,
      slot: _selectedSlot,
      vehicle: _vehicle,
      paymentMethod: _selectedPaymentMethod,
    );
  }

  void selectService(WashServiceMock service) {
    if (_selectedService.id == service.id) {
      return;
    }

    _selectedService = service;
    notifyListeners();
  }

  void selectSlot(WashSlotMock slot) {
    if (_selectedSlot.id == slot.id) {
      return;
    }

    _selectedSlot = slot;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethodMock method) {
    if (_selectedPaymentMethod.id == method.id) {
      return;
    }

    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
