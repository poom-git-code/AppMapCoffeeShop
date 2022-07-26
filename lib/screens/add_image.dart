import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ShapesPainter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_store ;
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  bool uploading = false;
  double val = 0;
  List<File> _image = [];
  final ImagePicker picker = ImagePicker();
  late CollectionReference imgRef;
  late firebase_store.Reference ref;

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
    final selecterImage = await picker.pickImage(source: ImageSource.camera);

    // if(selecterImage!.path.isNotEmpty)
    // {
    //   _image.add(File(response.file!.path));
    // }

    setState((){
      _image.add(File(selecterImage!.path));
    });
    if(selecterImage!.path == null) retrieveLostData();

  }

  showSelectImageFormGallery() async {
    final selecterImage = await picker.pickImage(source: ImageSource.gallery);

    // if(selecterImage!.path.isNotEmpty)
    // {
    //   _image.add(File(response.file!.path));
    // }

    setState((){
      _image.add(File(selecterImage!.path));
    });
    if(selecterImage!.path == null) retrieveLostData();
  }

  ShowWarningDialog(String msg) async {
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
                  'แจ้งเตือน',
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
                          Navigator.of(context).pop();
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
              'เพิ่มรูปภาพ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff955000)
              ),
            ),
            backgroundColor: const Color(0xffFFA238),
            actions: [
              RawMaterialButton(
                onPressed: (){
                  if(_image.length == 0){
                    ShowWarningDialog('กรุณาเพิ่มรูปก่อนอัปโหลด !!!');
                  }else{
                    setState((){
                      uploading = true;
                    });
                    uploadFile().whenComplete(() => Navigator.of(context).pop());
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.cloudArrowUp,
                      size: 18,
                      color: Color(0xff955000),
                    ),
                    SizedBox(width: 7,),
                    Text(
                      'อัปโหลด',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff955000)
                      ),
                    ),
                    SizedBox(width: 7,),
                  ],
                ),
              ),
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
          Stack(
            children: [
              GridView.builder(
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index){
                  return index == 0
                      ?
                  Center(
                    child: Container(
                      width: wi,
                      height: hi,
                      color: Colors.white24,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => !uploading ? showBottomSheetForSelectImage(context) : null,
                      ),
                    ),
                  )
                      :
                  Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image[index - 1]),
                        fit:  BoxFit.cover
                      ),
                    ),
                  );
                },
              ),
              uploading
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        'กรุณารอสักครู่...',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    CircularProgressIndicator(
                      value: val,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff955000)),
                    )
                  ],
                ),
              )
              : Container()
            ],
          ),
        ],
      ),
        );

  }

  Future<void> retrieveLostData() async{
    final LostData response = await picker.getLostData();
    if(response.isEmpty){
      return;
    }
    if(response.file != null){
      setState((){
        _image.add(File(response.file!.path));
      });
    }else{
      print(response.file);
    }
  }

  Future uploadFile() async{
    String email = FirebaseAuth.instance.currentUser!.email!;
    int i = 1;

    for(var img in _image){
      setState((){
        val = i / _image.length;
      });
      ref = firebase_store.FirebaseStorage.instance
          .ref()
          .child('$email/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value){
          imgRef.add({
            'url': value,
            'Email': email
          });
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('mcs_imagesShop');
  }
}
