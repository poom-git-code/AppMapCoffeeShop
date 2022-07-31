import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../servers/api_map_coffee_shop.dart';


class StarOneUI extends StatefulWidget {
  String? Email;

  StarOneUI(this.Email);

  @override
  State<StarOneUI> createState() => _StarOneUIState();
}

class _StarOneUIState extends State<StarOneUI> {

  late String id;

  showConfirmDeleteDialog(String id) async {
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
                          deleteManu(id);
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

  deleteManu(String id) async{
    bool result = await apiDeleteReviwe(id);

    //นำผลที่ได้จากการทำงานมาตรวจสอบเเล้วแสดง
    if(result == true){
      ShowResultDeleteDialog('ลบคอมเมนเรียบร้อยเเล้ว');
    }else{
      ShowResultDeleteDialog('มีปัญหาในการลบข้อมูลกรุณารองใหม่อีกครั้ง');
    }
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
    int _con;

    final Stream<QuerySnapshot> _manuStrem = FirebaseFirestore.instance
        .collection("mcs_comment")
        .where('EmailPath', isEqualTo: widget.Email)
        .where('StarType', isEqualTo: 1)
        .snapshots();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: _manuStrem,
        builder: (context, snapshot){
          if(snapshot.hasError)
          {
            return const Center(
              child: Text('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            // ignore: missing_return
            separatorBuilder: (context, index){
              return Container(
                height: 2,
                width: double.infinity,
                color: Colors.transparent,
              );
            },
            itemBuilder: (context, index){
              return SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )
                    ),
                    color: Color(0xffC16800),
                    child: SizedBox(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15,left: 15),
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          child: ClipOval(
                                            child: Image.network(
                                              (snapshot.data as QuerySnapshot).docs[index]['Image'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 90),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${(snapshot.data as QuerySnapshot).docs[index]['Name']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: RatingBar.builder(
                                              initialRating: (snapshot.data as QuerySnapshot).docs[index]['StarType'],
                                              minRating: 1,
                                              itemSize: 18,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                                _con = rating as int;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 310, top: 5),
                                      child: IconButton(
                                        onPressed: (){
                                          id = (snapshot.data as QuerySnapshot).docs[index].id.toString();
                                          showConfirmDeleteDialog(id);
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.solidTrashCan,
                                        ),
                                        color: Color(0xff6D3B00),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: SizedBox(
                                  width: wi,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Text(
                                      '${(snapshot.data as QuerySnapshot).docs[index]['Comment']}',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
              );
            },
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
          );
        },
      ),
    );
  }
}
