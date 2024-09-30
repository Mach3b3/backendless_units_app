// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    // This widget represents a custom progress indicator with a text message.
    // It is used to show a loading state with a message during asynchronous operations.

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A small container with a CircularProgressIndicator to indicate the progress.
            Container(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // A text widget displaying the provided text message.
            Text(
              text,
              style: const TextStyle(color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
