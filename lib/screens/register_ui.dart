import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ShapesPainter.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {

  File? _image;
  bool pwValue = false;

  TextEditingController timeCtrl = TextEditingController(text: '');

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

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Color(0xff955000)
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFFA238),
      ),
      body: SingleChildScrollView(
        child: Stack(
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
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Color(0xffFFB35C),
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
                                      'assets/images/User-group-icon.png',
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
                const Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
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
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: 'Input Username',
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
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: 'Input Password',
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
                const Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.accessibility,
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
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: 'Input Name',
                      labelStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),//name
                const Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                      hintText: 'E-mail',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: 'Input E-mail',
                      labelStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),//email
                const Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                      hintText: 'Address',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: 'Input Address',
                      labelStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),//address
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
                  child: Container(
                    width: wi,
                    height: 50,
                    child: Expanded(
                      child: RaisedButton(
                        onPressed: (){},
                        child: const Text(
                          'Next',
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
                ),//bottom
              ],
            ),
          ],
        ),
      ),
    );
  }
}
