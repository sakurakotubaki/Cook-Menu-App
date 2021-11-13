import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_menu/domain/menu.dart';
import 'package:flutter/material.dart';

class MenuListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('menus').snapshots();

  // ?つけてnull許容にする
  List<Menu>? menus;

  void fetchMenuList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      // さっき作ったMenuの型に変換したい
      final List<Menu> menus = snapshot.docs.map((DocumentSnapshot document) {
        // mapの中でmenusに変換する
        Map<String, dynamic> data =
        document.data() as Map<String, dynamic>;
        final String title = data['title'];
        final String content = data['content'];
        return Menu(title, content);
      }).toList();
      this.menus;
      notifyListeners();
    });
  }
}