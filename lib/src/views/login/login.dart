import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_appwrite/src/bloc/auth/auth_bloc.dart';
import 'package:flutter_appwrite/src/bloc/login/login_bloc.dart';
import 'package:flutter_appwrite/src/bloc/register/register_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart';
import 'package:flutter_appwrite/src/utils/SizeConfig.dart';
import 'package:flutter_appwrite/src/utils/colors.dart';
import 'package:flutter_appwrite/src/utils/themes/AppTheme.dart';
import 'package:flutter_appwrite/src/utils/themes/AppThemeNotifier.dart';
import 'package:flutter_appwrite/src/views/register/registerScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_theme_x/icons/two_tone/two_tone_icon.dart';
import 'package:flutter_theme_x/icons/two_tone/two_tone_mdi_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc? _loginBloc;

  bool obscureText = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting!;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginEmailChanged() {
    _loginBloc!.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc!.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  _onFormSubmitted() {
    _loginBloc!.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  /* void _reset(String mail) {
    _loginBloc!.add(
      PasswordReset(email: mail),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.loginFailed),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: red,
                duration: Duration(seconds: 7),
              ),
            );
        }
        if (state.isSubmitting!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.loggin),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        /* if (state.isSend!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.emailSend),
                    Icon(Icons.check_circle)
                  ],
                ),
                backgroundColor: green,
                duration: Duration(seconds: 7),
              ),
            );
        }
        if (state.isFailSend!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.emailNoSend),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: red,
              ),
            );
        }*/
        if (state.isSuccess!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.loginSuccess),
                    Icon(Icons.check_circle)
                  ],
                ),
                backgroundColor: green,
                duration: Duration(seconds: 7),
              ),
            );
          context.read<AuthBloc>().add(AuthLoggedIn());
          //  BlocProvider.of<AuthBloc>(context).add(AuthLoggedIn());
          //  Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Consumer<AppThemeNotifier>(
            builder:
                (BuildContext context, AppThemeNotifier value, Widget? child) {
              int themeType = value.themeMode();
              themeData = AppTheme.getThemeFromThemeMode(themeType);
              customAppTheme = AppTheme.getCustomAppTheme(themeType);
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.getThemeFromThemeMode(themeType),
                  home: Scaffold(
                      body: Container(
                          color: customAppTheme.bgLayer1,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: MySize.size24!),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .welcome
                                        .toUpperCase(),
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.headline6,
                                        color:
                                            themeData.colorScheme.onBackground,
                                        fontWeight: 700,
                                        letterSpacing: 0.5),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: MySize.size24!,
                                      right: MySize.size24!,
                                      top: MySize.size24!),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: themeData
                                                .colorScheme.background,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MySize.size16!))),
                                        padding: EdgeInsets.all(MySize.size12!),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  EdgeInsets.all(MySize.size6!),
                                              decoration: BoxDecoration(
                                                  color: themeData
                                                      .colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              MySize.size8!))),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MySize.size8!),
                                                child: FTxTwoToneIcon(
                                                  FTxTwoToneMdiIcons.email,
                                                  color: themeData
                                                      .colorScheme.onPrimary,
                                                  size: MySize.size20,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: MySize.size16!),
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  autocorrect: false,
                                                  validator: (_) {
                                                    return !state.isEmailValid!
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .invalidMail
                                                        : null;
                                                  },
                                                  cursorColor: primaryColor,
                                                  style: AppTheme.getTextStyle(
                                                      themeData
                                                          .textTheme.bodyText1,
                                                      letterSpacing: 0.1,
                                                      color: themeData
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight: 500),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .hintEmail,
                                                    hintStyle:
                                                        AppTheme.getTextStyle(
                                                            themeData.textTheme
                                                                .subtitle2,
                                                            letterSpacing: 0.1,
                                                            color: themeData
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight: 500),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(
                                                              MySize.size8!),
                                                        ),
                                                        borderSide:
                                                            BorderSide.none),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  MySize
                                                                      .size8!),
                                                            ),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  MySize
                                                                      .size8!),
                                                            ),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                  ),
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: MySize.size16!),
                                        decoration: BoxDecoration(
                                            color: themeData
                                                .colorScheme.background,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MySize.size16!))),
                                        padding: EdgeInsets.all(MySize.size12!),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  EdgeInsets.all(MySize.size6!),
                                              decoration: BoxDecoration(
                                                  color: themeData
                                                      .colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              MySize.size8!))),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MySize.size8!),
                                                child: FTxTwoToneIcon(
                                                  FTxTwoToneMdiIcons
                                                      .lock_outline,
                                                  color: themeData
                                                      .colorScheme.onPrimary,
                                                  size: MySize.size20,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: MySize.size16!),
                                                child: TextFormField(
                                                  controller:
                                                      _passwordController,
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  autocorrect: false,
                                                  validator: (_) {
                                                    return !state
                                                            .isPasswordValid!
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .invalidPass
                                                        : null;
                                                  },
                                                  obscureText: obscureText,
                                                  cursorColor: primaryColor,
                                                  style: AppTheme.getTextStyle(
                                                      themeData
                                                          .textTheme.bodyText1,
                                                      letterSpacing: 0.1,
                                                      color: themeData
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight: 500),
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon: obscureText
                                                          ? Icon(
                                                              Icons.visibility)
                                                          : Icon(Icons
                                                              .visibility_off),
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureText =
                                                              !obscureText;
                                                        });
                                                      },
                                                      color: primaryColor,
                                                    ),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .password,
                                                    hintStyle:
                                                        AppTheme.getTextStyle(
                                                            themeData.textTheme
                                                                .subtitle2,
                                                            letterSpacing: 0.1,
                                                            color: themeData
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight: 500),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8.0),
                                                        ),
                                                        borderSide:
                                                            BorderSide.none),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8.0),
                                                            ),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8.0),
                                                            ),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: MySize.size8!),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              /*  Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FoodPasswordScreen()));*/
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .forgotPass,
                                              style: AppTheme.getTextStyle(
                                                  themeData.textTheme.bodyText2,
                                                  color: themeData
                                                      .colorScheme.onBackground,
                                                  letterSpacing: 0,
                                                  fontWeight: 500),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(MySize.size12!)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeData.primaryColor
                                            .withAlpha(24),
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(
                                      left: MySize.size24!,
                                      right: MySize.size24!,
                                      top: MySize.size16!),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (isLoginButtonEnabled(state)) {
                                        return _onFormSubmitted();
                                      } else {
                                        return null;
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .connexion
                                          .toUpperCase(),
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          fontWeight: 600,
                                          color:
                                              themeData.colorScheme.onPrimary,
                                          letterSpacing: 0.5),
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            Spacing.xy(16, 0))),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: MySize.size16!),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) =>
                                                  getIt<RegisterBloc>(),
                                              child: RegisterScreen(),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.noAccount,
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          color: themeData
                                              .colorScheme.onBackground,
                                          fontWeight: 500,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))));
            },
          );
        },
      ),
    );
  }
}
