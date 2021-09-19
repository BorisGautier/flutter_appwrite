part of 'auth_bloc.dart';

///Declaration de tous les etats d'authentification avec leurs parametres
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Etat initial de l'authentification
class AuthInitial extends AuthState {}

//authentification reussie
class AuthSuccess extends AuthState {
  final String name;
  final String email;

  const AuthSuccess(this.name, this.email);

  @override
  List<Object> get props => [name, email];

  @override
  String toString() => 'AuthSuccess { Name: $name , email: $email }';
}

//Etat qui gère la premiere ouverture de l'application
class AuthFirstOpen extends AuthState {}

//Echec d'authentification
class AuthFailure extends AuthState {}

//Authetification Login
class AuthLoginState extends AuthState {
  final AuthRepository? authRepository;

  const AuthLoginState({
    @required this.authRepository,
  });

  @override
  List<Object> get props => [authRepository!];

  @override
  String toString() {
    return 'AuthLoginState { userRepository: $authRepository }';
  }
}

//Authentification Register
class AuthRegisterState extends AuthState {
  final AuthRepository? authRepository;

  const AuthRegisterState({
    @required this.authRepository,
  });

  @override
  List<Object> get props => [authRepository!];

  @override
  String toString() {
    return 'AuthRegister { userRepository: $authRepository }';
  }
}
