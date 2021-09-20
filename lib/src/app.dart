import 'package:aesthetic_dialogs/aesthetic_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/src/bloc/auth/auth_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart';
import 'package:flutter_appwrite/src/splash.dart';
import 'package:flutter_appwrite/src/views/lading/lading.dart';
import 'package:flutter_appwrite/src/views/login/loginScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_theme_x/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter AppWrite",
      theme: FTxAppTheme.getThemeFromThemeMode(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return SplashScreen();
          }
          if (state is AuthFirstOpen) {
            return LadingPage();
          }
          if (state is AuthFailure) {
            return BlocProvider<AuthBloc>(
              create: (context) => getIt<AuthBloc>(),
              child: LoginScreen(),
            );

            // return AuthScreen();
          }
          if (state is AuthSuccess) {
            /* return BlocProvider(
              create: (context) => getIt<TabBloc>(),
              child: HomePage(),
            );*/
            return MyHomePage(title: "Auth Success");
          }

          return SplashScreen();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                onPressed: buildDialog,
                child: Text("Open Dialog"),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }

  Future<void> buildDialog() async {
    AestheticDialogs.showDialog(
        title: "My Dialog",
        message: "Hello!!!",
        cancelable: true,
        darkMode: false,
        dialogAnimation: DialogAnimation.IN_OUT,
        dialogGravity: DialogGravity.CENTER,
        dialogStyle: DialogStyle.FLASH,
        dialogType: DialogType.SUCCESS,
        duration: 3000);
  }
}
