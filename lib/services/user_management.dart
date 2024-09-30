// ignore_for_file: avoid_print

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:units_app/models/unit_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManagement with ChangeNotifier {
  BackendlessUser? _currentUser; // Holds the currently logged-in user
  BackendlessUser? get currentUser =>
      _currentUser; // Getter for the currentUser object

  bool _userExists = false; // Flag to indicate if a user exists
  bool get userExists => _userExists; // Getter for the userExists flag

  bool _showUserProgress =
      false; // Flag to indicate if user-related progress is being shown
  bool get showUserProgress =>
      _showUserProgress; // Getter for the showUserProgress flag

  String _userProgressText =
      ''; // Holds the text to display during user-related progress
  String get userProgressText =>
      _userProgressText; // Getter for the userProgressText

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  void setCurrentUserNull() {
    _currentUser = null; // Set the currentUser object to null
  }

  Future<String> resetPassword(String username) async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Busy sending reset instructions ...please be patient';
    notifyListeners();

    // Send a password reset request using the Backendless userService
    await Backendless.userService
        .restorePassword(username)
        .onError((error, stackTrace) {
      result = getHumanReadableError(
          error.toString()); // Set the result to the error message
    });

    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> loginUser(String username, String password) async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Logging you in...please be patient';
    notifyListeners();

    // Log in the user using the Backendless userService
    BackendlessUser? user = await Backendless.userService
        .login(username, password, true)
        .onError((error, stackTrace) {
      result = getHumanReadableError(error.toString());
      return null; // Set the result to the error message
    });

    if (user != null) {
      _currentUser = user; // Set the currentUser object to the logged-in user
    }

    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> logoutUser() async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Busy signing you out...please be patient';
    notifyListeners();

    // Log out the user using the Backendless userService
    await Backendless.userService.logout().onError((error, stackTrace) {
      result = error.toString(); // Set the result to the error message
    });

    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> checkIfUserLoggedIn() async {
    String result = 'OK';

    // Check if the user is logged in using the Backendless userService
    bool? validLogin = await Backendless.userService
        .isValidLogin()
        .onError((error, stackTrace) {
      result = error.toString();
      return null; // Set the result to the error message
    });

    if (validLogin != null && validLogin) {
      String? currentUserObjectId = await Backendless.userService
          .loggedInUser()
          .onError((error, stackTrace) {
        result = error.toString();
        return null; // Set the result to the error message
      });

      if (currentUserObjectId != null) {
        // Retrieve the current user's data from the "Users" table using the Backendless data service
        Map<dynamic, dynamic>? mapOfCurrentUser = await Backendless.data
            .of("Users")
            .findById(currentUserObjectId)
            .onError((error, stackTrace) {
          result = error.toString();
          return null; // Set the result to the error message
        });

        if (mapOfCurrentUser != null) {
          _currentUser = BackendlessUser.fromJson(mapOfCurrentUser);
          notifyListeners();
        } else {
          result = 'NOT OK';
        }
      } else {
        result = 'NOT OK';
      }
    } else {
      result = 'NOT OK';
    }

    await Future.delayed(const Duration(seconds: 7));
    return result;
  }

  void checkIfUserExists(String username) async {
    // Create a query builder to find users with a matching email
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "email = '$username'";

    // Find users with the given email using the Backendless data service
    await Backendless.data
        .withClass<BackendlessUser>()
        .find(queryBuilder)
        .then((value) {
      if (value == null || value.isEmpty) {
        _userExists =
            false; // Set the userExists flag to false if no users are found
        notifyListeners();
      } else {
        _userExists =
            true; // Set the userExists flag to true if users are found
        notifyListeners();
      }
    }).onError((error, stackTrace) {
      print(error.toString()); // Print the error message if an error occurs
    });
  }

  Future<String> createUser(BackendlessUser user) async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Creating a new user...please be patient';
    notifyListeners();

    try {
      // Register a new user using the Backendless userService
      await Backendless.userService.register(user);

      // Fetch the default units data from the provided URL
      const defaultUnitsUrl =
          'https://dl.dropboxusercontent.com/s/q6chvs5eqktd1nb/unitReflections.json?dl=0';
      final defaultUnitsResponse = await http.get(Uri.parse(defaultUnitsUrl));

      if (defaultUnitsResponse.statusCode == 200) {
        final defaultUnitsJson = jsonDecode(defaultUnitsResponse.body);
        final defaultUnits = Map<String, dynamic>.from(defaultUnitsJson);

        // Update the units entry for the new user with the default units
        UnitEntry defaultEntry =
            UnitEntry(units: defaultUnits, username: user.email);
        await Backendless.data
            .of('UnitEntry')
            .save(defaultEntry.toJson())
            .onError((error, stackTrace) {
          result = error.toString();
          return null; // Set the result to the error message
        });
      } else {
        result = 'Failed to fetch default units data.';
      }
    } catch (e) {
      result = getHumanReadableError(
          e.toString()); // Set the result to the error message
    }

    _showUserProgress = false;
    notifyListeners();
    return result;
  }
}

String getHumanReadableError(String message) {
  // Convert Backendless error messages to more user-friendly messages
  if (message.contains('email address must be confirmed first')) {
    return 'Please check your inbox and confirm your email address and try to login again.';
  }
  if (message.contains('User already exists')) {
    return 'This username already exists in our database. Please create a new user.';
  }
  if (message.contains('Invalid login or password')) {
    return 'Please check your username or password. The combination provided does not match.';
  }
  if (message
      .contains('User account is locked out due to too many failed logins')) {
    return 'Your account is locked due to too many failed login attempts. Please wait 15 minutes and try again.';
  }
  if (message.contains('Unable to find a user with the specified identity')) {
    return 'Your email address does not exist in our database. Please check for spelling mistakes.';
  }
  if (message.contains(
      'Unable to resolve host "api.backendless.com": No address associated with hostname')) {
    return 'It seems as if you do not have an internet connection. Please connect to internet and try again.';
  }
  return message;
}
