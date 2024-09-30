import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_app/routes/routes.dart';
import 'package:units_app/widgets/app_progress.dart';
import 'package:units_app/services/helper_user.dart';
import 'package:units_app/widgets/app_textfield.dart';
import 'package:units_app/services/user_management.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    // Initialize the TextEditingController for username and password fields
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose the TextEditingController objects to free up resources
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF9575CD), // Light Purple
                    Color(0xFF512DA8), // Dark Purple
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AppTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: usernameController,
                    labelText: 'Please enter email address',
                  ),
                  AppTextField(
                    hideText: true,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    labelText: 'Please enter your password',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the loginUserInUI function when the login button is pressed
                        loginUserInUI(context,
                            email: usernameController.text,
                            password: passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF512DA8), // Dark Purple
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Navigate to the registration page when the "Register a new User" button is pressed
                      Navigator.of(context)
                          .pushNamed(RouteManager.registerPage);
                    },
                    child: const Text('Register a new User'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // Call the resetPasswordInUI function when the "Reset Password" button is pressed
                      resetPasswordInUI(context,
                          email: usernameController.text);
                    },
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ),
          Selector<UserManagement, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.showUserProgress, value.userProgressText),
            builder: (context, value, child) {
              // Display the progress indicator if showUserProgress is true
              return value.item1
                  ? AppProgressIndicator(text: '${value.item2}')
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
