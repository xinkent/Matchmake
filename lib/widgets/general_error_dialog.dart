import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralErrorDialog extends StatelessWidget {
  final String message;
  const GeneralErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('はい'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
