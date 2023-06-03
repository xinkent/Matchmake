import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'member.dart';

class MemberStore {
  // ストアのインスタンス
  static final MemberStore _instance = MemberStore._internal();

  // 保存時のキー
  final String _saveKey = "Member";

  List<Member> _list = [];

  // プライベートコンストラクタ
  MemberStore._internal();

  // ファクトリコンストラクタ
  factory MemberStore() {
    return _instance;
  }

  // メンバーの件数を取得する
  int count() {
    return _list.length;
  }

  List<Member> getAllMembers() {
    return _list;
  }

  // 指定したインデックスのMemberを取得する
  Member findByIndex(int index) {
    return _list[index];
  }

  // 指定したIDのMemberを取得する
  Member findById(int id) {
    return _list.firstWhere((item) => item.id == id);
  }

  // Memberを追加する
  void add(String name, Sex sex, Level level) {
    final id = count() == 0 ? 1 : _list.last.id + 1;
    final member = Member(id, name, sex, level);
    _list.add(member);
    save();
    print('add member: $name');
  }

  // Memberを更新する
  void update(Member member, [String? name, Sex? sex, Level? level]) {
    if (name != null) {
      member.name = name;
    }
    if (sex != null) {
      member.sex = sex;
    }
    if (level != null) {
      member.level = level;
    }
    save();
  }

  // Memberを削除する
  void delete(Member member) {
    _list.remove(member);
    save();
  }

  /// Memberを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  /// Todoを読込する
  Future<void> load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => Member.fromJson(json.decode(a))).toList();
  }
}
