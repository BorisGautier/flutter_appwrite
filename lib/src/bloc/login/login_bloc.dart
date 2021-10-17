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
  }) : super(LoginState.initial()) {
    on<LoginEmailChanged>(_loginEmailChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<LoginPasswordChanged>(_loginPasswordChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<LoginWithCredentialsPressed>(_loginButtonPressed);
  }

// RxDart pour gerer les evenements de facon asynchrone
  EventTransformer<LoginEvent> debounce<LoginEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

// Action de validation d'email qui s'effectue a chaque saisie de l'utilisateur
  void _loginEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    return emit(state.update(
      isEmailValid: Validators.isValidEmail(event.email!),
    ));
  }

// Action de validation de mot de passe qui s'effectue a chaque saisie de l'utilisateur
  void _loginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    return emit(state.update(
      isPasswordValid: Validators.isValidPassword(event.password!),
    ));
  }

// Methode qui s'execute lors du clic sur le boutton connexion
  void _loginButtonPressed(
    LoginWithCredentialsPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState.loading());
    try {
      Result<Session> user =
          await authRepository!.login(event.email!, event.password!);
      if (user.success!.current!) {
        await sharedPreferencesHelper!.setToken(user.success!.id!);
        return emit(LoginState.success());
      } else {
        return emit(LoginState.failSend());
      }
    } catch (_) {
      return emit(LoginState.failSend());
    }
  }
}
