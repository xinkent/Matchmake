import 'package:flutter/material.dart';

import '../stores/member.dart';
import '../stores/member_store.dart';

class AddMemberPage extends StatefulWidget {
  final Member? member;
  const AddMemberPage({super.key, this.member});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final MemberStore _store = MemberStore();
  bool _isEdit = false;
  late String _name;
  late TextEditingController _nameController;
  late Sex _sex;
  late Level _level;

  @override
  void initState() {
    super.initState();
    final member = widget.member;

    _isEdit = member != null;
    _name = member?.name ?? '';
    _nameController = TextEditingController(text: _name);
    _sex = member?.sex ?? Sex.male;
    _level = member?.level ?? Level.middle;
  }

  @override
  Widget build(BuildContext context) {
    // 性別用ドロップダウン項目の作成
    List<DropdownMenuItem<Sex>> sexDropdownItem = [];
    for (var sex in Sex.values) {
      sexDropdownItem.add(DropdownMenuItem(
        value: sex,
        child: Text(sex.getJapanName()),
      ));
    }

    // レベル用ドロップダウン項目の作成
    List<DropdownMenuItem<Level>> levelDropdownItem = [];
    for (var level in Level.values) {
      levelDropdownItem.add(DropdownMenuItem(
        value: level,
        child: Text(level.getJapanName()),
      ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Member' : 'Add Member'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'name'),
              maxLength: 10,
              onChanged: (String value) {
                _name = value;
              }),
          const SizedBox(
            height: 30,
          ),
          DropdownButton(
            isExpanded: true,
            value: _sex,
            items: sexDropdownItem,
            onChanged: (Sex? value) {
              setState(() {
                _sex = value!;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          DropdownButton(
            isExpanded: true,
            value: _level,
            items: levelDropdownItem,
            onChanged: (Level? value) {
              setState(() {
                _level = value!;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              if (_isEdit) {
                updateMember();
              } else {
                addMember();
              }
              // Memberリスト画面に戻る
              Navigator.of(context).pop();
            },
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _isEdit ? 'Update' : 'Add',
                )),
          ),
        ],
      ),
    );
  }

  void updateMember() {
    final member = widget.member;
    _store.update(member!, _nameController.text, _sex, _level);
  }

  void addMember() {
    _store.add(_name, _sex, _level);
  }
}
