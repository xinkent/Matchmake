import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchmake/stores/empty_playing_member.dart';
import 'package:matchmake/stores/playing_member.dart';

import '../stores/match_members.dart';
import '../stores/member.dart';

class MatchDropdown extends StatelessWidget {
  final List<PlayingMember> joinMembers;
  // final Member member;
  final MatchMembers matchMember;
  final int matchNo;
  final int memberPosition;
  final Function(int, int, PlayingMember) updateMatchMember;
  const MatchDropdown({
    super.key,
    required this.joinMembers,
    required this.matchNo,
    required this.memberPosition,
    required this.updateMatchMember,
    required this.matchMember,
  });

  @override
  Widget build(BuildContext context) {
    // 初期選択されるメンバー
    PlayingMember member = matchMember.getMemberByPosition(memberPosition);

    // メンバー選択のドロップダウンリストを作成する

    List<DropdownMenuItem<int>> dropDownItemList = [];
    // 空メンバー
    dropDownItemList.add(makeEmptyDropdownItem());
    // 現在の選択値(空メンバーでない場合のみ)
    if (member is! EmptyPlayingMember) {
      dropDownItemList.add(makeMemberDropdownItem(member));
    }
    // 選択可能なメンバー
    for (PlayingMember member in joinMembers) {
      if (matchMember
          .getAllMembers()
          .where((m) => m.id == member.id)
          .toList()
          .isNotEmpty) {
        continue;
      }
      dropDownItemList.add(makeMemberDropdownItem(member));
    }

    return DropdownButton(
      isExpanded: true,
      items: dropDownItemList,
      value: member.id,
      onChanged: (int? value) {
        // 空欄が選択された場合、参加メンバーに空メンバーを追加
        if (value! == -1) {
          EmptyPlayingMember newMember = EmptyPlayingMember();
          updateMatchMember(matchNo, memberPosition, newMember);
        } else {
          // メンバーが選択された場合、選択されたメンバーで参加メンバーを更新
          PlayingMember newMember =
              joinMembers.firstWhere((item) => item.id == value!);
          updateMatchMember(matchNo, memberPosition, newMember);
        }
      },
    );
  }

  DropdownMenuItem<int> makeMemberDropdownItem(PlayingMember member) {
    DropdownMenuItem<int> dropDownItem = DropdownMenuItem<int>(
        value: member.id,
        child: Text(
          member.name,
          style: TextStyle(
            color: member.sex == Sex.male
                ? Color.fromARGB(255, 131, 187, 236)
                : Color.fromARGB(255, 242, 180, 162),
          ),
        ));
    return dropDownItem;
  }

  DropdownMenuItem<int> makeEmptyDropdownItem() {
    DropdownMenuItem<int> dropDownItem = const DropdownMenuItem<int>(
        value: -1,
        child: Text(
          "",
        ));
    return dropDownItem;
  }
}
