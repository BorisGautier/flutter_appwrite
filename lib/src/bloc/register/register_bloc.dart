import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/models/user.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/utils/result.dart';
import 'package:flutter_appwrite/src/utils/validator.dart';
import 'package:rxdart/rxdart.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository? authRepository;
  final SharedPreferencesHelper? sharedPreferencesHelper;

  RegisterBloc({
    this.authRepository,
    this.sharedPreferencesHelper,
  }) : super(RegisterState.initial()) {
    on<RegisterEmailChanged>(_registerEmailChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<RegisterPasswordChanged>(_registerPasswordChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<RegisterCPasswordChanged>(_registerConfirmPasswordChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<RegisterSubmitted>(_registerButtonPressed);
  }

// RxDart pour gerer les evenements de facon asynchrone
  EventTransformer<RegisterEvent> debounce<RegisterEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

// Action de validation d'email qui s'effectue a chaque saisie de l'utilisateur
  void _registerEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) async {
    return emit(state.update(
      isEmailValid: Validators.isValidEmail(event.email!),
    ));
  }

// Action de validation de mot de passe qui s'effectue a chaque saisie de l'utilisateur
  void _registerPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    return emit(state.update(
      isPasswordValid: Validators.isValidPassword(event.password!),
    ));
  }

// Action de confirmation de mot de passe qui s'effectue a chaque saisie de l'utilisateur
  void _registerConfirmPasswordChanged(
    RegisterCPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    return emit(state.update(
      isPasswordValid:
          Validators.isValidCPassword(event.password!, event.cpassword!),
    ));
  }

  // Methode qui s'execute lors du clic sur le boutton connexion
  void _registerButtonPressed(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterState.loading());
    try {
      Result<User> user = await authRepository!
          .resgister(event.email!, event.password!, event.name!);
      print(user.success);
      if (user.success != null) {
        return emit(RegisterState.success());
      } else {
        return emit(RegisterState.failure());
      }
    } catch (error) {
      print(error);
      return emit(RegisterState.failure());
    }
  }
}
