import 'package:matchmake/stores/match_pair.dart';
import 'package:matchmake/stores/member.dart';
import 'package:matchmake/stores/playing_member.dart';

class MatchMembers {
  late MatchPair _matchPair1;
  late MatchPair _matchPair2;

  MatchMembers(List<PlayingMember> members) {
    assert(members.length == 4);
    _matchPair1 = MatchPair(members[0], members[1]);
    _matchPair2 = MatchPair(members[2], members[3]);
  }

  MatchPair getMatchPair1() {
    return _matchPair1;
  }

  MatchPair getMatchPair2() {
    return _matchPair2;
  }

  List<PlayingMember> getAllMembers() {
    return _matchPair1.getAllMembers() + _matchPair2.getAllMembers();
  }

  String getMatchMembersString() {
    List<PlayingMember> allMembers = getAllMembers();
    allMembers.sort((a, b) => a.id.compareTo(b.id));
    return allMembers.map((e) => e.id.toString()).toList().join('');
  }

  PlayingMember getMemberByPosition(int position) {
    assert(position <= 3);
    if (position == 0) {
      return getMatchPair1().getMember1();
    } else if (position == 1) {
      return getMatchPair1().getMember2();
    } else if (position == 2) {
      return getMatchPair2().getMember1();
    } else {
      return getMatchPair2().getMember2();
    }
  }

  void setMemberByPosition(int position, PlayingMember newMember) {
    assert(position <= 3);
    if (position == 0) {
      getMatchPair1().setMember1(newMember);
    } else if (position == 1) {
      getMatchPair1().setMember2(newMember);
    } else if (position == 2) {
      getMatchPair2().setMember1(newMember);
    } else {
      getMatchPair2().setMember2(newMember);
    }
  }

  int getMaleMemberCount() {
    return getAllMembers().where((e) => e.sex == Sex.male).toList().length;
  }

  int getFemaleMemberCount() {
    return getAllMembers().where((e) => e.sex == Sex.female).toList().length;
  }
}
