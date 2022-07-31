import 'package:app_map_coffee_shop/screens/select_manu_page.dart';
import 'package:app_map_coffee_shop/screens/show_manu_coffee_ui.dart';
import 'package:app_map_coffee_shop/screens/show_manu_sweets_ui.dart';
import 'package:flutter/material.dart';
import '../models/ShapesPainter.dart';

class ShowManuUI extends StatefulWidget {

  @override
  State<ShowManuUI> createState() => _ShowManuUIState();
}


class _ShowManuUIState extends State<ShowManuUI> {

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เมนู',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color(0xff955000)
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFFA238),
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectManuPage()
                )
            );
          },
          backgroundColor: Color(0xffd55e2d),
          label: const Text(
            "+",
            style: TextStyle(
                fontSize: 40
            ),
          ),
          elevation: 10,
          tooltip: 'เพิ่มเมนู',
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: wi,
            height: hi,
            color: Color(0xffFFB35C),
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: const [
                TabBar(
                  isScrollable: false,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xff955000),
                  labelColor: Color(0xff955000),
                  indicatorWeight: 3,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                  tabs: [
                    Tab(text: 'เครื่องดื่ม',),
                    Tab(text: 'อื่นๆ',),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ShowManuCoffeeUI(),
                      ShowManuSweetsUI(),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ]
      )
    );
  }
}
