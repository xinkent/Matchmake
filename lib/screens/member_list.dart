import 'package:flutter/material.dart';

import '../stores/member.dart';
import '../stores/member_store.dart';
import '../widgets/member_card.dart';
import 'member_add.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MemberListPage> {
  final MemberStore _store = MemberStore();

  @override
  void initState() {
    super.initState();
    refreshMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: navigateToAddPage,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshMembers,
        child: ListView.builder(
          itemCount: _store.count(),
          itemBuilder: (context, index) {
            final member = _store.findByIndex(index);
            return MemberCard(
              member: member,
              deleteMember: deleteMember,
              navigateToEditPage: navigateToEditPage,
            );
          },
        ),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddMemberPage(),
    );
    await Navigator.of(context).push(route);
    setState(() {
      _store.load();
    });
  }

  Future<void> deleteMember(Member member) async {
    setState(() {
      _store.delete(member);
    });
  }

  Future<void> navigateToEditPage(Member member) async {
    final route = MaterialPageRoute(
      builder: (context) => AddMemberPage(member: member),
    );
    await Navigator.of(context).push(route);
    setState(() {
      _store.load();
    });
  }

  Future<void> refreshMembers() async {
    setState(() {
      _store.load();
    });
  }
}
