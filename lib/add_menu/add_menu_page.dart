import 'dart:math';
import 'package:cook_menu/add_menu/add_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMenuModel>(

      create: (_) => AddMenuModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('献立を追加'),
        ),
        body: Center(
          child: Consumer<AddMenuModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: '献立のタイトル'
                    ),
                    onChanged: (text) {
                      model.title = text;
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '献立の種類'
                    ),
                    onChanged: (text) {
                      model.content = text;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                    // 追加の処理
                    try {
                      await model.addMenu();
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      // スナックバーを使ってエラーを表示!!
                      final snackBar = SnackBar(
                        backgroundColor: Colors.black87,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }, child: Text('追加する')),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
