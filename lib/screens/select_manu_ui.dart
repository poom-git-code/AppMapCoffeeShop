import 'dart:io';

import 'package:app_map_coffee_shop/screens/show_manu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ShapesPainter.dart';
import 'package:path/path.dart' as Path;
import '../servers/api_map_coffee_shop.dart';

class SelectManuUI extends StatefulWidget {
  const SelectManuUI({Key? key}) : super(key: key);

  @override
  State<SelectManuUI> createState() => _SelectManuUIState();
}

class _SelectManuUIState extends State<SelectManuUI> {

  File? _image;

  TextEditingController manunameCtrl = TextEditingController(text: '');
  TextEditingController email_idCtrl = TextEditingController(text: '');
  TextEditingController priceCtrl = TextEditingController();


  showBottomSheetForSelectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xffFFC079),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 28.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showSelectImageFromCamera();
                    },
                    style: TextButton.styleFrom(
                      primary: Color(0xff955000),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('กล้อง'),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showSelectImageFormGallery();
                    },
                    style: TextButton.styleFrom(
                      primary: Color(0xff8C00A4),
                    ),
                    icon: const Icon(Icons.camera),
                    label: const Text('แกลอรี่'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSelectImageFromCamera() async {
    PickedFile? imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _image = File(imageFile.path);
    });
  }

  showSelectImageFormGallery() async {
    PickedFile? imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _image = File(imageFile.path);
    });
  }

  showConfirmInsertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFB35C),
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xff955000),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ยืนยัน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ต้องการบันทึกข้อมูลหรือไม่ ?',
                style: TextStyle(
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
                        onPressed: () async {
                          Navigator.pop(context);
                          insertRegisterMapCoffeeShop();
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
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
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
        );
      },
    );
  }

  ShowResultInsertDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFB35C),
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xff955000),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ผลการทำงาน',
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
        );
      },
    );
  }

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

  late List dd_sale_list;
  List<DropdownMenuItem<String>> dd_sale_item = [];
  String? dd_sale_seleted;
  int i = 0;

  void initState(){
    dd_sale_list = [
      'ร้อน',
      'เย็น',
      'ปั้น'
    ];
    for(i ; i < dd_sale_list.length; i++){
      dd_sale_item.add(
        DropdownMenuItem(
          child: Text(
            dd_sale_list[i],
            style: TextStyle(
              color: Color(0xff955000),
              fontWeight: FontWeight.bold,
              fontSize: 20
            ), //style
          ), //Text
          value: i.toString(),
        ), //DropdownMenuItem
      );
    }
    dd_sale_seleted = '0';

    super.initState();
  }

  insertRegisterMapCoffeeShop() async{
    //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
    //ชื่อรูป
    email_idCtrl.text = FirebaseAuth.instance.currentUser!.email!;
    String imageName = Path.basename(_image!.path);

    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_product_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = await ref.getDownloadURL();

      //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api
      bool resultInsertLocation = await apiInsertManuCoffeeShop(
        email_idCtrl.text.trim(),
        manunameCtrl.text.trim(),
        priceCtrl.text.trim(),
        dd_sale_seleted.toString(),
        imageUrl,
      );

      if(resultInsertLocation == true)
      {
        ShowResultInsertDialog("เพิ่มเมนูเรียนร้อยเเล้ว");
      }
      else
      {
        ShowResultInsertDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }

    });

  }


  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มเมนู',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
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
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100.0,
                          backgroundColor: Color(0x00FFB35C),
                          child: ClipOval(
                            child: SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: _image != null
                                  ?
                              Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                                  :
                              Image.asset(
                                'assets/images/Coffee_icon.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: IconButton(
                            onPressed: () {
                              showBottomSheetForSelectImage(context);
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 30.0,
                              color: Color(0xff955000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),// กล้อง
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      scrollPadding: const EdgeInsets.all(10),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: manunameCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.coffee,
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
                        hintText: 'ใส่ชื่อเมนู',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'ชื่อเมนู',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15)
                      ],
                    ),
                  ),// ชื่อเมนู
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40, top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: DropdownButton(
                            isExpanded: true,
                            items: dd_sale_item,
                            value: dd_sale_seleted,
                            iconEnabledColor: Color(0xff955000),
                            dropdownColor: Color(0xffFFCB90),
                            onChanged: (value_data){
                              setState(() {
                                dd_sale_seleted = value_data as String?;
                              });
                            },
                          ),
                          width: 100,
                          height: 60,
                        ),
                        SizedBox(width: wi * 0.1,),
                        Expanded(
                          child: TextField(
                            scrollPadding: const EdgeInsets.all(10),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.coffee_outlined,
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
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelText: 'ราคา',
                              labelStyle: TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 50),
                    child: Container(
                      width: wi,
                      height: 50,
                        child: RawMaterialButton(
                          onPressed: (){
                            if(manunameCtrl.text.trim().length == 0)
                            {
                              showWarningDialog('กรุณาใส่ชื่อเมนูด้วย!!!');
                            }
                            else if(_image == null)
                            {
                              showWarningDialog('กรุณาใส่รูปด้วย!!!');
                            }
                            else if(priceCtrl.text.trim().length == 0)
                            {
                              showWarningDialog('กรุณาใส่ราคาเมนูด้วย!!!');
                            }
                            else
                            {
                              showConfirmInsertDialog();
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                          child: const Text(
                            'เพิ่มเมนู',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          fillColor: const Color(0xff955000),
                        ),

                    ),
                  ),//bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Checkbox(
//         value: cb_hot,
//         onChanged: (value_data){
//           setState(() {
//             cb_hot = value_data!;
//             hot_enable = value_data;
//             if(value_data == false){
//               hotCtrl.clear();
//             }
//           });
//         },
//         activeColor: Color(0xff955000),
//
//       ),
//       const Text(
//         'ร้อน',
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//             color: Color(0xff955000)
//         ),
//       ),
//       SizedBox(width: wi * 0.1,),
//       Expanded(
//         child: TextField(
//           scrollPadding: const EdgeInsets.all(10),
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//           controller: hotCtrl,
//           enabled: hot_enable,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             prefixIcon: Icon(
//               Icons.coffee_outlined,
//               color: Color(0xff955000),
//             ),
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 2.0,
//                 )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 3.0
//               ),
//             ),
//             hintText: '0',
//             hintStyle: TextStyle(
//               color: Colors.grey,
//             ),
//             labelText: 'ราคา',
//             labelStyle: TextStyle(
//               color: Colors.black38,
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),// ร้อน
// Padding(
//   padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 6),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Checkbox(
//         value: cb_cool,
//         onChanged: (value_data){
//           setState(() {
//             cb_cool = value_data!;
//             cool_enable = value_data;
//             if(value_data == false){
//               coolCtrl.clear();
//             }
//           });
//         },
//         activeColor: Color(0xff955000),
//       ),
//       const Text(
//         'เย็น',
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//             color: Color(0xff955000)
//         ),
//       ),
//       SizedBox(width: wi * 0.11,),
//       Expanded(
//         child: TextField(
//           scrollPadding: const EdgeInsets.all(10),
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//           controller: coolCtrl,
//           enabled: cool_enable,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             prefixIcon: Icon(
//               Icons.coffee_outlined,
//               color: Color(0xff955000),
//             ),
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 2.0,
//                 )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 3.0
//               ),
//             ),
//             hintText: '0',
//             hintStyle: TextStyle(
//               color: Colors.grey,
//             ),
//             labelText: 'ราคา',
//             labelStyle: TextStyle(
//               color: Colors.black38,
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),// เย็น
// Padding(
//   padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 6),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Checkbox(
//         value: cb_churn,
//         onChanged: (value_data){
//           setState(() {
//             cb_churn = value_data!;
//             churn_enable = value_data;
//             if(value_data == false){
//               churnCtrl.clear();
//             }
//           });
//         },
//         activeColor: Color(0xff955000),
//       ),
//       const Text(
//         'ปั่น',
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//             color: Color(0xff955000)
//         ),
//       ),
//       SizedBox(width: wi * 0.12,),
//       Expanded(
//         child: TextField(
//           scrollPadding: const EdgeInsets.all(10),
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//           controller: churnCtrl,
//           enabled: churn_enable,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             prefixIcon: Icon(
//               Icons.coffee_outlined,
//               color: Color(0xff955000),
//             ),
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 2.0,
//                 )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                   color: Color(0xff955000),
//                   width: 3.0
//               ),
//             ),
//             hintText: '0',
//             hintStyle: TextStyle(
//               color: Colors.grey,
//             ),
//             labelText: 'ราคา',
//             labelStyle: TextStyle(
//               color: Colors.black38,
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),// ปั่น

