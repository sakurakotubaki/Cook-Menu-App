import 'package:cook_menu/add_menu/add_menu_page.dart';
import 'package:cook_menu/domain/menu.dart';
import 'package:cook_menu/edit_menu/edit_menu_page.dart';
import 'package:cook_menu/menu_list/menu_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MenuListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuListModel>(
      // ..fetchMenuList()つけないと画面開いたときに表示できない!!
      create: (_) => MenuListModel()..fetchMenuList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('献立一覧'),
        ),
        body: Center(
          child: Consumer<MenuListModel>(builder: (context, model, child) {
            // List<Menu>? menusが入ってくれば良い!
            // List<Menu>?にする?つけないとエラー出る!
            final List<Menu>? menus = model.menus;

            if (menus == null) {
              // nullのときグルグル出る!
              return CircularProgressIndicator();
            }

            // MenuをWidgetに変換しないと怒られる!
            // menusに!つける
            final List<Widget> widgets = menus
                .map(
                  (menu) => Slidable(
                    // SlidableでListTileをラップして下の一行を書く↓
                    actionPane: SlidableDrawerActionPane(),
                    child: ListTile(
                      // Textウイジェット入れないと怒られる(例)Text(menu.title)
                      title: Text(menu.title),
                      subtitle: Text(menu.content),
                    ),
                    // 右からスクロールしたら、...,deleteのスライダーを表示する
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '編集',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () async {
                          // 編集画面に遷移

                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMenuPage(menu),
                            ),
                          );

                          if (title != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              // $titleに変更
                              content: Text('$titleを編集しました'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          model.fetchMenuList();
                        },
                      ),
                      IconSlideAction(
                        caption: '削除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          // 削除しますか?って聞いて、はいだったら削除、modelを渡さないとエラー出る!
                          await showConfirmDialog(context, menu, model);
                        },
                      ),
                    ],
                  ),
                )
                .toList();
            return ListView(
              // 28行目のfinal List<Widget> widgetsに修正「widgetsという変数」
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<MenuListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            backgroundColor: Colors.black87,
            // 非同期処理に変更する
            onPressed: () async {
              // 画面遷移
              // nullのこともあるのでbool?つける
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMenuPage(),
                  // 下から画面が動いて次のページへ移動する↓
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('献立を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchMenuList();
            },
            child: Icon(
              Icons.add,
            ),
          );
        }),
      ),
    );
  }

  // 削除のダイアログ関数をFuture型で作る
  Future showConfirmDialog(BuildContext context, Menu menu,MenuListModel model,) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${menu.title}』を削除しますか?"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // modelで削除、引数にmenuを渡す
                await model.delete(menu);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.black87,
                  content: Text('${menu.title}を削除しました'),
                );
                // 画面更新を走らせないと行けないので追加
                model.fetchMenuList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
