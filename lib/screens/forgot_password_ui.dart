
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/ShapesPainter.dart';
import '../models/map_coffee_shop.dart';

class ForGotPassWordUI extends StatelessWidget {

  TextEditingController emailCtrl = TextEditingController(text: '');

  final auth = FirebaseAuth.instance;
  MapCoffeeShop mapCoffeeShop = MapCoffeeShop();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    showWarningDialog(String msg) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Container(
                width: double.infinity,
                color: Color(0xff955000),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Text(
                    'คำเตือน',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                      color: Color(0xff955000),
                      fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xffFFB35C),
          );
        },
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff955000)
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFFA238),
      ),
      body: Stack(
        children: [
          Container(
            height: hi,
            width: wi,
            color: const Color(0xffFFBD71),
          ),
          Container(
            width: wi,
            height: hi,
            child: CustomPaint(  /*ใช้ในการสร้างตัวเรขาคณิต โดยที่ต้องไปสร้าง class ใหม่*/
              painter: ShapesPainter(),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  scrollPadding: const EdgeInsets.all(10),
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xff955000),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff955000),
                          width: 2.0,
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff955000),
                          width: 3.0
                      ),
                    ),
                    hintText: 'sunny@hotmail.com',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    labelText: 'E-Mail',
                    labelStyle: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (email){
                    mapCoffeeShop.email = email;
                  },
                ),
              ),//email
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 50),
                child: Container(
                  width: wi,
                  height: 50,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        if(emailCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใสอีเมล์ด้วย!!!');
                        }
                        else{
                          try{
                            auth.sendPasswordResetEmail(
                              email: mapCoffeeShop.email!
                            );
                            Navigator.of(context).pop();
                          }catch(e){
                            print('เกิดข้อผิดพลาด');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        primary: const Color(0xff955000),
                      ),
                      child: const Text(
                        'ยืนยัน',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ),//bottom
            ],
          )

        ],
      ),
    );
  }
}
