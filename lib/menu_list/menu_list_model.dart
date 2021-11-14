import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_menu/domain/menu.dart';
import 'package:flutter/material.dart';

class MenuListModel extends ChangeNotifier {
  // ?つけてnull許容にする
  List<Menu>? menus;

  // 非同期処理に書き換える,getメソッドで一度だけ値を取得する
  void fetchMenuList() async {
    // 型がQuerySnapshot
    final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('menus').get();

    // さっき作ったMenuの型に変換したい
    final List<Menu> menus = snapshot.docs.map((DocumentSnapshot document) {
      // mapの中でmenusに変換する
      Map<String, dynamic> data =
      document.data() as Map<String, dynamic>;
      // idはdocumentに入っている「更新、削除のときに必要」
      final String id = document.id;
      final String title = data['title'];
      final String content = data['content'];
      return Menu(id, title, content);
    }).toList();

    // this.menus = の後に「menus」の変数が入ってなかったら、グルグルがずっと出る!
      this.menus = menus;
      notifyListeners();
  }
}