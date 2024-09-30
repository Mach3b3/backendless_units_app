import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_app/services/helper_user.dart';
import 'package:units_app/services/user_management.dart';
import 'package:units_app/widgets/app_progress.dart';
import 'package:units_app/widgets/app_textfield.dart';
import 'package:tuple/tuple.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    // Initialize the TextEditingController objects for username, name, and password fields
    usernameController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose the TextEditingController objects to free up resources
    usernameController.dispose();
    nameController.dispose();
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
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Register User',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Focus(
                    onFocusChange: (value) async {
                      // Check if the entered username already exists when the field loses focus
                      if (!value) {
                        context
                            .read<UserManagement>()
                            .checkIfUserExists(usernameController.text.trim());
                      }
                    },
                    child: AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController,
                      labelText: 'Please enter your email address',
                    ),
                  ),
                  Selector<UserManagement, bool>(
                    selector: (context, value) => value.userExists,
                    builder: (context, value, child) {
                      // Show a message if the entered username already exists
                      return value
                          ? const Text(
                              'username exists, please choose another',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container();
                    },
                  ),
                  AppTextField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    labelText: 'Please enter your name',
                  ),
                  AppTextField(
                    hideText: true,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    labelText: 'Please enter your password',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF512DA8), // Dark Purple
                      ),
                      onPressed: () {
                        // Call the createNewUserInUI function when the register button is pressed
                        createNewUserInUI(
                          context,
                          email: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          name: nameController.text.trim(),
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 35,
            child: IconButton(
              onPressed: () {
                // Navigate back to the previous screen when the back button is pressed
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
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
