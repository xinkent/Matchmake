import 'package:matchmake/stores/member.dart';
import 'package:matchmake/stores/playing_member.dart';

class MatchPair {
  PlayingMember member1;
  PlayingMember member2;

  MatchPair(this.member1, this.member2);

  PlayingMember getMember1() {
    return member1;
  }

  PlayingMember getMember2() {
    return member2;
  }

  List<PlayingMember> getAllMembers() {
    return [member1, member2];
  }

  void setMember1(PlayingMember member) {
    member1 = member;
  }

  void setMember2(PlayingMember member) {
    member2 = member;
  }
}
