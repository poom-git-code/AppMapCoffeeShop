import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        child: Scaffold(
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue.shade200,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.apartment
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.apartment
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.apartment
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.apartment
                  ),
                  color: Colors.white,
                ),
                Divider(),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Container(
            width: 50,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: (){

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

        ),
      ),
    );
  }
}
