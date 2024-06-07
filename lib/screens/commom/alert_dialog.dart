import 'package:flutter/material.dart';

Future<dynamic> showMessageAlertDialog(
  BuildContext context,
  String content, {
  String title = "Atenção!",
  String affirmativeOption = "OK",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(title), content: Text(content), actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              affirmativeOption.toUpperCase(),
              style: const TextStyle(
                  color: Colors.brown, fontWeight: FontWeight.bold),
            )),
      ]);
    },
  );
}
