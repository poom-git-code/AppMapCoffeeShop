import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_map_coffee_shop/models/ShapesPainter.dart';
import 'package:path/path.dart' as Path;
import '../servers/api_map_coffee_shop.dart';

class SelectShopPicUI extends StatefulWidget {
  SelectShopPicUI({Key? key}) : super(key: key);

  @override
  State<SelectShopPicUI> createState() => _SelectShopPicUIState();
}

class _SelectShopPicUIState extends State<SelectShopPicUI> {

  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];

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
    final XFile? selecterImage = await _picker.pickImage(source: ImageSource.camera);
    if(selecterImage!.path.isNotEmpty)
    {
      _imageList.add(selecterImage);
    }
    setState(() {});
  }

  showSelectImageFormGallery() async {
    final XFile? selecterImage = await _picker.pickImage(source: ImageSource.gallery);
    if(selecterImage!.path.isNotEmpty)
    {
      _imageList.add(selecterImage);
    }
    setState(() {});

  }

  Future<List<String>> multiImageUploader(List<XFile> list) async{
    List<String> _path = [];
    for(XFile _image in list){
      _path.add(await UploadImageCoffeeShop(_image));
    }
    return _path;
  }

  UploadImageCoffeeShop(XFile image) async{

    //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
    //ชื่อรูป
    String imageName = Path.basename(_image!.path);

    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_multipicture_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = await ref.getDownloadURL();

      //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api
      bool resultInsertLocation = await apiInsertImageShop(
          imageUrl
      );
      if(resultInsertLocation == true)
      {
        ShowResultInsertDialog("บันทึกเรูปภาพเรียบร้อยเเล้ว");
      }
      else
      {
        ShowResultInsertDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }
    });

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


  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pictures',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color(0xff955000)
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFFA238),
        actions: [
          IconButton(
            onPressed: (){
              showBottomSheetForSelectImage(context);
            },
            icon: Icon(
              FontAwesomeIcons.images,
              color: Color(0xff955000),
            ),
          ),
          SizedBox(width: 10,),
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
          SafeArea(
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: (){
                    multiImageUploader(_imageList);
                  },
                  child: Text('บักทึกรูปภาพ'),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3
                    ),
                    itemCount: _imageList.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(_imageList[index].path),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              child: Container(
                                child: RawMaterialButton(
                                  onPressed: (){},
                                  child: Text(''),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );

  }
  // void imageselect() async{
  //   final XFile? selecterImage = await _picker.pickImage(source: ImageSource.camera);
  //   if(selecterImage!.path.isNotEmpty)
  //   {
  //     _imageList.add(selecterImage);
  //   }
  //
  //   setState(() {});
  // }
}
