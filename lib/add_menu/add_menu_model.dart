import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMenuModel extends ChangeNotifier {
  String? title;
  String? content;

  // Future型で書く
  Future addMenu() async {
    if(title == null || title == "") {
      throw '献立のタイトルが入力されていません!';
    }

    if(content == null || content!.isEmpty) {
      throw '献立の種類が入力されていません!';
    }

    // firestoreに追加
    // ディクショナリ型というもので書く
    await FirebaseFirestore.instance.collection('menus').add({
      'title': title,
      'content': content,
    });
  }
}