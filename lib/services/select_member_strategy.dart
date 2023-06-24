import '../stores/match_members.dart';
import '../stores/playing_member.dart';

abstract class SelectMemberStrategy {
  List<MatchMembers> select(List<PlayingMember> playingMembers, int courtCount);
}
