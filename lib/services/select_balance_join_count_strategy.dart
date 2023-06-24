import 'package:matchmake/services/select_member_strategy.dart';
import 'package:matchmake/stores/playing_member.dart';
import 'package:matchmake/stores/match_members.dart';

class selectBalanceJoinCountStrategy implements SelectMemberStrategy {
  @override
  List<MatchMembers> select(
      List<PlayingMember> playingMembers, int courtCount) {
    // 練習参加者を参加回数が少ない順に並び替え、上位の参加者を抽出する。
    playingMembers.shuffle();
    playingMembers.sort((a, b) => a.getPlayCount().compareTo(b.getPlayCount()));
    List<PlayingMember> nextPlayMembers =
        playingMembers.sublist(0, courtCount * 4);

    List<MatchMembers> newMatchMembersList = [];
    for (int i = 0; i < courtCount; i++) {
      MatchMembers matchMember = MatchMembers(
        nextPlayMembers.sublist(i * 4, (i + 1) * 4),
      );
      newMatchMembersList.add(matchMember);
    }
    return newMatchMembersList;
  }
}
