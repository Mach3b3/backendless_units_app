import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_app/routes/routes.dart';
import 'package:units_app/services/units_service.dart';
import 'package:units_app/services/user_management.dart';

// MACHEBE LI

void main() {
  // Run the app
  runApp(const MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for UserManagement, which manages user authentication and login state
        ChangeNotifierProvider(
          create: (context) => UserManagement(),
        ),
        // Provider for UnitService, which manages unit-related data and operations
        ChangeNotifierProvider(
          create: (context) => UnitService(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // The initial route of the application
        initialRoute: RouteManager.welcome,
        // Callback function to generate routes dynamically
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
