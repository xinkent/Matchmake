import 'package:matchmake/stores/member.dart';

class PlayingMember extends Member {
  int _play_count = 0;
  // 連続休み回数
  int _consecutive_rest_count = 0;

  PlayingMember(super.id, super.name, super.sex, super.level);

  int getPlayCount() {
    return _play_count;
  }

  int getConsecutiveRestCount() {
    return _consecutive_rest_count;
  }

  void incremetPlayCount() {
    _play_count++;
  }

  void resetRestCount() {
    _consecutive_rest_count = 0;
  }

  void incrementRestCount() {
    _consecutive_rest_count++;
  }
}
