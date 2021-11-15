import 'package:cook_menu/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage(this.name, this.description);
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(name, description),
      child: Scaffold(
        appBar: AppBar(
          title: Text('プロフィール編集'),
        ),
        body: Center(
          child: Consumer<EditProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    // Provider使うときは、model.の後にコントローラー名書く
                    controller: model.nameController,
                    decoration: InputDecoration(hintText: '名前'),
                    onChanged: (text) {
                      // notifyListeners();をここで呼ぶ!
                      model.setName(text);
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    // Provider使うときは、model.の後にコントローラー名書く
                    controller: model.descriptionController,
                    decoration: InputDecoration(hintText: '自己紹介'),
                    onChanged: (text) {
                      // notifyListeners();をここで呼ぶ!
                      model.setDescription(text);
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
                        Navigator.of(context).pop();
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
