import 'package:flutter/material.dart';
import 'package:matchmake/stores/playing_member.dart';
import 'package:matchmake/widgets/general_error_dialog.dart';

import '../stores/member.dart';
import '../stores/member_store.dart';
import '../widgets/match_setting_dialog.dart';

class MatchSettingPage extends StatefulWidget {
  final Function(List<PlayingMember>) updateJoinMembers;
  final Function(int) updateCourtCount;
  final Function(bool) updateStarted;
  int? courtCountDefault;
  List<Member>? joinMembersDefault;

  MatchSettingPage({
    super.key,
    this.courtCountDefault,
    this.joinMembersDefault,
    required this.updateJoinMembers,
    required this.updateCourtCount,
    required this.updateStarted,
  });

  @override
  State<MatchSettingPage> createState() => _MatchSettingPageState();
}

class _MatchSettingPageState extends State<MatchSettingPage> {
  int? _courtCount;
  late Future<List<Member>> _teamMembersFuture;

  // Note: MemberStoreのロード後にsetStateしても反映されなかったため、一旦100で固定している。
  List<bool> _checkedList = List.generate(100, (index) => false);

  @override
  void initState() {
    super.initState();
    _teamMembersFuture = getStoredMembers();
    _courtCount = widget.courtCountDefault;
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropDownItemList = [];
    for (int i = 1; i <= 12; i++) {
      dropDownItemList.add(DropdownMenuItem<int>(value: i, child: Text('$i')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Match Settings'), actions: [
        TextButton(
          child: const Text('Next'),
          onPressed: () {
            if (_courtCount == null) {
              showDialog<void>(
                  context: context,
                  barrierColor: Colors.white.withOpacity(0.3),
                  builder: (_) {
                    return GeneralErrorDialog(message: "コート数が設定されていません");
                  });
              return;
            }

            List<PlayingMember> joinMembers = [];
            _teamMembersFuture.then((members) {
              for (int i = 0; i < members.length; i++) {
                if (_checkedList[i]) {
                  PlayingMember playingMember = PlayingMember(members[i].id,
                      members[i].name, members[i].sex, members[i].level);
                  joinMembers.add(playingMember);
                }
              }
              if (joinMembers.length < _courtCount! * 4) {
                showDialog<void>(
                    context: context,
                    barrierColor: Colors.white.withOpacity(0.3),
                    builder: (_) {
                      return GeneralErrorDialog(message: "設定人数が足りません");
                    });
              } else {
                showDialog<void>(
                    context: context,
                    barrierColor: Colors.white.withOpacity(0.3),
                    builder: (_) {
                      return MatchSettingNextDialog(
                        joinMembers: joinMembers,
                        courtCount: _courtCount!,
                        updateJoinMembers: widget.updateJoinMembers,
                        updateCourtCount: widget.updateCourtCount,
                        updateStarted: widget.updateStarted,
                      );
                    });
              }
            });
          },
        )
      ]),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              DropdownButton(
                isExpanded: true,
                items: dropDownItemList,
                hint: Text("コート数を指定してください"),
                value: _courtCount,
                onChanged: (int? value) {
                  setState(() {
                    _courtCount = value!;
                  });
                },
              ),
              if (_courtCount != null)
                Text('練習に参加するメンバーを${_courtCount! * 4}人以上指定してください'),
              if (_courtCount != null)
                FutureBuilder<List<Member>>(
                  future: _teamMembersFuture,
                  builder: (context, snapshot) {
                    Widget childWidget;
                    if (snapshot.hasData) {
                      var members = snapshot.data;
                      childWidget = Flexible(
                        child: ListView.builder(
                            itemCount: members!.length,
                            itemBuilder: (context, index) {
                              Member member = members[index];
                              return Card(
                                child: CheckboxListTile(
                                  title: Text(member.name),
                                  secondary: Icon(
                                    Icons.accessibility,
                                    color: member.sex == Sex.male
                                        ? Colors.lightBlue
                                        : Colors.deepOrangeAccent,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: _checkedList[index],
                                  onChanged: (bool? value) {
                                    _checkedList[index] = value!;
                                    setState(() {
                                      _checkedList[index] = value;
                                    });
                                  },
                                ),
                              );
                            }),
                      );
                    } else {
                      childWidget = const CircularProgressIndicator();
                    }
                    return childWidget;
                  },
                )
            ],
          )),
    );
  }

  Future<List<Member>> getStoredMembers() async {
    MemberStore memberStore = MemberStore();
    await MemberStore().load();
    var allMembers = memberStore.getAllMembers();

    // デフォルトで選択メンバーが指定されている場合チェックリストを更新する
    if (widget.joinMembersDefault != null) {
      for (int i = 0; i < allMembers.length; i++) {
        Member member = allMembers[i];
        if (widget.joinMembersDefault!
            .where((m) => m.id == member.id)
            .toList()
            .isNotEmpty) {
          _checkedList[i] = true;
        }
      }
    }

    return allMembers;
  }
}
