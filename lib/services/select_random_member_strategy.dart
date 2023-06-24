import 'package:matchmake/services/select_member_strategy.dart';
import 'package:matchmake/stores/match_members.dart';

import '../stores/playing_member.dart';

class SelcectRandomMemberStrategy implements SelectMemberStrategy {
  @override
  List<MatchMembers> select(
      List<PlayingMember> playingMembers, int courtCount) {
    List<MatchMembers> newMatchMembersList = [];
    playingMembers.shuffle();
    for (int i = 0; i < courtCount; i++) {
      MatchMembers matchMember = MatchMembers(
        playingMembers.sublist(i * 4, (i + 1) * 4),
      );
      newMatchMembersList.add(matchMember);
    }
    return newMatchMembersList;
  }
}
