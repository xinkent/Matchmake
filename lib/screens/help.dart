import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('使い方')),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'このアプリの使い方',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
              Text(
                'このアプリではバドミントンやテニスのダブルスの試合の組み分けをすることができます。 \n'
                'メンバー設定画面でメンバーを追加した後、「練習を開始する」ボタンを押してコート数と練習参加メンバーを設定するだけですぐに開始することができます',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '組み分けの選択方法',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
              Text(
                '試合組の決め方は以下のルールに従います \n'
                '① 試合参加回数が少ないメンバーが優先的に試合に参加するようにします。 \n'
                '② 同じ試合組が設定されることは可能な限り回避します。 \n\n'
                '表示された試合組を変更したい場合は再度自動生成することも、手動でメンバーを変更することも可能です',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '注意点',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
              Text(
                '練習を終了するとそれまでの試合回数がリセットされてしまうので注意してください \n',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ));
  }
}
