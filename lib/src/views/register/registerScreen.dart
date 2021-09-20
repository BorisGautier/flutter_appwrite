import 'package:flutter/material.dart';
import 'package:flutter_appwrite/src/bloc/register/register_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/views/register/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final AuthRepository? authRepository;

  RegisterScreen({this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterBloc>(
        create: (context) => getIt<RegisterBloc>(),
        child: RegisterPage(),
      ),
    );
  }
}
