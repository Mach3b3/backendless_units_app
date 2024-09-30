import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    this.hideText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool hideText;

  @override
  Widget build(BuildContext context) {
    // This widget represents a custom text field that can be used in forms or input fields.
    // It provides a consistent style and customization options.

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
      child: TextField(
        // Determine whether the text should be obscured (e.g., for password fields).
        obscureText: hideText,

        // The style for the entered text.
        style: const TextStyle(color: Colors.white),

        // The color of the cursor.
        cursorColor: Colors.white,

        // The controller that manages the text field's value.
        controller: controller,

        // The type of keyboard to display.
        keyboardType: keyboardType,

        // The decoration for the text field.
        decoration: InputDecoration(
          // The style for the label (placeholder) text.
          labelStyle: const TextStyle(color: Colors.white),

          // The border displayed when the text field is focused.
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),

          // The border displayed when the text field is enabled but not focused.
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),

          // The label text displayed above the text field.
          labelText: labelText,
        ),
      ),
    );
  }
}
