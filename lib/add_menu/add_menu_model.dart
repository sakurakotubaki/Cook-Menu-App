import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuModel extends ChangeNotifier {
  String? title;
  String? content;
  File? imageFile;
  bool isLoading = false;

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // Future型で書く
  Future addMenu() async {
    if(title == null || title == "") {
      throw '献立のタイトルが入力されていません!';
    }

    if(content == null || content!.isEmpty) {
      throw '献立の種類が入力されていません!';
    }

    // 先にドキュメントを作る
    final doc = FirebaseFirestore.instance.collection('menus').doc();

    String? imgURL;
    if(imageFile != null) {
      // storageにアップロード
      final task = await FirebaseStorage.instance.ref('menus/${doc.id}').putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    // firestoreに追加
    // ディクショナリ型というもので書く
    await doc.set({
      'title': title,
      'content': content,
      'imgURL': imgURL,
    });
  }

  // 画像のアップロードをする関数

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}