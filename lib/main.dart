import 'package:app_map_coffee_shop/blocs/application_bloc.dart';
import 'package:app_map_coffee_shop/screens/home_ui.dart';
import 'package:app_map_coffee_shop/screens/location_controller.dart';
import 'package:app_map_coffee_shop/screens/login_ui.dart';
import 'package:app_map_coffee_shop/screens/register_ui.dart';
import 'package:app_map_coffee_shop/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Get.put(LocationController());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    )
  );
}