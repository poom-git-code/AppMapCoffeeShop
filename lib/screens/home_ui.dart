import 'dart:io';

import 'package:app_map_coffee_shop/screens/login_ui.dart';
import 'package:app_map_coffee_shop/screens/select_shop_pic_ui.dart';
import 'package:app_map_coffee_shop/screens/show_manu_page.dart';
import 'package:app_map_coffee_shop/screens/update_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../models/ShapesPainter.dart';
import '../models/map_coffee_shop.dart';
import '../servers/api_map_coffee_shop.dart';

class HomeUI extends StatefulWidget {

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  final auth = FirebaseAuth.instance;
  MapCoffeeShop mapCoffeeShop = MapCoffeeShop();
  CollectionReference collectionRef =
    FirebaseFirestore.instance.collection("mcs_location");

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
                          auth.signOut().then((value){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return LoginUI();
                                    }
                                )
                            );
                          });
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
                    SizedBox(width: 30,),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
                          'ยกเลิก',
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
    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("mcs_location")
        .where('Email', isEqualTo: email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Coffee Shop',
          style: TextStyle(
            color: Color(0xff955000),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFA238),
        actions: [
          IconButton(
            onPressed: (){
              showWarningDialog('ต้องการออกจากระบบหรือไม่');
            },
            icon: const Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: Color(0xff955000),
            ),
          )
        ],
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
          StreamBuilder<QuerySnapshot>(
            stream: _userStrem,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 100.0,
                          backgroundColor: Color(0x00FFB35C),
                          child: ClipOval(
                            child: SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/Coffee_icon.png',
                                image: data['Image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        // Text(data['Description']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: wi * 0.35,
                              height: hi * 0.2,
                              child: RawMaterialButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateRegister(),
                                      )
                                  );
                                },
                                fillColor: Color(0xff955000),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                elevation: 3.0,
                                child: Column(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      'ข้อมูลส่วนตัว',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.only(top: 25),
                              ),
                            ),
                            SizedBox(width: wi * 0.1,),
                            Container(
                              width: wi * 0.35,
                              height: hi * 0.2,
                              child: RawMaterialButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectShopPicUI()
                                      )
                                  );
                                },
                                fillColor: Color(0xff955000),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                elevation: 3.0,
                                child: Column(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.shop,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      'รูปร้านค้า',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.only(top: 25),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: wi * 0.15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: wi * 0.35,
                              height: hi * 0.2,
                              child: RawMaterialButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowManuUI()
                                      )
                                  );
                                },
                                fillColor: Color(0xff955000),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                elevation: 3.0,
                                child: Column(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.mugHot,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      'เมนู',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.only(top: 25),
                              ),
                            ),
                            SizedBox(width: wi * 0.1,),
                            Container(
                              width: wi * 0.35,
                              height: hi * 0.2,
                              child: RawMaterialButton(
                                onPressed: (){},
                                fillColor: Color(0xff955000),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                elevation: 3.0,
                                child: Column(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.message,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      'ดู/อ่านรีวิวลูกค้า',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.only(top: 25),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
              );
            }
          ),
        ],
      ),
    );
    

  }
}

