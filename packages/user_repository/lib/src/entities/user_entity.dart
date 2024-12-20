import 'package:user_repository/src/models/user_model.dart';

class UserEntity {
  String id;
  String email;

  UserEntity({
    required this.id,
    required this.email,
  });

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
    );
  }

  static UserEntity fromEntity(UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      email: userModel.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }

  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
    );
  }
}
