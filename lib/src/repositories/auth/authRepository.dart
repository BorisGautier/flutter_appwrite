import 'package:flutter_appwrite/src/models/session.dart';
import 'package:flutter_appwrite/src/models/user.dart';
import 'package:flutter_appwrite/src/utils/result.dart';

/// Declaration des methodes utiles pour l'authentification
abstract class AuthRepository {
  Future<Result<Session>> login(String email, String password);

  Future<Result<User>> resgister(String email, String password, String name);

  Future<Result<User>> updateusername(
    String name,
  );

  Future<Result<User>> getuser();

  Future<bool> deleteToken();

  Future<bool> saveToken(String token);

  Future<bool> hasToken();

  Future<Result<bool>> logout(String? sessionId);
}
