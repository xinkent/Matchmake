import 'package:flutter/cupertino.dart';
import 'package:matchmake/stores/match_members.dart';

class NextMatchDialog extends StatelessWidget {
  final Function() randomChoiceMatchMembers;
  final Function() incrementMatchCount;
  final Function() recordPlayCount;
  const NextMatchDialog({
    super.key,
    required this.randomChoiceMatchMembers,
    required this.incrementMatchCount,
    required this.recordPlayCount,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
        title: Text('この試合を記録し、次の試合を始めますか？'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('はい'),
            onPressed: () {
              recordPlayCount();
              randomChoiceMatchMembers();
              incrementMatchCount();
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('いいえ'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
  }
}
