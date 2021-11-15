import 'package:cook_menu/login/login_model.dart';
import 'package:cook_menu/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        // Provider使うときは、model.の後にコントローラー名書く
                        controller: model.titleController,
                        decoration: InputDecoration(hintText: 'Email'),
                        onChanged: (text) {
                          // notifyListeners();をここで呼ぶ!
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(height: 8),
                      TextField(
                        // Provider使うときは、model.の後にコントローラー名書く
                        controller: model.contentController,
                        decoration: InputDecoration(hintText: 'パスワード'),
                        onChanged: (text) {
                          // notifyListeners();をここで呼ぶ!
                          model.setPassword(text);
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.login();
                            Navigator.of(context).pop();
                          } catch (e) {
                            // スナックバーを使ってエラーを表示!!
                            final snackBar = SnackBar(
                              backgroundColor: Colors.black87,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: Text('ログイン'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87, //ボタンの背景色
                        ),
                      ),
                      TextButton(
                        // model.isUpdated() ? ()を追加
                        onPressed: () async {
                          // 画面遷移
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                              // 下から画面が動いて次のページへ移動する↓
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Text('新規登録の方はこちら', style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                ),
                if(model.isLoading) Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
