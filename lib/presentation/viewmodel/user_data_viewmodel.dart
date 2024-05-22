import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/domain/usecase/user_data_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class UserDataViewmodel {
  final _usecase = locator<UserDataUsecase>();

  UserDataModel? userData;

  Future<UserDataModel?> getUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      return await _usecase.getUserData(userId);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserData(UserDataModel userData) async {
    final res = await _usecase.save(userData);
    if (res == null) {
      onSuccess?.call();
    } else {
      onError?.call(res);
    }
  }

  Future<void> createUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userData = UserDataModel(
      userId: userId,
      level: 1,
      points: 0,
    );

    final res = await _usecase.save(userData);
    if (res == null) {
      onSuccess?.call();
    } else {
      onError?.call(res);
    }
  }

  Future<void> addPoints(int points) async {
    final userData = await getUserData();
    if (userData != null) {
      await saveUserData(userData.copyWith(points: userData.points + points));
    }
  }

  Future<void> levelUp(int level) async {
    final userData = await getUserData();
    if (userData != null && userData.level < level) {
      await saveUserData(userData.copyWith(level: level));
    }
  }

  Function()? onSuccess;
  Function(String message)? onError;
}