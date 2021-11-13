// import 'package:flutter/material.dart';
//
// class MyHomePage extends StatelessWidget {
//   final menus = List<String>.generate(5, (index) => "メニュー $index");
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.deepOrange,
//             title: Text('メニュー画面'),
//           ),
//           body: Container(
//             width: double.infinity,
//             child: ListView.builder(
//               itemCount: menus.length,
//                 itemBuilder: (context, index) {
//                   final menu = menus[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 100,
//                           width: 200,
//                           child: Image.asset('assets/images/MenuImg.jpg'),
//                         ),
//                         Container(
//                           width: 150,
//                           child: Text(
//                             '$menus',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//             ),
//           )),
//     );
//   }
// }