import 'dart:io';

import 'package:app_map_coffee_shop/models/map_coffee_shop.dart';
import 'package:app_map_coffee_shop/screens/map_regis_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_map_coffee_shop/models/ShapesPainter.dart';
import 'package:app_map_coffee_shop/servers/api_map_coffee_shop.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class RegisterShopUI extends StatefulWidget {
  const RegisterShopUI({Key? key}) : super(key: key);

  @override
  State<RegisterShopUI> createState() => _RegisterShopUIState();
}

class _RegisterShopUIState extends State<RegisterShopUI> {

  File? _image;
  bool pwValue = false;
  TimeOfDay? time_open;
  TimeOfDay? time_close;

  MapCoffeeShop mapCoffeeShop = MapCoffeeShop();

  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');
  TextEditingController emailCtrl = TextEditingController(text: '');
  TextEditingController shopnameCtrl = TextEditingController(text: '');
  TextEditingController descriptitonCtrl = TextEditingController(text: '');
  TextEditingController contactCtrl = TextEditingController(text: '');
  TextEditingController timeopenCtrl = TextEditingController(text: '');
  TextEditingController timecloseCtrl = TextEditingController(text: '');
  TextEditingController addressCtrl = TextEditingController(text: '');
  TextEditingController provinceCtrl = TextEditingController(text: '');

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

