import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    List<DropdownMenuItem<int>> dropDownItemList = [];
    for (Member member in joinMembers) {
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
      dropDownItemList.add(dropDownItem);
    }

    Member member = matchMember.getMemberByPosition(memberPosition);
    return DropdownButton(
      isExpanded: true,
      items: dropDownItemList,
      value: member.id,
      onChanged: (int? value) {
        PlayingMember newMember =
            joinMembers.firstWhere((item) => item.id == value!);
        updateMatchMember(matchNo, memberPosition, newMember);
      },
    );
  }
}
