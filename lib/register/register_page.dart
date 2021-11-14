import 'package:cook_menu/register/register_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        // Provider使うときは、model.の後にコントローラー名書く
                        controller: model.emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                        onChanged: (text) {
                          // notifyListeners();をここで呼ぶ!
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(height: 8),
                      TextField(
                        // Provider使うときは、model.の後にコントローラー名書く
                        controller: model.passwordController,
                        decoration: InputDecoration(hintText: 'パスワード'),
                        onChanged: (text) {
                          // notifyListeners();をここで呼ぶ!
                          model.setPassword(text);
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.signUp();
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
                        child: Text('登録する'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87, //ボタンの背景色
                        ),
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
