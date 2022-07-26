import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_map_coffee_shop/models/ShapesPainter.dart';
import 'package:path/path.dart' as Path;
import 'package:transparent_image/transparent_image.dart';
import '../models/data_holder.dart';
import '../servers/api_map_coffee_shop.dart';
import 'add_image.dart';

class SelectShopPicUI extends StatefulWidget {

  @override
  State<SelectShopPicUI> createState() => _SelectShopPicUIState();
}

class _SelectShopPicUIState extends State<SelectShopPicUI> {

  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];
  int index = 0;

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
      _path.add(await InsetsImageCoffeeShop(_image));
    }
    return _path;
  }

  InsetsImageCoffeeShop(XFile image) async{

    //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
    //ชื่อรูป
    String imageName = Path.basename(image.path);

    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_multipicture_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = (await ref.getDownloadURL());

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

  // Widget makeImagesGrid(){
  //   return GridView.builder(
  //     itemCount: 30,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //     itemBuilder: (context, index){
  //       return GridTile(
  //         child: ImageGridItem(index+1),
  //         header: Padding(
  //           padding: EdgeInsets.only(left: 170),
  //           child: IconButton(
  //             onPressed: (){},
  //             icon: const Icon(
  //               FontAwesomeIcons.trash,
  //               color: Colors.red,
  //               size: 15,
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("mcs_imagesShop")
        .where('Email', isEqualTo: email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รูปภาพ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color(0xff955000)
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFFA238),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AddImage()
              )
          );
        },
        backgroundColor: Color(0xff955000),
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
          // SafeArea(
          //   child: Column(
          //     children: [
          //       OutlinedButton(
          //         onPressed: (){
          //           multiImageUploader(_imageList);
          //         },
          //         child: Text('บักทึกรูปภาพ'),
          //       ),
          //       Expanded(
          //         child: GridView.builder(
          //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 2
          //           ),
          //           itemCount: _imageList.length,
          //           itemBuilder: (BuildContext context, int index){
          //             return Padding(
          //               padding: const EdgeInsets.all(2.0),
          //               child: Stack(
          //                 fit: StackFit.expand,
          //                 children: [
          //                   Image.file(
          //                     File(_imageList[index].path),
          //                     fit: BoxFit.cover,
          //                   ),
          //                   Positioned(
          //                     child: Container(
          //                       child: RawMaterialButton(
          //                         onPressed: (){},
          //                         child: Text(''),
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: makeImagesGrid(),
          // ),
          StreamBuilder(
            stream: _userStrem,
            builder: (context, snapshot){
              return !snapshot.hasData
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : Container(
                padding: EdgeInsets.all(4),
                child: GridView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.all(3),
                      child: FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: (snapshot.data! as QuerySnapshot).docs[index].get('url'),
                      ),
                    );
                  },
                ),
              );
            },
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


// class ImageGridItem extends StatefulWidget {
//
//   int? _index;
//
//   ImageGridItem(int index){
//     this._index = index;
//
//   }
//
//   @override
//   State<ImageGridItem> createState() => _ImageGridItemState();
// }
//
// class _ImageGridItemState extends State<ImageGridItem> {
//
//   Uint8List? imageFile;
//   Reference photosReference = FirebaseStorage.instance.ref().child('Picture_multipicture_tb');
//
//   getImage(){
//     if(!requiredIndexes.contains(widget._index)){
//       int MAX_SIZE = 7 * 1024 * 1024;
//       //.child("image_${widget._index}.jpg")
//       photosReference.child("image_${widget._index}.jpg").getData(MAX_SIZE).then((data){
//         setState((){
//           imageFile = data!;
//         });
//         imageDate.putIfAbsent(widget._index!, (){
//           return data!;
//         });
//       }).catchError((Error){
//         debugPrint(Error.toString());
//       });
//       requiredIndexes.add(widget._index!);
//     }
//   }
//
//   Widget decideGridTileWidget(){
//     if(imageFile == null){
//       return Center(
//         child: Stack(
//           children: const [
//             Text('ไม่มีรูปภาพ'),
//           ],
//         ),
//       );
//     }
//     else{
//       return Image.memory(imageFile!, fit: BoxFit.cover,);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(!imageDate.containsKey(widget._index)){
//       getImage();
//     }else{
//       setState(() {
//         imageFile = imageDate[widget._index];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GridTile(
//       child: decideGridTileWidget(),
//     );
//   }
// }
