import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfileProvider(this._repository);

  final UserRepository _repository;

  UserProfile? _profile;
  bool _isLoading = false;
  Failure? _failure;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  Failure? get failure => _failure;

  String get displayName => _profile?.displayName ?? 'User';
  String? get avatarUrl => _profile?.avatarUrl;
  UserSavedLocation? get primaryLocation => _profile?.primaryLocation;

  Future<void> loadProfile() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _failure = null;
    notifyListeners();

    final result = await _repository.fetchProfile();
    result.fold(
      (failure) {
        _failure = failure;
      },
      (profile) {
        _profile = profile;
        _failure = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _profile = null;
    _failure = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<Either<Failure, UserProfile>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final result = await _repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );

    result.fold((failure) => _failure = failure, (profile) {
      _profile = profile;
      _failure = null;
    });
    notifyListeners();
    return result;
  }
}
