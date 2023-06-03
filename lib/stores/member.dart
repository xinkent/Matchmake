class Member {
  late int id;
  late String name;
  late Sex? sex;
  late Level? level;

  Member(this.id, this.name, this.sex, this.level);

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'sex': sex?.name ?? '',
      'level': level?.name ?? ''
    };
  }

  Member.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    sex = json.containsKey('sex') ? Sex.values.byName(json['sex']) : null;
    level =
        json.containsKey('level') ? Level.values.byName(json['level']) : null;
  }
}

enum Sex {
  male(name: 'male', japanname: '男性'),
  female(name: 'female', japanname: '女性');

  const Sex({required this.name, required this.japanname});

  final String name;
  final String japanname;

  String getJapanName() {
    return japanname;
  }
}

enum Level {
  high(name: 'high', japanname: '上級者', level: 5),
  highmiddle(name: 'highmiddle', japanname: '中上級者', level: 4),
  middle(name: 'middle', japanname: '中級者', level: 3),
  middlelow(name: 'middlelow', japanname: '初中級者', level: 2),
  low(name: 'low', japanname: '初級者', level: 1);

  const Level({
    required this.name,
    required this.japanname,
    required this.level,
  });

  final String name;
  final String japanname;
  final int level;

  String getJapanName() {
    return japanname;
  }
}
