import 'package:user_repository/src/entities/entities.dart';

abstract class UserRepo {
  Future<void> signUp(UserEntity userEntity);
}
