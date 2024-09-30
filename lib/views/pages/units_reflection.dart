import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import 'package:units_app/services/helper_units.dart';
import 'package:units_app/services/helper_user.dart';
import 'package:units_app/services/units_service.dart';
import 'package:units_app/services/user_management.dart';
import 'package:units_app/widgets/app_progress.dart';
import 'package:units_app/widgets/units_card.dart';
import 'package:tuple/tuple.dart';

class UnitsReflection extends StatefulWidget {
  const UnitsReflection({Key? key}) : super(key: key);

  @override
  State<UnitsReflection> createState() => _UnitsReflectionState();
}

class _UnitsReflectionState extends State<UnitsReflection> {
  late TextEditingController unitDesccontroller;
  late TextEditingController reflectionscontroller;

  @override
  void initState() {
    super.initState();
    unitDesccontroller = TextEditingController();
    reflectionscontroller = TextEditingController();
  }

  @override
  void dispose() {
    unitDesccontroller.dispose();
    reflectionscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold widget represents the main screen structure in Flutter.
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton for refreshing the unit list
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          refreshUnitsInUI(context);
                        },
                      ),
                      // IconButton for saving all units
                      IconButton(
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          saveAllUnitsInUI(context);
                        },
                      ),
                      // IconButton for adding a new unit
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF9575CD), // Light Purple
                                        Color(0xFF512DA8), // Dark Purple
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Create a new Unit to revise',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Text field for entering unit description
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Please enter the Unit Description',
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                            controller: unitDesccontroller,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Text field for entering unit reflection
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Please enter the unit Reflection',
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                            controller: reflectionscontroller,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Buttons for canceling and saving the new unit
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                createNewUnitInUI(
                                                  context,
                                                  unitdesccontroller:
                                                      unitDesccontroller,
                                                  reflectionscontroller:
                                                      reflectionscontroller,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // IconButton for logging out the user
                      IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          logoutUserInUI(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: provider.Selector<UserManagement, BackendlessUser?>(
                    selector: (context, value) => value.currentUser,
                    builder: (context, value, child) {
                      // Display the user's name followed by "Unit List" if logged in,
                      // otherwise display just "Unit List".
                      return value == null
                          ? Text(
                              'Unit List',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                fontSize: 45,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              '${value.getProperty('name')}\'s Unit List',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                fontSize: 45,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 20,
                    ),
                    child: provider.Consumer<UnitService>(
                      builder: (context, value, child) {
                        // Display the list of units using a ListView.builder.
                        return ListView.builder(
                          itemCount: value.units.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 4,
                                      title: Text(value.units[index].unitDesc),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                                value.units[index].reflections),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: UnitsCard(
                                units: value.units[index],
                                deleteAction: () async {
                                  context
                                      .read<UnitService>()
                                      .deleteUnit(value.units[index]);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Show a progress indicator if user progress is being shown.
          provider.Selector<UserManagement, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.showUserProgress, value.userProgressText),
            builder: (context, value, child) {
              return value.item1
                  ? AppProgressIndicator(text: '${value.item2}')
                  : Container();
            },
          ),
          // Show a progress indicator if retrieving or saving data.
          provider.Selector<UnitService, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.busyRetrieving, value.busySaving),
            builder: (context, value, child) {
              return value.item1
                  ? const AppProgressIndicator(
                      text:
                          'please be patient while we busy retrieving data from the database')
                  : value.item2
                      ? const AppProgressIndicator(
                          text:
                              'please be patient while we busy saving data to the database',
                        )
                      : Container();
            },
          ),
        ],
      ),
    );
  }
}
