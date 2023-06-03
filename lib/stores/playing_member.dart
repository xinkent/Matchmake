import 'package:matchmake/stores/member.dart';

class PlayingMember extends Member {
  int _play_count = 0;

  PlayingMember(super.id, super.name, super.sex, super.level);

  int getPlayCount() {
    return _play_count;
  }

  void incremetPlayCount() {
    _play_count++;
  }
}
