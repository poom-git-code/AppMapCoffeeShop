import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../models/ShapesPainter.dart';
import 'package:flutter/src/material/raised_button.dart';
import 'package:app_map_coffee_shop/servers/api_map_coffee_shop.dart';

class UpdateCoffee extends StatefulWidget {

  String id;
  String? manuname;
  String? price;
  String? type;
  String image;

  UpdateCoffee(
      this.id,
      this.manuname,
      this.price,
      this.type,
      this.image
  );

  @override
  State<UpdateCoffee> createState() => _UpdateCoffeeState();
}

class _UpdateCoffeeState extends State<UpdateCoffee> {

  File? _image;
  TextEditingController manunameCtrl = TextEditingController(text: '');
  TextEditingController email_idCtrl = TextEditingController(text: '');
  TextEditingController priceCtrl = TextEditingController(text: '');
  TextEditingController typecon = TextEditingController(text: '');

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

  showConfirmUpdateDialog() async {
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
                'ต้องการแก้ไขเมนูหรือไม่ ?',
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
                          updateManu();
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

  ShowResultUpdateDialog(String msg) async {
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

  updateManu() async{
    email_idCtrl.text = FirebaseAuth.instance.currentUser!.email!;
    if(_image != null){
      String imageName = Path.basename(_image!.path);

      //อัปโหลดรุปไปที่ storage ที่ firebase
      Reference ref =  FirebaseStorage.instance.ref().child('Picture_product_tb/' + imageName);
      UploadTask uploadTask = ref.putFile(_image!);
      //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
      uploadTask.whenComplete(() async{
        String imgeUrl = await ref.getDownloadURL();

        bool resultInsertFriend = await apiUpdateManu(
            widget.id,
            email_idCtrl.text.trim(),
            manunameCtrl.text.trim(),
            priceCtrl.text.trim(),
            dd_sale_seleted.toString(),
            imgeUrl,
        );
        if(resultInsertFriend == true)
        {
          ShowResultUpdateDialog("บันทึกเการแก้ไขเรียบร้อยเเล้ว");
        }
        else
        {
          ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
        }
      });
    }else{
      bool resultInsertManu = await apiUpdateManu(
          widget.id,
          email_idCtrl.text.trim(),
          manunameCtrl.text.trim(),
          priceCtrl.text.trim(),
          dd_sale_seleted.toString(),
          widget.image
      );
      if(resultInsertManu == true)
      {
        ShowResultUpdateDialog("บันทึกการแก้ไขเมนูเรียบร้อยเเล้ว");
      }
      else
      {
        ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }
    }
  }

  showConfirmDeleteDialog() async {
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
                'ต้องการลบเมนูหรือไม่ ?',
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
                          deleteManu();
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

  ShowResultDeleteDialog(String msg) async {
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

  deleteManu() async{
    bool result = await apiDeleteManu(widget.id);

    //ลบไฟล์ออกจาก Storage
    FirebaseStorage.instance.refFromURL(widget.image).delete();

    //นำผลที่ได้จากการทำงานมาตรวจสอบเเล้วแสดง
    if(result == true){
      ShowResultDeleteDialog('ลบเมนูเรียบร้อยเเล้ว');
    }else{
      ShowResultDeleteDialog('มีปัญหาในการลบข้อมูลกรุณารองใหม่อีกครั้ง');
    }
  }

  late List dd_sale_list;
  List<DropdownMenuItem<String>> dd_sale_item = [];
  String? dd_sale_seleted;
  int i = 0;

  void initState(){
    manunameCtrl.text = widget.manuname!;
    priceCtrl.text = widget.price!;
    typecon.text = widget.type!;

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
            style: const TextStyle(
                color: Color(0xff955000),
                fontWeight: FontWeight.bold,
                fontSize: 20
            ), //style
          ), //Text
          value: i.toString(),
        ), //DropdownMenuItem
      );
    }
    dd_sale_seleted = typecon.text;

    super.initState();
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
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/images/Coffee_icon.png',
                                image: widget.image,
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
                        hintText: 'ลาเต้',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'ชื่อเมนู',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
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
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
                    child: Container(
                      width: wi,
                      height: 50,
                      child: Expanded(
                        child: RaisedButton(
                          onPressed: (){
                            if(manunameCtrl.text.trim().length == 0)
                            {
                              showWarningDialog('กรุณาใส่ชื่อเมนูด้วย!!!');
                            }
                            else if(priceCtrl.text.trim().length == 0)
                            {
                              showWarningDialog('กรุณาใส่ราคาเมนูด้วย!!!');
                            }
                            else
                            {
                              showConfirmUpdateDialog();
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text(
                            'แก้ไข',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          color: const Color(0xff955000),
                        ),
                      ),
                    ),
                  ),//bottom แก้ไข
                  Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 50),
                    child: Container(
                      width: wi,
                      height: 50,
                      child: Expanded(
                        child: RaisedButton(
                          onPressed: (){
                            showConfirmDeleteDialog();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text(
                            'ลบ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          color: const Color(0x99955000),
                        ),
                      ),
                    ),
                  ),//bottom ลบ
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
