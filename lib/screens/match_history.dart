import 'package:flutter/material.dart';
import 'package:matchmake/stores/member.dart';
import 'package:matchmake/stores/playing_member.dart';

class MatchHistoryPage extends StatelessWidget {
  final List<PlayingMember> playingMembers;
  const MatchHistoryPage({super.key, required this.playingMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play Count')),
      body: ListView.builder(
          itemCount: playingMembers.length,
          itemBuilder: (context, index) {
            playingMembers
                .sort(((a, b) => b.getPlayCount().compareTo(a.getPlayCount())));
            final member = playingMembers[index];
            return Card(
                child: ListTile(
              title: Text('${member.name}'),
              leading: Icon(
                Icons.accessibility,
                color: member.sex == Sex.male
                    ? Colors.lightBlue
                    : Colors.deepOrangeAccent,
              ),
              trailing: Text('${member.getPlayCount()} 回'),
            ));
          }),
    );
  }
}
