import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MatchFinishDialog extends StatelessWidget {
  final Function resetPractice;
  const MatchFinishDialog({
    super.key,
    required this.resetPractice,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(title: Text('練習を終了しますか？'), actions: <Widget>[
      CupertinoDialogAction(
        child: Text('いいえ'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      CupertinoDialogAction(
        child: Text('はい'),
        onPressed: () {
          resetPractice();
          Navigator.of(context).pop();
        },
      ),
    ]);
  }
}
