// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:units_app/init.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late final AnimationController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    InitApp.initializeApp(context);
    _initializeApp();
  }

  void _initializeApp() async {
    await InitApp.initializeApp(context);

    setState(() {
      isLoading =
          false; // Set isLoading to false when the initialization process is completed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets1.lottiefiles.com/packages/lf20_UfHr82.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().then((value) {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'UNITS APP',
                  style: GoogleFonts.bitter(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'Loading, please wait',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                      height: 15), //spacing before the progress indicator
                Container(
                  width: 15,
                  height: 15,
                  child:
                      const CircularProgressIndicator(), // Show the progress indicator while initializing the app
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
