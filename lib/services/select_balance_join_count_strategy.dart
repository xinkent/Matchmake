import 'package:matchmake/services/select_member_strategy.dart';
import 'package:matchmake/stores/playing_member.dart';
import 'package:matchmake/stores/match_members.dart';

import '../stores/member.dart';

class selectBalanceJoinCountStrategy implements SelectMemberStrategy {
  @override
  List<MatchMembers> select(List<PlayingMember> playingMembers, int courtCount,
      List<String> matchHistory) {
    // 練習参加者を参加回数が少ない順、連続休み回数が多い順に並び替え、上位の参加者を抽出する。
    playingMembers.shuffle();
    playingMembers.sort((a, b) {
      int result = a.getPlayCount().compareTo(b.getPlayCount());
      if (result != 0) return result;
      return b.getConsecutiveRestCount().compareTo(a.getConsecutiveRestCount());
    });
    List<PlayingMember> nextPlayMembers =
        playingMembers.sublist(0, courtCount * 4);

    // 試合組を作成
    int RETRY_MAX = 5;
    List<MatchMembers> newMatchMembersList = [];
    for (int i = 0; i < RETRY_MAX; i++) {
      newMatchMembersList = makeMatchMembersList(nextPlayMembers, courtCount);
      // これまでに同じ試合組が存在する場合はリトライする
      if (!existsSameMatch(newMatchMembersList, matchHistory)) {
        break;
      }
    }
    return newMatchMembersList;
  }

  // 指定されたメンバーリストとコート数から、試合組を決定する
  // 渡されるメンバー人数はコート数と一致している前提とする。
  List<MatchMembers> makeMatchMembersList(
      List<PlayingMember> matchMembersList, int courtCount) {
    List<MatchMembers> newMatchMembersList = [];
    for (int i = 0; i < courtCount; i++) {
      MatchMembers matchMember = MatchMembers(
        matchMembersList.sublist(i * 4, (i + 1) * 4),
      );
      MatchMembers mixCoordinatedMatchMember = coordinateMixMatch(matchMember);
      newMatchMembersList.add(mixCoordinatedMatchMember);
    }

    return newMatchMembersList;
  }

  bool existsSameMatch(
      List<MatchMembers> matchMembersList, List<String> matchHistory) {
    for (var matchMembers in matchMembersList) {
      if (matchHistory.contains(matchMembers.getMatchMembersString())) {
        return true;
      }
    }
    return false;
  }

  // 可能な場合Mixにする
  MatchMembers coordinateMixMatch(MatchMembers matchMembers) {
    if (matchMembers.getMaleMemberCount() != 2) {
      return matchMembers;
    }
    // Male: 2, Female:2の場合のみ、Mixになるように配慮する
    List<PlayingMember> maleMatchMembers =
        matchMembers.getAllMembers().where((e) => e.sex == Sex.male).toList();
    List<PlayingMember> femaleMatchMembers =
        matchMembers.getAllMembers().where((e) => e.sex == Sex.female).toList();
    List<PlayingMember> newMembersList = [];
    newMembersList.add(maleMatchMembers[0]);
    newMembersList.add(femaleMatchMembers[0]);
    newMembersList.add(maleMatchMembers[1]);
    newMembersList.add(femaleMatchMembers[1]);
    return MatchMembers(newMembersList);
  }
}
