import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matchmake/stores/playing_member.dart';

import '../stores/member.dart';

class MatchSettingNextDialog extends StatelessWidget {
  final List<PlayingMember> joinMembers;
  final int courtCount;
  final Function(List<PlayingMember>) updateJoinMembers;
  final Function(int) updateCourtCount;
  final Function(bool) updateStarted;
  const MatchSettingNextDialog(
      {super.key,
      required this.joinMembers,
      required this.courtCount,
      required this.updateJoinMembers,
      required this.updateCourtCount,
      required this.updateStarted});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('この設定で練習を開始しますか？'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('はい'),
          onPressed: () {
            updateJoinMembers(joinMembers);
            updateCourtCount(courtCount);
            updateStarted(true);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text('いいえ'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
