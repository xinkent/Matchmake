import 'package:flutter/material.dart';
import 'package:matchmake/screens/match_history.dart';
import 'package:matchmake/screens/match_not_started.dart';
import 'package:matchmake/screens/match_play.dart';
import 'package:matchmake/screens/match_setting.dart';
import 'package:matchmake/screens/member_list.dart';
import 'package:matchmake/stores/member.dart';
import 'package:matchmake/stores/playing_member.dart';

class MatchHomePage extends StatefulWidget {
  const MatchHomePage({super.key});

  @override
  State<MatchHomePage> createState() => _MatchHomePageState();
}

class _MatchHomePageState extends State<MatchHomePage> {
  // 練習参加者
  List<PlayingMember> _joinMembers = [];

  // 練習開始済みのフラグ
  bool _isStarted = false;
  // コート数
  int _courtCount = 0;

  @override
  void initState() {
    super.initState();
    _courtCount = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MatchMake'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: navigateToMemberListPage,
          ),
          // 今の設計だと試合実施中に参加者が削除された際にエラーが起きるので、設定ボタンは表示させないようにした。
          // if (_isStarted)
          //   IconButton(
          //     icon: const Icon(Icons.settings),
          //     onPressed: navigateToMatchSettingPage,
          //   ),
          if (_isStarted)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: navigateToMatchHistoryPage,
            )
        ],
      ),
      body: Visibility(
        visible: _isStarted,
        replacement: MatchNotStartedPage(
          updateJoinMembers: updateJoinMembers,
          updateStarted: updateStarted,
          updateCourtCount: updateCourtCount,
          navigateToMemberListPage: navigateToMemberListPage,
        ),
        child: MatchPlayPage(
          courtCount: _courtCount,
          joinMembers: _joinMembers,
          resetPractice: resetPractice,
        ),
      ),
    );
  }

  void updateJoinMembers(List<PlayingMember> members) {
    setState(() {
      _joinMembers = members;
    });
  }

  void updateCourtCount(int courtCount) {
    setState(() {
      _courtCount = courtCount;
    });
  }

  void updateStarted(bool newIsStarted) {
    setState(() {
      _isStarted = newIsStarted;
    });
  }

  void resetPractice() {
    // initState();
    setState(() {
      _isStarted = false;
      _courtCount = 0;
      _joinMembers = [];
    });
  }

  Future<void> navigateToMemberListPage() async {
    final route = MaterialPageRoute(
      builder: (context) => MemberListPage(),
    );
    await Navigator.of(context).push(route);
  }

  Future<void> navigateToMatchSettingPage() async {
    final route = MaterialPageRoute(
      builder: (context) => MatchSettingPage(
        updateJoinMembers: updateJoinMembers,
        updateCourtCount: updateCourtCount,
        updateStarted: updateStarted,
        courtCountDefault: _courtCount,
        joinMembersDefault: _joinMembers,
      ),
    );
    await Navigator.of(context).push(route);
  }

  Future<void> navigateToMatchHistoryPage() async {
    final route = MaterialPageRoute(
      builder: (context) => MatchHistoryPage(playingMembers: _joinMembers),
    );
    await Navigator.of(context).push(route);
  }
}
