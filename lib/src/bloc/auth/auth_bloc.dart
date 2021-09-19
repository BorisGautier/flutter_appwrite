import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository? authRepository;
  final SharedPreferencesHelper? sharedPreferencesHelper;

  AuthBloc({this.authRepository, this.sharedPreferencesHelper})
      : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStarted) {
      yield* _mapAuthStartedToState();
    } else if (event is AuthLoggedIn) {
      yield* _mapAuthLoggedInToState();
    } else if (event is AuthFirst) {
      yield* _mapAuthFirstOpenState();
    } else if (event is AuthLoggedOut) {
      yield* _mapAuthLoggedOutToState();
    } else if (event is AuthLogin) {
      yield* _mapAuthLoginToState();
    } else if (event is AuthRegister) {
      yield* _mapAuthRegisterToState();
    }
  }

//Initialisation du processus d'authentification
  Stream<AuthState> _mapAuthStartedToState() async* {
    final isSignedIn = await authRepository!.hasToken();
    final firstOpen = await sharedPreferencesHelper!.getIsFirstOpen();
    if (firstOpen == "oui") {
      yield AuthFirstOpen();
    } else {
      if (isSignedIn) {
        final userResult = await authRepository!.getuser();
        yield AuthSuccess(
            userResult.success!.name!, userResult.success!.email!);
      } else {
        yield AuthFailure();
      }
    }
  }

//Verifier si l'utilisateur est deja connecté
  Stream<AuthState> _mapAuthLoggedInToState() async* {
    final firstOpen = await sharedPreferencesHelper!.getIsFirstOpen();
    if (firstOpen == "oui") {
      yield AuthFirstOpen();
    } else {
      final userResult = await authRepository!.getuser();
      yield AuthSuccess(userResult.success!.name!, userResult.success!.email!);
    }
  }

// première connection de l'utilisateur
  Stream<AuthState> _mapAuthFirstOpenState() async* {
    await sharedPreferencesHelper!.setIsFirstOpen("non");
    yield AuthFailure();
  }

// Deconnexion de l'utilisateur
  Stream<AuthState> _mapAuthLoggedOutToState() async* {
    final token = await sharedPreferencesHelper!.getToken();
    authRepository!.logout(token);
    await sharedPreferencesHelper!.deleteToken();
    yield AuthFailure();
  }

// Redirection vers la LoginPage
  Stream<AuthState> _mapAuthLoginToState() async* {
    yield AuthLoginState(authRepository: authRepository);
  }

// Redirection vers la registerPage
  Stream<AuthState> _mapAuthRegisterToState() async* {
    yield AuthRegisterState(authRepository: authRepository);
  }
}
