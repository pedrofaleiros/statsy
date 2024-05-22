import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/domain/repository/user_data_repository.dart';

class UserDataUsecase {
  final UserDataRepository _repository;

  UserDataUsecase(this._repository);

  Future<UserDataModel?> getUserData(String id) async {
    final data = await _repository.getUserData(id);

    if (data.data() != null) {
      return UserDataModel.fromMap(data.data()!, data.id);
    }
    return null;
  }

  Future<String?> save(UserDataModel userData) async {
    await _repository.save(userData);
    return null;
  }
}
