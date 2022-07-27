import 'package:app_map_coffee_shop/screens/forgot_password_ui.dart';
import 'package:app_map_coffee_shop/screens/home_ui.dart';
import 'package:app_map_coffee_shop/screens/register_shop_ui.dart';
import 'package:app_map_coffee_shop/servers/api_map_coffee_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/ShapesPainter.dart';
import '../models/map_coffee_shop.dart';

class LoginUI extends StatefulWidget {

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {

  bool pwValue = false;
  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');
  MapCoffeeShop mapCoffeeShop = MapCoffeeShop();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  late Stream<QuerySnapshot> allUser;


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


  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
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
          SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: hi * 0.05,),
                    Image.asset(
                      'assets/images/Logo_coffee_map.png',
                      width: 300.0,
                      height: 280.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                      child: TextFormField(
                        controller: usernameCtrl,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          labelText: 'อีเมล',
                          labelStyle: TextStyle(
                            color: Colors.black38,
                          ),
                        ),
                        onChanged: (email){
                          mapCoffeeShop.email = email;
                          // mapCoffeeShop.userID = user;
                        },
                      ),
                    ), //login
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                      child: TextFormField(
                        obscureText: !pwValue,
                        controller: passwordCtrl,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xff955000),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff955000),
                                width: 2.0,
                              )
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff955000),
                                width: 3.0
                            ),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          labelText: 'รหัสผ่าน',
                          labelStyle: const TextStyle(
                            color: Colors.black38,
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                pwValue = !pwValue;
                              });
                            },
                            icon: Icon(
                              pwValue ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xff5C5C5C),
                            ),
                          ),
                        ),
                        onChanged: (password){
                          mapCoffeeShop.password = password;
                        },
                      ),
                    ), //password
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(right: 240),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForGotPassWordUI()
                              )
                          );
                        },
                        child: const Text(
                          'ลืมรหัสผ่าน?',
                          style: TextStyle(
                              color: Color(0xff955000),
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ), //forgot
                    Padding(
                      padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () async{
                                  if(usernameCtrl.text.trim().length == 0 && passwordCtrl.text.trim().length == 0){
                                    showWarningDialog('กรุณาใสชื่อผู้ใช้หรือรหัสผ่านด้วย!!!');
                                  }else
                                  {
                                    try{
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: mapCoffeeShop.email!,
                                          password: mapCoffeeShop.password!
                                      ).then((value) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return HomeUI();
                                                }
                                            )
                                        );
                                      });
                                    }
                                    on FirebaseAuthException catch(e){
                                      String message;
                                      if(e.code == 'wrong-password'){
                                        message = 'อีเมลหรือรหัสผ่านไม่ถูกต้องโปรดลองใหม่อีกครั้ง';
                                      }
                                      else{
                                        message = 'อีเมลหรือรหัสผ่านไม่ถูกต้องโปรดลองใหม่อีกครั้ง';
                                      }
                                      Fluttertoast.showToast(
                                          msg: message,
                                          gravity: ToastGravity.CENTER
                                      );
                                    }

                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: const Color(0xff955000),
                                ),
                                child: const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterShopUI()
                                    )
                                );
                              },
                              child: const Text(
                                'สร้างบัญชี',
                                style: TextStyle(
                                    color: Color(0xff955000),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),//bottom
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10, bottom: 20),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 20, right: 20),
                    //         child: Container(
                    //           width: wi,
                    //           height: 60,
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               RawMaterialButton(
                    //                 onPressed: (){},
                    //                 fillColor: Color(0xFF3B5998),
                    //                 shape: const CircleBorder(),
                    //                 elevation: 3.0,
                    //                 child: const Icon(
                    //                   FontAwesomeIcons.facebookF,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 padding: EdgeInsets.all(16.0),
                    //               ),
                    //               Expanded(
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(right: 50, bottom: 5),
                    //                   child: FlatButton(
                    //                     onPressed: (){},
                    //                     child: const Text(
                    //                       'เข้าสู่ระบบด้วย Facebook',
                    //                       style: TextStyle(
                    //                           color: Color(0xFF3B5998),
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 18
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),//facebook
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 20, right: 20),
                    //         child: Container(
                    //           width: wi,
                    //           height: 60,
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               RawMaterialButton(
                    //                 onPressed: (){},
                    //                 fillColor: Color(0xFFEA4335),
                    //                 shape: const CircleBorder(),
                    //                 elevation: 3.0,
                    //                 child: const Icon(
                    //                   FontAwesomeIcons.google,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 padding: EdgeInsets.all(16.0),
                    //               ),
                    //               Expanded(
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(right: 70, bottom: 5),
                    //                   child: FlatButton(
                    //                     onPressed: (){},
                    //                     child: const Text(
                    //                       'เข้าสู่ระบบด้วย Google',
                    //                       style: TextStyle(
                    //                           color: Color(0xFFEA4335),
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 18
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),//google
                    //
                    //     ],
                    //   ),
                    // ),//facebook google
                  ],
                ),
              ),
            ),
        ],
      )

    );
  }
}

