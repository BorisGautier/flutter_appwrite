import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/api/appwrite.dart';
import 'package:flutter_appwrite/src/models/user.dart';
import 'package:flutter_appwrite/src/models/session.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/utils/networkUtils.dart';
import 'package:flutter_appwrite/src/utils/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo? networkInfo;
  final SharedPreferencesHelper? sharedPreferencesHelper;
  var model;

  AuthRepositoryImpl({this.networkInfo, this.sharedPreferencesHelper});

  @override
  Future<bool> deleteToken() async {
    bool delete = await sharedPreferencesHelper!.deleteToken();
    return delete;
  }

  @override
  Future<Result<User>> getuser() async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final response = await initAppWrite().get();

        var model = User.fromJson(response.data);

        return Result(success: model);
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
  }

  @override
  Future<bool> hasToken() async {
    bool hasToken;
    String? token = await sharedPreferencesHelper!.getToken();
    // ignore: unnecessary_null_comparison
    if (token != null) {
      hasToken = true;
    } else {
      hasToken = false;
    }

    return hasToken;
  }

  @override
  Future<Result<Session>> login(String email, String password) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final response = await initAppWrite()
            .createSession(email: email, password: password);

        var model = Session.fromJson(response.data);

        return Result(success: model);
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
  }

  @override
  Future<Result<bool>> logout(String? sessionId) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        await initAppWrite().deleteSession(sessionId: sessionId!);

        //  var model = Session.fromJson(response.data);

        return Result(success: true);
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
  }

  @override
  Future<Result<User>> resgister(
      String email, String password, String name) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final response = await initAppWrite()
            .create(email: email, password: password, name: name);

        var model = User.fromJson(response.data);

        return Result(success: model);
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
  }

  @override
  Future<bool> saveToken(String token) async {
    bool saveT = await sharedPreferencesHelper!.setToken(token);
    return saveT;
  }

  @override
  Future<Result<User>> updateusername(String name) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final response = await initAppWrite().updateName(name: name);

        var model = User.fromJson(response.data);

        return Result(success: model);
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
  }
}
