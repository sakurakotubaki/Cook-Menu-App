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
                        onTap: () {
                          // 削除しますか?って聞いて、はいだったら削除
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
}
