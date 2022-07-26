import 'package:app_map_coffee_shop/models/map_coffee_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_map_coffee_shop/models/manu_coffee_shop.dart';

import '../models/image_shop.dart';

Future<bool> apiInsertLocationShop(String User_ID, String password, String Email, String Image, String Location_Name,
    String Description, String Contact, double Latitude, double Longitude, String Province_ID, String Office_Hours_Open, String Office_Hours_close) async{

  //สร้าง object เพื่อนไปเก็บที่ firestore database
  MapCoffeeShop timeline = MapCoffeeShop(
    image: Image,
    userID: User_ID,
    password: password,
    email: Email,
    locationName: Location_Name,
    description: Description,
    contact: Contact,
    officeHoursOpen: Office_Hours_Open,
    officeHoursClose: Office_Hours_close,
    latitude: Latitude,
    longitude: Longitude,
    provinceID: Province_ID
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_location").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}
Stream<QuerySnapshot>? apiGetAllLocation(){
  try{
    return FirebaseFirestore.instance.collection('mcs_location').snapshots();
  }catch(ex){
    return null;
  }
}
//-------------------------------------------------------------------------------------------------------
Future<bool> apiUpdateLocationShop(String id, String User_ID, String password, String Email, String Image, String Location_Name,
    String Description, String Contact, double Latitude, double Longitude, String Province_ID, String Office_Hours_Open, String Office_Hours_close) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  MapCoffeeShop timeline = MapCoffeeShop(
      image: Image,
      userID: User_ID,
      password: password,
      email: Email,
      locationName: Location_Name,
      description: Description,
      contact: Contact,
      officeHoursOpen: Office_Hours_Open,
      officeHoursClose: Office_Hours_close,
      latitude: Latitude,
      longitude: Longitude,
      provinceID: Province_ID
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_location").doc(id).update(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}
//-------------------------------------------------------------------------------------------------------
Future<bool> apiInsertImageShop(String Image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  ImageShop timeline = ImageShop(
      image: Image
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_imagesShop").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}
Stream<QuerySnapshot>? apiGetAllImageShop(){
  try{
    return FirebaseFirestore.instance.collection('mcs_imagesShop').snapshots();
  }catch(ex){
    return null;
  }
}
//--------------------------------------------------------------------------------------------------------
//สน้าง api เมธอดเพื่อดึงข้อมูลเพื่อนทั้งหมดที่ fristore database ไปโชที่หน้า ้ home
Stream<QuerySnapshot>? apiGetAllShowImageShop(){
  try{
    return FirebaseFirestore.instance.collection('mcs_imagesShop').snapshots();
  }catch(ex){
    return null;
  }
}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiInsertManuCoffeeShop(String email_id, String manu_name, String price, String type, String Image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  SelectManuCoffee timeline = SelectManuCoffee(
    email_id: email_id,
    image: Image,
    manuname: manu_name,
    price: price,
    type: type,
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_product").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}
Stream<QuerySnapshot>? apiGetAllManuCoffeeShop(){
  try{
    return FirebaseFirestore.instance.collection('mcs_product').snapshots();
  }catch(ex){
    return null;
  }
}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiInsertManu2CoffeeShop(String email_id, String manu_name, String price, String Image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  SelectManuCoffee timeline = SelectManuCoffee(
    email_id: email_id,
    image: Image,
    manuname: manu_name,
    price: price,
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_product2").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}
Stream<QuerySnapshot>? apiGetAllManu2CoffeeShop(){
  try{
    return FirebaseFirestore.instance.collection('mcs_product2').snapshots();
  }catch(ex){
    return null;
  }
}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiUpdateManu(String id, String email_id, String manu_name, String price, String type, String Image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database

  SelectManuCoffee manu = SelectManuCoffee(
    email_id: email_id,
    image: Image,
    manuname: manu_name,
    price: price,
    type: type,
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_product").doc(id).update(manu.toJson());
    return true;
  }catch(ex){
    return false;
  }

}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiDeleteManu(String id) async{
  try{
    await FirebaseFirestore.instance.collection('mcs_product').doc(id).delete();
    return true;
  }catch(ex){
    return false;
  }
}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiUpdateManu2(String id, String email_id, String manu_name, String price, String Image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database

  SelectManuCoffee manu = SelectManuCoffee(
    email_id: email_id,
    image: Image,
    manuname: manu_name,
    price: price,
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("mcs_product2").doc(id).update(manu.toJson());
    return true;
  }catch(ex){
    return false;
  }

}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiDeleteManu2(String id) async{
  try{
    await FirebaseFirestore.instance.collection('mcs_product2').doc(id).delete();
    return true;
  }catch(ex){
    return false;
  }
}
//--------------------------------------------------------------------------------------------------------
Future<bool> apiDeleteImage(String id) async{
  try{
    await FirebaseFirestore.instance.collection('mcs_imagesShop').doc(id).delete();
    return true;
  }catch(ex){
    return false;
  }
}
//--------------------------------------------------------------------------------------------------------
