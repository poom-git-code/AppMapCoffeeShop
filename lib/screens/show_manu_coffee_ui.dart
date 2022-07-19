import 'package:app_map_coffee_shop/screens/update_coffee.dart';
import 'package:app_map_coffee_shop/screens/update_other.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/ShapesPainter.dart';
import '../servers/api_map_coffee_shop.dart';

class ShowManuCoffeeUI extends StatefulWidget {
  const ShowManuCoffeeUI({Key? key}) : super(key: key);

  @override
  State<ShowManuCoffeeUI> createState() => _ShowManuCoffeeUIState();
}

class _ShowManuCoffeeUIState extends State<ShowManuCoffeeUI> {

  late Stream<QuerySnapshot> allManu;

  getAllManu() {
    allManu = apiGetAllManuCoffeeShop()!;
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllManu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return Scaffold(
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
          StreamBuilder(
                stream: allManu,
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
                        color: Color(0xff955000),
                      );
                    },
                    itemBuilder: (context, index){
                      return ListTile(
                        onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateCoffee(
                                      (snapshot.data! as QuerySnapshot).docs[index].id.toString(),
                                      (snapshot.data! as QuerySnapshot).docs[index]['manuname'],
                                      (snapshot.data! as QuerySnapshot).docs[index]['price'],
                                      (snapshot.data! as QuerySnapshot).docs[index]['type'],
                                      (snapshot.data! as QuerySnapshot).docs[index]['image'],
                                    )
                                )
                            ).then((value) => getAllManu());
                          },
                        leading: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/Coffee_icon.png',
                              image: (snapshot.data! as QuerySnapshot).docs[index]['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          (snapshot.data! as QuerySnapshot).docs[index]['manuname'],
                        ),
                        subtitle: Text(
                          'ราคา ' + (snapshot.data! as QuerySnapshot).docs[index]['price'],
                        ),

                        trailing:IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff955000),
                          ),
                          onPressed: (){
                            if((snapshot.data! as QuerySnapshot).docs[index]['type'] != null){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateCoffee(
                                        (snapshot.data! as QuerySnapshot).docs[index].id.toString(),
                                        (snapshot.data! as QuerySnapshot).docs[index]['manuname'],
                                        (snapshot.data! as QuerySnapshot).docs[index]['price'],
                                        (snapshot.data! as QuerySnapshot).docs[index]['type'],
                                        (snapshot.data! as QuerySnapshot).docs[index]['image'],
                                      )
                                  )
                              ).then((value) => getAllManu());
                            }
                            else
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateOther(
                                        (snapshot.data! as QuerySnapshot).docs[index].id.toString(),
                                        (snapshot.data! as QuerySnapshot).docs[index]['manuname'],
                                        (snapshot.data! as QuerySnapshot).docs[index]['price'],
                                        (snapshot.data! as QuerySnapshot).docs[index]['image'],
                                      )
                                  )
                              ).then((value) => getAllManu());
                            }
                          },
                        ),
                      );
                    },
                    itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  );
                },
              ),
        ],
      ),
    );
  }
}
