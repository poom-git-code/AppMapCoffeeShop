import 'dart:async';

import 'package:app_map_coffee_shop/screens/register_shop_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/application_bloc.dart';
import 'location_controller.dart';

class MapRegisUI extends StatefulWidget {

  @override
  State<MapRegisUI> createState() => _MapRegisUIState();
}

class _MapRegisUIState extends State<MapRegisUI> {

  List x = [];
  int bnbIndex = 0;
  late CameraPosition _cameraPosition;
  late GoogleMapController _mapController;

  //สร้างตัวควบคุม Google Map
  Completer<GoogleMapController> gooController = Completer();
  //สร้างตัวควบคุม Marker
  Set<Marker> gooMarker = {};
  //สร้างตัวควบคุม Circle
  Set<Circle> gooCircle = {};

  //Method สร้าง Marker
  // createMarker(double lat, double lng, String title, String snippet) {
  //   MarkerId markerId = MarkerId (lat.toString() + lng.toString());
  //   setState(() {
  //     gooMarker.add(
  //       Marker(
  //         markerId: markerId,
  //         position: LatLng(lat, lng),
  //         infoWindow: InfoWindow(
  //           title: title,
  //           snippet: snippet,
  //         ),
  //         onTap: () => _openOnGoogleMapApp(lat, lng),
  //       ),
  //
  //     );
  //   });
  // }

  //Method Circle
  // createCircle(double lat, double lng) {
  //   CircleId circleId = CircleId(lat.toString() + lng.toString());
  //   setState(() {
  //     gooCircle.add(
  //       Circle(
  //         circleId: circleId,
  //         center: LatLng(lat, lng),
  //         radius: 200.0,
  //         fillColor: Color(0x33FF0000),
  //         strokeColor: Colors.transparent,
  //         strokeWidth: 1,
  //       ),
  //     );
  //   });
  // }

  LocationData? currentLocation;

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await gooController.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!
          ),
          zoom: 16,
        ),
      )
    );

    MarkerId markerId = MarkerId (currentLocation!.latitude!.toString() + currentLocation!.longitude!.toString());
    setState(() {
      gooMarker.add(
        Marker(
          markerId: markerId,
          position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          infoWindow: const InfoWindow(
            title: 'ตำแหน่ง',
            snippet: 'คุณอยู่ตรงนี้',
          ),
          onTap: () => _openOnGoogleMapApp(currentLocation!.latitude!, currentLocation!.longitude!),
        ),

      );
    });

    CircleId circleId = CircleId(currentLocation!.latitude!.toString() + currentLocation!.longitude!.toString());
    setState(() {
      gooCircle.add(
        Circle(
          circleId: circleId,
          center: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          radius: 200.0,
          fillColor: const Color(0x33FF0000),
          strokeColor: Colors.transparent,
          strokeWidth: 1,
        ),
      );
    });


  }

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
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
                  x = [location.latitude.toDouble(), location.longitude.toDouble()];

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
}

// Positioned(
//   top: 8,
//   left: 20,
//   right: 60,
//   child: GestureDetector(
//     onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
//     child: Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(10)
//       ),
//       child: Row(
//           children: [
//             Icon(
//                 Icons.location_on,
//                 size: 25,
//                 color: Theme.of(context).primaryColor
//             ),
//             const SizedBox(width: 5),
//             //here we show the address on the top
//             Expanded(
//               child: Text(
//                 '${locationController.pickPlaceMark.name ??
//                     ''} ${locationController.pickPlaceMark.locality ??
//                     ''} '
//                     '${locationController.pickPlaceMark.postalCode ??
//                     ''} ${locationController.pickPlaceMark.country ??
//                     ''}',
//                 style: const TextStyle(fontSize: 20),
//                 maxLines: 1, overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Icon(
//                 Icons.search,
//                 size: 25,
//                 color: Theme.of(context).textTheme.bodyText1!.color
//             ),
//       ]),
//     ),
//   ),
// ),