import 'package:flutter/material.dart';
import 'package:matchmake/services/select_balance_join_count_strategy.dart';
import 'package:matchmake/services/select_random_member_strategy.dart';
import 'package:matchmake/stores/empty_playing_member.dart';
import 'package:matchmake/stores/match_members.dart';
import 'package:matchmake/stores/playing_member.dart';
import 'package:matchmake/widgets/general_error_dialog.dart';
import 'package:matchmake/widgets/match_dropdown.dart';
import 'package:matchmake/widgets/match_finish_dialog.dart';
import 'package:matchmake/widgets/match_next_dialog.dart';

import '../stores/member.dart';

class MatchPlayPage extends StatefulWidget {
  final int courtCount;
  final List<PlayingMember> joinMembers;
  final Function resetPractice;
  const MatchPlayPage({
    super.key,
    required this.courtCount,
    required this.joinMembers,
    required this.resetPractice,
  });

  @override
  State<MatchPlayPage> createState() => _MatchPlayPageState();
}

class _MatchPlayPageState extends State<MatchPlayPage> {
  // 試合参加メンバー(コート数 x 4人)
  late List<MatchMembers> matchMembersList;
  // 試合組履歴
  List<String> matchHistory = [];
  // 第X試合
  int matchCount = 0;

  @override
  void initState() {
    // 参加メンバーの中からランダムに抽出する
    chooseMatchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 10),
      Text(
        '第${matchCount + 1}試合',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Flexible(
        child: ListView.separated(
          itemCount: widget.courtCount,
          itemBuilder: (context, index) {
            final matchMembers = matchMembersList[index];
            return Column(
              children: [
                Text(
                  'コート ${index + 1}',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 150,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MatchDropdown(
                              joinMembers: widget.joinMembers,
                              matchMember: matchMembers,
                              matchNo: index,
                              memberPosition: 0,
                              updateMatchMember: updateMatchMember,
                            ),
                            MatchDropdown(
                              joinMembers: widget.joinMembers,
                              matchMember: matchMembers,
                              matchNo: index,
                              memberPosition: 1,
                              updateMatchMember: updateMatchMember,
                            )
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.close),
                    SizedBox(
                      height: 120,
                      width: 150,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MatchDropdown(
                              joinMembers: widget.joinMembers,
                              matchMember: matchMembers,
                              matchNo: index,
                              memberPosition: 2,
                              updateMatchMember: updateMatchMember,
                            ),
                            MatchDropdown(
                              joinMembers: widget.joinMembers,
                              matchMember: matchMembers,
                              matchNo: index,
                              memberPosition: 3,
                              updateMatchMember: updateMatchMember,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
          padding: const EdgeInsets.all(10),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 1,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 組み合わせ変更ボタン
          IconButton(
            onPressed: () {
              chooseMatchMembers();
            },
            icon: const Icon(Icons.change_circle),
            iconSize: 60,
          ),
          const SizedBox(width: 40),
          // 次の試合ボタン
          IconButton(
            onPressed: () {
              if (existEmptyMember()) {
                showDialog<void>(
                    context: context,
                    barrierColor: Colors.grey.withOpacity(0.6),
                    builder: (_) {
                      return GeneralErrorDialog(message: 'メンバーが選択されていません');
                    });
              } else if (existSameMembers()) {
                showDialog<void>(
                    context: context,
                    barrierColor: Colors.grey.withOpacity(0.6),
                    builder: (_) {
                      return GeneralErrorDialog(message: 'メンバーが重複しています');
                    });
              } else {
                showDialog<void>(
                  context: context,
                  barrierColor: Colors.grey.withOpacity(0.6),
                  builder: (_) {
                    return NextMatchDialog(
                      recordPlayCount: recordPlayCount,
                      chooseMatchMembers: chooseMatchMembers,
                      incrementMatchCount: incrementMatchCount,
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.play_circle),
            iconSize: 60,
          ),
          const SizedBox(width: 40),
          // 試合終了ボタン
          IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierColor: Colors.grey.withOpacity(0.6),
                builder: (_) {
                  return MatchFinishDialog(
                    resetPractice: widget.resetPractice,
                  );
                },
              );
            },
            icon: const Icon(Icons.stop_circle),
            iconSize: 60,
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(20),
      )
    ]);
  }

  void updateMatchMember(
      int matchNo, int memberPosition, PlayingMember newMember) {
    setState(() {
      MatchMembers matchMembers = matchMembersList[matchNo];
      matchMembers.setMemberByPosition(memberPosition, newMember);
    });
  }

  void chooseMatchMembers() {
    // 参加メンバーの中からランダムに抽出する
    List<MatchMembers> newMatchMembersList =
        // SelcectRandomMemberStrategy()
        selectBalanceJoinCountStrategy()
            .select(widget.joinMembers, widget.courtCount, matchHistory);

    setState(() {
      matchMembersList = newMatchMembersList;
    });
    // List<MatchMembers> newMatchMembersList = [];
    // widget.joinMembers.shuffle();
    // for (int i = 0; i < widget.courtCount; i++) {
    //   MatchMembers matchMember = MatchMembers(
    //     widget.joinMembers.sublist(i * 4, (i + 1) * 4),
    //   );
    //   newMatchMembersList.add(matchMember);
    //   setState(() {
    //     matchMembersList = newMatchMembersList;
    //   });
    // }
  }

  void incrementMatchCount() {
    setState(() {
      matchCount++;
    });
  }

  void recordPlayCount() {
    setState(() {
      // 練習参加者全員の休憩カウントをインクリメントするが、
      // 試合参加者は直後の処理でリセットされるので、試合参加者以外の休憩カウントがインクリメントされることになる。
      for (PlayingMember member in widget.joinMembers) {
        member.incrementRestCount();
      }
      for (MatchMembers matchMembers in matchMembersList) {
        // 試合組履歴に追加
        matchHistory.add(matchMembers.getMatchMembersString());

        // 各参加者の試合回数カウントをインクリメントし、休憩回数をリセットする。
        for (PlayingMember member in matchMembers.getAllMembers()) {
          member.incremetPlayCount();
          member.resetRestCount();
        }
      }
    });
  }

  bool existEmptyMember() {
    for (MatchMembers matchMembers in matchMembersList) {
      for (PlayingMember member in matchMembers.getAllMembers()) {
        if (member is EmptyPlayingMember) {
          return true;
        }
      }
    }

    return false;
  }

  bool existSameMembers() {
    List<int> matchMemberIdList = [];
    for (MatchMembers matchMembers in matchMembersList) {
      for (PlayingMember member in matchMembers.getAllMembers()) {
        matchMemberIdList.add(member.id);
      }
    }
    return matchMemberIdList.toSet().length != matchMemberIdList.length;
  }
}
