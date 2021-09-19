import 'package:flutter/material.dart';
import 'package:flutter_appwrite/simpleBlocObserver.dart';
import 'package:flutter_appwrite/src/app.dart';
import 'package:flutter_appwrite/src/bloc/auth/auth_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

// Launch Flutter app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  Bloc.observer = SimpleBlocObserver();
  await di.init();
  runApp(BlocProvider(
      create: (_) => di.getIt<AuthBloc>()..add(AuthStarted()), child: MyApp()));
}
