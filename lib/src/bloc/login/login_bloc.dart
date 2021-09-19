import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/models/session.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/utils/result.dart';
import 'package:flutter_appwrite/src/utils/validator.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepository;
  final SharedPreferencesHelper? sharedPreferencesHelper;

  LoginBloc({
    this.authRepository,
    this.sharedPreferencesHelper,
  }) : super(LoginState.initial());

// RxDart pour gerer les evenements de facon asynchrone
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailChanged) {
      yield* _mapLoginEmailChangedToState(event.email!);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangedToState(event.password!);
    } else if (event is PasswordReset) {
      yield* _mapPasswordResetPressedToState(email: event.email!);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email!,
        password: event.password!,
      );
    }
  }

// Action de validation d'email qui s'effectue a chaque saisie de l'utilisateur
  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

// Action de validation de mot de passe qui s'effectue a chaque saisie de l'utilisateur
  Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

// Methode qui s'execute lors du clic sur le boutton connexion
  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String? email,
    String? password,
  }) async* {
    yield LoginState.loading();
    try {
      Result<Session> user = await authRepository!.login(email!, password!);
      if (user.success!.current!) {
        await sharedPreferencesHelper!.setToken(user.success!.id!);
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }

//Reinitialisation du mot de passe
  Stream<LoginState> _mapPasswordResetPressedToState({
    String? email,
  }) async* {
    /*  try {
      await authRepository!.forgotpassword(email);
      yield LoginState.send();
    } catch (_) {
      yield LoginState.failSend();
    }*/
  }
}
