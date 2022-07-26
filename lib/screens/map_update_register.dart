import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../blocs/application_bloc.dart';

class MapUpdateRegister extends StatefulWidget {

  String id;
  String? User_ID;
  String Image;
  String? Email;
  String? password;
  String? Location_Name;
  String? Description;
  String? Contact;
  String? Office_Hours_Open;
  String? Office_Hours_close;
  double Longitude;
  double Latitude;
  String? Province_ID;

  MapUpdateRegister(
      this.id,
      this.User_ID,
      this.Image,
      this.Email,
      this.password,
      this.Location_Name,
      this.Description,
      this.Contact,
      this.Office_Hours_Open,
      this.Office_Hours_close,
      this.Longitude,
      this.Latitude,
      this.Province_ID,
      );

  @override
  State<MapUpdateRegister> createState() => _MapUpdateRegisterState();
}

class _MapUpdateRegisterState extends State<MapUpdateRegister> {

  List x = [];
  int bnbIndex = 0;
  late CameraPosition _cameraPosition;
  late GoogleMapController _mapController;
  var latitude;
  var longitude;

  //สร้างตัวควบคุม Google Map
  Completer<GoogleMapController> gooController = Completer();
  //สร้างตัวควบคุม Marker
  Set<Marker> gooMarker = {};
  //สร้างตัวควบคุม Circle
  Set<Circle> gooCircle = {};

  LocationData? currentLocation;


  @override
  void initState() {
    latitude = widget.Latitude;
    longitude = widget.Longitude;

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);


    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'แผนที่',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Color(0xff955000)
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xffFFA238),
        ),
        body: (applicationBloc.currentLocation == null)
            ? const Center(child: CircularProgressIndicator(),)
            :
        Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    applicationBloc.currentLocation!.latitude,
                    applicationBloc.currentLocation!.longitude
                ),
                zoom: 15,
              ),
              mapType: MapType.normal,
              markers: gooMarker,
              circles: gooCircle,
              onMapCreated: (GoogleMapController controller) {
                //เอาตัว controller ที่สร้างมากำหนดให้กับ Google Map นี้
                gooController.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: true,
              onTap: (location) {
                x = [location.latitude.toDouble(),location.longitude.toDouble()];

                setState((){
                  gooMarker.add(
                      Marker(
                        markerId: MarkerId('place_name'),
                        position: LatLng(location.latitude, location.longitude),
                        infoWindow: const InfoWindow(
                          title: 'ตำแหน่ง',
                          snippet: 'คุณอยู่ตรงนี้',
                        ),
                      )
                  );
                });

              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop(x);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(170, 50.0),
                    primary: const Color(0xff955000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                          FontAwesomeIcons.locationArrow
                      ),
                      Text(
                        'set location',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),//bottom
          ],
        )
    );

  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       mapType: MapType.hybrid,
  //       initialCameraPosition: _kGooglePlex,
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton.extended(
  //       onPressed: _goToTheLake,
  //       label: Text('To the lake!'),
  //       icon: Icon(Icons.directions_boat),
  //     ),
  //   );
  // }
  //
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

}