// ignore_for_file: use_build_context_synchronously

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_app/routes/routes.dart';
import 'package:units_app/services/units_service.dart';
import 'package:units_app/services/user_management.dart';
import 'package:units_app/widgets/dialogs.dart';

// Creates a new user in the UI
void createNewUserInUI(
  BuildContext context, {
  required String email,
  required String password,
  required String name,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  // Check if any of the required fields are empty
  if (email.isEmpty || name.isEmpty || password.isEmpty) {
    showDialogBox(
      context,
      'Please enter all fields!',
    );
  } else {
    // Create a BackendlessUser object with the provided email, password, and name
    BackendlessUser user = BackendlessUser()
      ..email = email.trim()
      ..password = password.trim()
      ..putProperties({
        'name': name.trim(),
      });

    // Create the user using UserManagement service
    String result = await context.read<UserManagement>().createUser(user);

    // Check if the user creation was successful
    if (result != 'OK') {
      showSnackBar(context, result);
    } else {
      showToast('New user successfully created');
      Navigator.pop(context);
    }
  }
}

// Logs in a user in the UI
void loginUserInUI(BuildContext context,
    {required String email, required String password}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  // Check if the email or password fields are empty
  if (email.isEmpty || password.isEmpty) {
    showToast('Please fill in both fields !');
  } else {
    // Log in the user using UserManagement service
    String result = await context
        .read<UserManagement>()
        .loginUser(email.trim(), password.trim());

    // Check if the login was successful
    if (result != 'OK') {
      showDialogBox(context, result);
    } else {
      // Get units associated with the logged-in user and navigate to the units page
      context.read<UnitService>().getUnits(email);
      Navigator.of(context).popAndPushNamed(RouteManager.unitsReflection);
    }
  }
}

// Resets the password for a user in the UI
void resetPasswordInUI(BuildContext context, {required String email}) async {
  // Check if the email field is empty
  if (email.isEmpty) {
    showDialogBox(
        context, 'Please enter your email address then click Reset Password');
  } else {
    // Reset the password using UserManagement service
    String result =
        await context.read<UserManagement>().resetPassword(email.trim());

    // Check if the password reset was successful
    if (result == 'OK') {
      showToast('Successfully sent password reset. Please check your mail');
    } else {
      showDialogBox(context, result);
    }
  }
}

// Logs out a user in the UI
void logoutUserInUI(BuildContext context) async {
  // Log out the user using UserManagement service
  String result = await context.read<UserManagement>().logoutUser();

  // Check if the logout was successful
  if (result == 'OK') {
    context.read<UserManagement>().setCurrentUserNull();
    Navigator.popAndPushNamed(context, RouteManager.loginPage);
  } else {
    showSnackBar(context, result);
  }
}
