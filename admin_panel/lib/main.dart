import 'dart:io';

import 'package:admin_panel/providers/product_provider.dart';
import 'package:admin_panel/providers/theme_provider.dart';
import 'package:admin_panel/screens/dashboard_screen.dart';
import 'package:admin_panel/screens/edit_upload_product_screen.dart';
import 'package:admin_panel/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'screens/inner_screens/orders_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCeYETFwZolw4-pycyFFQFT8Cqp_dhCWHQ',
            appId: '1:658847833241:android:e0779a49f287acabd62c08',
            messagingSenderId: '658847833241',
            projectId: 'smart-shoppe-f5bed',
            storageBucket: 'smart-shoppe-f5bed.appspot.com',
          ),
        )
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      "An error has been occured ${snapshot.error}"),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => ThemeProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ProductProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) => MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Flutter Demo',
                        theme: (Styles.themeData(
                            isDarkTheme: themeProvider.getIsDarkTheme,
                            context: context)),
                        home: const DashboardScreen(),
                        routes: {
                          SearchScreen.routeName: (context) =>
                              const SearchScreen(),
                          OrdersScreenFree.routeName: (context) =>
                              const OrdersScreenFree(),
                          EditOrUploadProductScreen.routeName: (context) =>
                              const EditOrUploadProductScreen(),
                        },
                      )),
            );
          }),
    );
  }
}
