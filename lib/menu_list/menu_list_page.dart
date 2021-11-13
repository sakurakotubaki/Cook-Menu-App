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
      child: SafeArea(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
