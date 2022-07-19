import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {

  XFile? singleImage;
  List<String> mutiImage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                singleImage != null && singleImage!.path.isNotEmpty
                    ?
                    Image.file(
                      File(singleImage!.path),
                      height: 200,
                    )
                    :
                    const SizedBox.shrink(),
                MaterialButton(
                  onPressed: () async{
                    singleImage = await singleImagePick();
                    if(singleImage != null && singleImage!.path.isNotEmpty)
                    {
                      setState(() {});
                      uploadImage(singleImage!);
                    }
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'ภาพเดี่ยว'
                  ),
                ),
                MaterialButton(
                  onPressed: () async{
                    List<XFile> _image = await mutiImagePick();
                    if(_image.isNotEmpty)
                    {
                      mutiImage = await multiImageUploader(_image);
                      setState(() {});
                    }
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                      'หลายภาพ'
                  ),
                ),
                Wrap(
                  children: mutiImage.map(
                          (e) => Image.network(
                            e,
                            width: 400,
                            height: 200,
                          )
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<XFile?> singleImagePick() async{
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

Future<List<XFile>> mutiImagePick() async{
  List<XFile>? _image = await ImagePicker().pickMultiImage();
  if (_image != null && _image.isNotEmpty)
  {
    return _image;
  }
  return [];
}

Future<List<String>> multiImageUploader(List<XFile> list) async{
  List<String> _path = [];
  for(XFile _image in list){
    _path.add(await uploadImage(_image));
  }
  return _path;
}

Future<String> uploadImage(XFile image) async{
  Reference db = FirebaseStorage.instance.ref("testFolder/${getImageName(image)}");
  await db.putFile(File(image.path));
  return await db.getDownloadURL();
}

String getImageName(XFile image){
  return image.path.split("/").last;
}