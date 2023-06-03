import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../stores/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final Function(Member) deleteMember;
  final Function(Member) navigateToEditPage;
  const MemberCard({
    super.key,
    required this.member,
    required this.deleteMember,
    required this.navigateToEditPage,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteMember(member);
            },
            // backgroundColor: Colors.yellow,
            icon: Icons.delete,
            label: 'delete',
          ),
          SlidableAction(
              onPressed: (context) {
                navigateToEditPage(member);
              },
              // backgroundColor: Colors.yellow,
              icon: Icons.edit,
              label: 'edit')
        ],
      ),
      child: Card(
        child: ListTile(
          leading: Icon(
            Icons.accessibility,
            color: member.sex == Sex.male
                ? Colors.lightBlue
                : Colors.deepOrangeAccent,
          ),
          title: Text('${member.name}: ${member.level?.getJapanName() ?? ''}'),
        ),
      ),
    );
  }
}
