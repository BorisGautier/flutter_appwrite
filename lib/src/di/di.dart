import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite/sharedPreference.dart';
import 'package:flutter_appwrite/src/bloc/auth/auth_bloc.dart';
import 'package:flutter_appwrite/src/bloc/login/login_bloc.dart';
import 'package:flutter_appwrite/src/bloc/register/register_bloc.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepositoryImpl.dart';
import 'package:flutter_appwrite/src/utils/networkUtils.dart';
import 'package:flutter_appwrite/src/utils/strings.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Initialisation de l'injection de dependance dans l'application
Future<void> init() async {
  /** 
   * Déclaration et initialisation de appWrite
   */
  Client client = Client();
  client.setEndpoint(appWriteApiUrl).setProject(appwriteProjectId);

  getIt.registerLazySingleton<Account>(() => Account(client));

  //Injection des Utilitaires
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
  getIt.registerLazySingleton<SharedPreferencesHelper>(
      () => SharedPreferencesHelper());

  //Injection des Repository
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      account: getIt(),
      networkInfo: getIt(),
      sharedPreferencesHelper: getIt(),
    ),
  );

  //Injection des Blocs
  getIt.registerFactory<AuthBloc>(() =>
      AuthBloc(authRepository: getIt(), sharedPreferencesHelper: getIt()));

  getIt.registerFactory<LoginBloc>(() => LoginBloc(
        authRepository: getIt(),
        sharedPreferencesHelper: getIt(),
      ));
  getIt.registerFactory<RegisterBloc>(() => RegisterBloc(
        authRepository: getIt(),
        sharedPreferencesHelper: getIt(),
      ));
}
