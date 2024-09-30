// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:units_app/routes/routes.dart';
import 'package:units_app/services/units_service.dart';
import 'package:units_app/services/user_management.dart';

class InitApp {
  static const String apiKeyAndroid = '3E517A31-EB1D-4CD3-8B4D-B919C7FC3544';
  static const String apiKeyiOS = '28EEFF99-206A-4842-AE10-73278DE741F1';
  static const String appID = '466EE93A-D324-4909-9555-4CC0BA6CEEC8';

  static Future<void> initializeApp(BuildContext context) async {
    await Backendless.initApp(
      applicationId: appID,
      iosApiKey: apiKeyiOS,
      androidApiKey: apiKeyAndroid,
    );

    String result = await context.read<UserManagement>().checkIfUserLoggedIn();
    if (result == 'OK') {
      context
          .read<UnitService>()
          .getUnits(context.read<UserManagement>().currentUser!.email);
      Navigator.popAndPushNamed(context, RouteManager.unitsReflection);
    } else {
      Navigator.popAndPushNamed(context, RouteManager.loginPage);
    }
  }
}
