import 'package:flutter/material.dart';

Future<bool?> youSure(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: const Text('Are you sure?'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.done),
                label: const Text('yes'),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: const Icon(Icons.cancel),
                label: const Text('no'),
              ),
            ],
          ),
        );
      });
}
