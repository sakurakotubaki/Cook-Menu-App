import 'package:cook_menu/domain/menu.dart';
import 'package:cook_menu/edit_menu/edit_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMenuPage extends StatelessWidget {
  // 引数もらってないので書く。イニシャライザかコンストラクタ使うどちらも同じ
  final Menu menu;

  EditMenuPage(this.menu);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMenuModel>(
      create: (_) => EditMenuModel(menu),
      child: Scaffold(
        appBar: AppBar(
          title: Text('献立を編集'),
        ),
        body: Center(
          child: Consumer<EditMenuModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    // Provider使うときは、model.の後にコントローラー名書く
                    controller: model.titleController,
                    decoration: InputDecoration(hintText: '献立のタイトル'),
                    onChanged: (text) {
                      // notifyListeners();をここで呼ぶ!
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    // Provider使うときは、model.の後にコントローラー名書く
                    controller: model.contentController,
                    decoration: InputDecoration(hintText: '献立の種類'),
                    onChanged: (text) {
                      // notifyListeners();をここで呼ぶ!
                      model.setContent(text);
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    // model.isUpdated() ? ()を追加
                    onPressed: model.isUpdated()
                        ? () async {
                            // 更新の処理
                            try {
                              // model.でupdate(){}の関数を呼び出す!
                              await model.update();
                              // model.titleと書くと更新したときにタイトルが表示される
                              Navigator.of(context).pop(model.title);
                            } catch (e) {
                              // スナックバーを使ってエラーを表示!!
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black87,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87, //ボタンの背景色
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
