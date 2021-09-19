import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/models/user.dart';
import 'package:flutter_appwrite/src/models/session.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/utils/networkUtils.dart';
import 'package:flutter_appwrite/src/utils/result.dart';
import 'package:flutter_appwrite/src/utils/strings.dart';

///Implémentation des methodes de l'authentification
class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo? networkInfo;
  final Account? account;
  final SharedPreferencesHelper? sharedPreferencesHelper;

  AuthRepositoryImpl(
      {this.networkInfo, this.account, this.sharedPreferencesHelper});

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
        final Future result = account!.get();

        result.then((response) {
          var model = User.fromJson(response.body);

          return Result(success: model);
        }).catchError((error) {
          print(error.response);
        });
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }

    throw UnimplementedError();
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
        final result = account!.createSession(email: email, password: password);

        result.then((response) {
          var model = Session.fromJson(response.data);

          return Result(success: model);
        }).catchError((error) {
          print(error.response);
        });
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> logout(String? sessionId) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final result = account!.deleteSession(sessionId: sessionId!);

        result.then((response) {
          return Result(success: true);
        }).catchError((error) {
          print(error.response);
        });
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> resgister(
      String email, String password, String name) async {
    bool isConnected = await networkInfo!.isConnected();
    if (isConnected) {
      try {
        final result =
            account!.create(email: email, password: password, name: name);

        result.then((response) {
          var model = User.fromJson(response.data);
          account!.createVerification(url: appWriteUrl);
          return Result(success: model);
        }).catchError((error) {
          print(error.response);
        });
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
    throw UnimplementedError();
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
        final result = account!.updateName(name: name);

        result.then((response) {
          var model = User.fromJson(response.data);

          return Result(success: model);
        }).catchError((error) {
          print(error.response);
        });
      } catch (e) {
        return Result(error: ServerError());
      }
    } else {
      return Result(error: NoInternetError());
    }
    throw UnimplementedError();
  }
}
