import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository? authRepository;
  final SharedPreferencesHelper? sharedPreferencesHelper;

  AuthBloc({this.authRepository, this.sharedPreferencesHelper})
      : super(AuthInitial()) {
    on<AuthStarted>(_authStarted);
    on<AuthLoggedIn>(_authLoggedIn);
    on<AuthFirst>(_authFirstOpen);
    on<AuthLoggedOut>(_authLoggedOut);
    on<AuthLogin>(_authLogin);
    on<AuthRegister>(_authRegister);
  }

//Initialisation du processus d'authentification
  void _authStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final isSignedIn = await authRepository!.hasToken();
    final firstOpen = await sharedPreferencesHelper!.getIsFirstOpen();
    if (firstOpen == "oui") {
      return emit(AuthFirstOpen());
    } else {
      if (isSignedIn) {
        final userResult = await authRepository!.getuser();
        return emit(
            AuthSuccess(userResult.success!.name!, userResult.success!.email!));
      } else {
        return emit(AuthFailure());
      }
    }
  }

//Verifier si l'utilisateur est deja connecté
  void _authLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final firstOpen = await sharedPreferencesHelper!.getIsFirstOpen();
    if (firstOpen == "oui") {
      return emit(AuthFirstOpen());
    } else {
      final userResult = await authRepository!.getuser();
      return emit(
          AuthSuccess(userResult.success!.name!, userResult.success!.email!));
    }
  }

// première connection de l'utilisateur
  void _authFirstOpen(
    AuthFirst event,
    Emitter<AuthState> emit,
  ) async {
    await sharedPreferencesHelper!.setIsFirstOpen("non");
    return emit(AuthFailure());
  }

// Deconnexion de l'utilisateur
  void _authLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    final token = await sharedPreferencesHelper!.getToken();
    authRepository!.logout(token);
    await sharedPreferencesHelper!.deleteToken();
    return emit(AuthFailure());
  }

// Redirection vers la LoginPage
  void _authLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    return emit(AuthLoginState());
  }

// Redirection vers la registerPage
  void _authRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    return emit(AuthRegisterState());
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
