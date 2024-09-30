import 'package:flutter/material.dart';
import 'package:units_app/views/pages/loading.dart';
import 'package:units_app/views/pages/units_reflection.dart';
import '../views/pages/login.dart';
import '../views/pages/register.dart';

class RouteManager {
  // Define route names as constants
  static const String welcome = '/';
  static const String loginPage = 'loginPage';
  static const String registerPage = 'registerPage';
  static const String unitsReflection = 'unitsReflection';

  // Generate routes based on the provided settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        // Return a MaterialPageRoute for the welcome page
        return MaterialPageRoute(
          builder: (context) => const Welcome(),
        );

      case loginPage:
        // Return a MaterialPageRoute for the login page
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );

      case registerPage:
        // Return a MaterialPageRoute for the register page
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );

      case unitsReflection:
        // Return a MaterialPageRoute for the units reflection page
        return MaterialPageRoute(
          builder: (context) => const UnitsReflection(),
        );

      default:
        // Throw a FormatException when the route is not found
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