  String getTextTimeOpen() {
    if (time_open == null) {
      return 'เวลาเปิด';
    } else {
      final hours = time_open?.hour.toString().padLeft(2, '0');
      final minutes = time_open?.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  String getTextTimeclose() {
    if (time_close == null) {
      return 'เวลาปิด';
    } else {
      final hours = time_close?.hour.toString().padLeft(2, '0');
      final minutes = time_close?.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  Inputlocation(){
    if(addressCtrl.text.trim().length == 0){
      return '7 ซ.เพชร 79 แยก 2 หนองแขม หนองค้างพลู';
    } else {

    }
  }

  Future pickTimeOpen(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time_open ?? initialTime,
    );

    if (newTime == null) return;

    setState(() => time_open = newTime);
  }

  Future pickTimeClose(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time_close ?? initialTime,
    );

    if (newTime == null) return;

    setState(() => time_close = newTime);
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
                'ต้องการสร้างบัญชีผู้ใช้หรือไม่ ?',
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
                          Navigator.of(context).popUntil((route) => route.isFirst);
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

  insertRegisterMapCoffeeShop() async{
    //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
    //ชื่อรูป
    String imageName = Path.basename(_image!.path);

    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_location_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = await ref.getDownloadURL();

      try {
        mapCoffeeShop.email = emailCtrl.text.trim();
        mapCoffeeShop.password = passwordCtrl.text.trim();

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: mapCoffeeShop.email!,
            password: mapCoffeeShop.password!
        ).then((value) async{
          //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api
          bool resultInsertLocation = await apiInsertLocationShop(
              usernameCtrl.text.trim(),
              passwordCtrl.text.trim(),
              emailCtrl.text.trim(),
              imageUrl,
              shopnameCtrl.text.trim(),
              descriptitonCtrl.text.trim(),
              contactCtrl.text.trim(),
              addressCtrl.text.trim(),
              provinceCtrl.text.trim(),
              timeopenCtrl.text.trim(),
              timecloseCtrl.text.trim()
          );

          if(resultInsertLocation == true)
          {
            ShowResultInsertDialog("บันทึกเรียนร้อยเเล้ว");
          }
          else
          {
            ShowResultInsertDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
          }
        });


      }
      on FirebaseAuthException catch(e){
        String message;
        if(e.code == 'emile-already-in-use'){
          message = 'อีเมลนี้ถูกใช้ไปเเล้วโปรดใช้อีเมลอื่นแทน';
        }
        else{
          message = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษรเป็นต้นไป';
        }
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.CENTER
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    String lat = '';
    String lng = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สมัครสาชิก',
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
                                'assets/images/Shop-icon.png',
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
                  ),//กล้อง
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      scrollPadding: const EdgeInsets.all(10),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: usernameCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
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
                        hintText: 'jussoca',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'ชื่อผู้ใช้',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),//user
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      obscureText: !pwValue,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: passwordCtrl,
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
                        hintText: 'jussoca123456789',
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
                    ),
                  ),//password
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
                    ),
                  ),//email
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: shopnameCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.water_damage_outlined,
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
                        hintText: 'Homu cafe',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'ชื่อร้านกาแฟ',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),//ชื่อร้านกาแฟ
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: descriptitonCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.deck_sharp,
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
                        hintText: 'สไตล์ธรรมชาติ',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'สไตล์ร้าน',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),//Description
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: contactCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_android,
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
                        hintText: '020300568',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'เบอร์โทรร้าน',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),//Contact
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 5.0,
                            ),
                            child: TextField(
                              controller: timeopenCtrl,
                              decoration: InputDecoration(
                                hintText: getTextTimeOpen(),
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.more_time),
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
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 35),
                          child: ElevatedButton(
                            onPressed: (){
                              pickTimeOpen(context);
                              timeopenCtrl.text = '';
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff955000),
                            ),
                            child: const Text(
                              "+",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),//Opening Time
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 5.0,
                            ),
                            child: TextField(
                              controller: timecloseCtrl,
                              decoration: InputDecoration(
                                hintText: getTextTimeclose(),
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.more_time),
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
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 35),
                          child: ElevatedButton(
                            onPressed: (){
                              pickTimeClose(context);
                              timecloseCtrl.text = '';
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff955000),
                            ),
                            child: const Text(
                              "+",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),//closing time
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: addressCtrl,
                      decoration:InputDecoration(
                        prefixIcon: Icon(
                          Icons.apartment,
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
                        hintText: Inputlocation(),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'ใส่ที่อยู่ร้านหรือกดที่ไอคอน   -->',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                        suffixIcon: IconButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapRegisUI()
                                  )
                              ).then((value){
                                addressCtrl.text = value[0] + ',' + value[1];
                                lat = value[0];
                                lng = value[1];
                              });
                            },
                            icon: Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.red,
                              size: 30,
                            ))
                      ),
                    ),
                  ),//address
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      controller: provinceCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_balance,
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
                        hintText: '10160',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'รหัสไปรษณี',
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),//Province_ID
                  Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 50),
                    child: ElevatedButton(
                      onPressed: (){
                        if(usernameCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใส่รหัสผู้ใช้ด้วย!!!');
                        }
                        else if(passwordCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใสรหัสผ่านด้วย!!!');
                        }
                        else if(emailCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใสอีเมล์ด้วย!!!');
                        }
                        else if(shopnameCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใส่ชื่อร้านด้วย!!!');
                        }
                        else if(descriptitonCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใส่สไตย์ร้านด้วย!!!');
                        }
                        else if(contactCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใส่เบอร์โทรด้วย!!!');
                        }
                        else if(time_open == null){
                          showWarningDialog('กรุณาใส่เวลาเปิดร้านด้วย!!!');
                        }
                        else if(time_close == null){
                          showWarningDialog('กรุณาใส่เวลาปิดร้านด้วย!!!');
                        }
                        else if(addressCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใสที่อยู่ร้านด้วย!!!');
                        }
                        else if(provinceCtrl.text.trim().length == 0){
                          showWarningDialog('กรุณาใส่รหัสไปรษณีด้วย!!!');
                        }
                        else if(_image == null){
                          showWarningDialog('กรุณาใส่รูปร้านด้วย!!!');
                        }
                        else{
                          try{
                            timeopenCtrl.text = getTextTimeOpen();
                            timecloseCtrl.text = getTextTimeclose();
                            showConfirmInsertDialog();
                          }catch(e){
                            showWarningDialog('เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        fixedSize: Size(wi, 50.0),
                        primary: const Color(0xff955000),
                      ),
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),//bottom
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}