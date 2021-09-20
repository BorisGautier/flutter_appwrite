import 'package:flutter/material.dart';
import 'package:flutter_appwrite/src/utils/SizeConfig.dart';
import 'package:flutter_appwrite/src/utils/colors.dart';
import 'package:flutter_appwrite/src/utils/styles.dart';
import 'package:flutter_appwrite/src/widgets/extension.dart';
import 'package:flutter_theme_x/themes/app_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(FTxAppTheme.theme.primaryColor);
    MySize().init(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/computer.png',
                width: 200.0,
                fit: BoxFit.fitWidth,
              ),
              heightSpace,
              heightSpace,
              heightSpace,
              SpinKitPulse(
                color: darkPrimaryColor,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
