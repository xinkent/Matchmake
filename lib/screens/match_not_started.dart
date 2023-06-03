import 'package:flutter/material.dart';
import 'package:matchmake/stores/playing_member.dart';

import '../stores/member.dart';
import 'match_setting.dart';

class MatchNotStartedPage extends StatelessWidget {
  final Function(List<PlayingMember>) updateJoinMembers;
  final Function(bool) updateStarted;
  final Function(int) updateCourtCount;
  const MatchNotStartedPage({
    super.key,
    required this.updateJoinMembers,
    required this.updateStarted,
    required this.updateCourtCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          onPressed: () => navigateToMatchSettingPage(context),
          child: const Text('Start'),
        ),
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
