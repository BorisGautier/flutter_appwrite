import 'package:flutter/material.dart';
import 'package:flutter_appwrite/src/bloc/register/register_bloc.dart';
import 'package:flutter_appwrite/src/di/di.dart';
import 'package:flutter_appwrite/src/repositories/auth/authRepository.dart';
import 'package:flutter_appwrite/src/utils/SizeConfig.dart';
import 'package:flutter_appwrite/src/utils/colors.dart';
import 'package:flutter_appwrite/src/utils/themes/AppTheme.dart';
import 'package:flutter_appwrite/src/utils/themes/AppThemeNotifier.dart';
import 'package:flutter_appwrite/src/views/login/loginScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_theme_x/icons/two_tone/two_tone_icon.dart';
import 'package:flutter_theme_x/icons/two_tone/two_tone_mdi_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  RegisterBloc? _registerBloc;

  bool obscureText = true;
  bool obscureTextConfirm = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _nameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting!;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _cpasswordController.addListener(_onCPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc!.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc!.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onCPasswordChanged() {
    _registerBloc!.add(
      RegisterCPasswordChanged(
          password: _passwordController.text,
          cpassword: _cpasswordController.text),
    );
  }

  _onFormSubmitted() {
    _registerBloc!.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.registering),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess!) {
          //  BlocProvider.of<AuthBloc>(context).add(AuthLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure!) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.registerFailed),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: red,
                duration: Duration(seconds: 7),
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                                        .createAccount
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
                                                  FTxTwoToneMdiIcons
                                                      .account_box,
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
                                                  controller: _nameController,
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  autocorrect: false,
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
                                                            .username,
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
                                                      _cpasswordController,
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  autocorrect: false,
                                                  validator: (_) {
                                                    return !state
                                                            .isCPasswordValid!
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .passError
                                                        : null;
                                                  },
                                                  obscureText:
                                                      obscureTextConfirm,
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
                                                      icon: obscureTextConfirm
                                                          ? Icon(
                                                              Icons.visibility)
                                                          : Icon(Icons
                                                              .visibility_off),
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureTextConfirm =
                                                              !obscureTextConfirm;
                                                        });
                                                      },
                                                      color: primaryColor,
                                                    ),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .cpassword,
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
                                      top: MySize.size24!),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            Spacing.xy(16, 0))),
                                    onPressed: () {
                                      if (isRegisterButtonEnabled(state)) {
                                        return _onFormSubmitted();
                                      } else {
                                        return null;
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .createAccount
                                          .toUpperCase(),
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          fontWeight: 600,
                                          color:
                                              themeData.colorScheme.onPrimary,
                                          letterSpacing: 0.5),
                                    ),
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
                                              child: LoginScreen(
                                                authRepository:
                                                    getIt<AuthRepository>(),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .alreadyAccount,
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
