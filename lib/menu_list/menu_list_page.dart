import 'package:cook_menu/add_menu/add_menu_page.dart';
import 'package:cook_menu/domain/menu.dart';
import 'package:cook_menu/menu_list/menu_list_model.dart';
import 'package:flutter/material.dart';
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

            if(menus == null) {
              // nullのときグルグル出る!
              return CircularProgressIndicator();
            }

            // MenuをWidgetに変換しないと怒られる!
            // menusに!つける
            final List<Widget> widgets = menus.map(
              (menu) => ListTile(
                // Textウイジェット入れないと怒られる(例)Text(menu.title)
                title: Text(menu.title),
                subtitle: Text(menu.content),
              ),
            ).toList();
            return ListView(
              // 28行目のfinal List<Widget> widgetsに修正「widgetsという変数」
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
          Consumer<MenuListModel>(builder: (context, model, child) {
            return FloatingActionButton(
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

                if(added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('献立を追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                model.fetchMenuList();
              },
              child: Icon(Icons.add,),
            );
          }
        ),
      ),
    );
  }
}
