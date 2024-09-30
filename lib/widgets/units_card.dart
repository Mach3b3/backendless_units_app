import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:units_app/models/units.dart';

class UnitsCard extends StatelessWidget {
  const UnitsCard({
    Key? key,
    required this.deleteAction,
    required this.units,
  }) : super(key: key);

  final Units units;
  final Function() deleteAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
        // Configuring the Slidable widget
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            // Defining a single SlidableAction for delete functionality
            SlidableAction(
              label: 'Delete',
              icon: Icons.delete,
              backgroundColor: Colors.blue,
              onPressed: (context) {
                deleteAction();
              },
            )
          ],
        ),
        child: ListTile(
          leading: const Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            units.unitDesc,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
