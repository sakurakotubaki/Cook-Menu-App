import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_menu/domain/menu.dart';
import 'package:flutter/material.dart';

class EditMenuModel extends ChangeNotifier {
  // menuにコントローラーの値を入れる
  final Menu menu;
  EditMenuModel(this.menu) {
    titleController.text = menu.title;
    contentController.text = menu.content;
  }

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String? title;
  String? content;

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setContent(String content) {
    this.content = content;
    notifyListeners();
  }

  bool isUpdated() {
    return title != null || content != null;
  }

  // Future型で書く
  Future update() async {
    this.title = titleController.text;
    this.content = contentController.text;

    // firestoreに追加
    // ディクショナリ型というもので書く
    await FirebaseFirestore.instance.collection('menus').doc(menu.id).update({
      'title': title,
      'content': content,
    });
  }
}