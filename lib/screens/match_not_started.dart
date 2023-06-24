import 'package:flutter/material.dart';
import 'package:matchmake/stores/playing_member.dart';
import 'package:matchmake/screens/member_list.dart';
import '../stores/member.dart';
import 'match_setting.dart';

class MatchNotStartedPage extends StatelessWidget {
  final Function(List<PlayingMember>) updateJoinMembers;
  final Function(bool) updateStarted;
  final Function(int) updateCourtCount;
  final Function() navigateToMemberListPage;
  const MatchNotStartedPage({
    super.key,
    required this.updateJoinMembers,
    required this.updateStarted,
    required this.updateCourtCount,
    required this.navigateToMemberListPage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: FilledButton(
              onPressed: () => navigateToMatchSettingPage(context),
              child: const Text('練習を開始する'),
            ),
          ),
          const SizedBox(
            width: 200,
            height: 50,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: FilledButton(
              onPressed: () => navigateToMemberListPage(),
              child: const Text('メンバーを追加する'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> navigateToMatchSettingPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => MatchSettingPage(
        updateJoinMembers: updateJoinMembers,
        updateCourtCount: updateCourtCount,
        updateStarted: updateStarted,
      ),
    );
    await Navigator.of(context).push(route);
  }
}
