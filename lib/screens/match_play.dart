import 'package:flutter/material.dart';
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
  late List<MatchMembers> matchMembersList;
  int matchCount = 0;

  @override
  void initState() {
    // 参加メンバーの中からランダムに抽出する
    randomChoiceMatchMembers();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropDownItemList = [];
    for (Member member in widget.joinMembers) {
      DropdownMenuItem<int> dropDownItem =
          DropdownMenuItem<int>(value: member.id, child: Text(member.name));
      dropDownItemList.add(dropDownItem);
    }

    return Column(children: [
      SizedBox(height: 10),
      Text(
        'Match ${matchCount + 1}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      Flexible(
        child: ListView.separated(
          itemCount: widget.courtCount,
          itemBuilder: (context, index) {
            final matchMembers = matchMembersList[index];
            return Column(
              children: [
                Text('Court ${index + 1}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 150,
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
                      height: 150,
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
            thickness: 2,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 組み合わせ変更ボタン
          IconButton(
            onPressed: () {
              randomChoiceMatchMembers();
            },
            icon: const Icon(Icons.change_circle),
            iconSize: 60,
          ),
          const SizedBox(width: 40),
          // 次の試合ボタン
          IconButton(
            onPressed: () {
              if (existSameMembers()) {
                showDialog<void>(
                    context: context,
                    barrierColor: Colors.white.withOpacity(0.3),
                    builder: (_) {
                      return GeneralErrorDialog(message: 'メンバーが重複しています');
                    });
              } else {
                showDialog<void>(
                  context: context,
                  barrierColor: Colors.white.withOpacity(0.3),
                  builder: (_) {
                    return NextMatchDialog(
                      recordPlayCount: recordPlayCount,
                      randomChoiceMatchMembers: randomChoiceMatchMembers,
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
                barrierColor: Colors.white.withOpacity(0.3),
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

  void randomChoiceMatchMembers() {
    // 参加メンバーの中からランダムに抽出する
    List<MatchMembers> newMatchMembersList = [];
    widget.joinMembers.shuffle();
    for (int i = 0; i < widget.courtCount; i++) {
      MatchMembers matchMember = MatchMembers(
        widget.joinMembers.sublist(i * 4, (i + 1) * 4),
      );
      newMatchMembersList.add(matchMember);
      setState(() {
        matchMembersList = newMatchMembersList;
      });
    }
  }

  void incrementMatchCount() {
    setState(() {
      matchCount++;
    });
  }

  void recordPlayCount() {
    setState(() {
      for (MatchMembers matchMembers in matchMembersList) {
        for (PlayingMember member in matchMembers.getAllMembers()) {
          member.incremetPlayCount();
        }
      }
    });
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
