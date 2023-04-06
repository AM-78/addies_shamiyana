import 'dart:io';

import 'package:addies_shamiyana/firebase_options.dart';
import 'package:addies_shamiyana/src/features/authentication/screens/loading/loading.dart';
import 'package:addies_shamiyana/src/features/menu/screens/cart/cart.dart';
import 'package:addies_shamiyana/src/features/provider/cart_provider.dart';
import 'package:addies_shamiyana/src/repository/authentication_repository/authentication_repository.dart';
import 'package:addies_shamiyana/src/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthenticationRepository()));
  // if(Platform.isAndroid){
  //   SharedPreferences.
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: GetMaterialApp(
          debugShowCheckedModeBanner:false,
          theme: AppTheme.lightTheme,
          home: Loading(),
        ),
    );
  }
}
