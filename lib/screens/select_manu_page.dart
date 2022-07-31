import 'package:app_map_coffee_shop/screens/select_manu2_ui.dart';
import 'package:app_map_coffee_shop/screens/select_manu_ui.dart';
import 'package:flutter/material.dart';

class SelectManuPage extends StatefulWidget {
  const SelectManuPage({Key? key}) : super(key: key);

  @override
  State<SelectManuPage> createState() => _SelectManuPageState();
}

class _SelectManuPageState extends State<SelectManuPage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff955000),
        backgroundColor: Color(0xffFFA238),
        unselectedItemColor: Colors.grey.shade300,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600
        ),
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600
        ),
        currentIndex: _currentIndex,
        onTap: (index){
          if(index == 1){
            setState(() {
              _currentIndex = index;
            });
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return SelectManu2UI();
            // }));
          }else{
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: "เครื่องดืม",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cookie_outlined),
            label: "อื่นๆ",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: getBodyWidget(),
    );
  }
  getBodyWidget() {
    if(_currentIndex == 0){
      return SelectManuUI();
    }else{
      return SelectManu2UI();
    }
  }
}
