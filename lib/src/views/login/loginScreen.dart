import 'package:flutter/material.dart';
import 'package:flutter_appwrite/src/bloc/login/login_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/views/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final AuthRepository? authRepository;

  LoginScreen({this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => getIt<LoginBloc>(),
        child: LoginPage(),
      ),
    );
  }
}
