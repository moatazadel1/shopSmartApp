import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/theme_data.dart';
import 'package:smart_shoppe/providers/cart_provider.dart';
import 'package:smart_shoppe/providers/order_provider.dart';
import 'package:smart_shoppe/providers/product_provider.dart';
import 'package:smart_shoppe/providers/theme_provider.dart';
import 'package:smart_shoppe/providers/user_provider.dart';
import 'package:smart_shoppe/providers/viewed_recently_provider.dart';
import 'package:smart_shoppe/providers/wishlist_provider.dart';
import 'package:smart_shoppe/screens/auth/forgot_password_screen.dart';
import 'package:smart_shoppe/screens/auth/login_screen.dart';
import 'package:smart_shoppe/screens/auth/register_screen.dart';
import 'package:smart_shoppe/screens/inner_screens/orders_screen.dart';
import 'package:smart_shoppe/screens/inner_screens/product_details_screen.dart';
import 'package:smart_shoppe/screens/inner_screens/viewed_recently.dart';
import 'package:smart_shoppe/screens/inner_screens/wishlist_screen.dart';
import 'package:smart_shoppe/screens/search_screen.dart';
import 'root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCeYETFwZolw4-pycyFFQFT8Cqp_dhCWHQ',
            appId: '1:658847833241:android:d437f842e0b7cc24d62c08',
            messagingSenderId: '658847833241',
            projectId: 'smart-shoppe-f5bed',
          ),
        )
      : await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const SmartShoppe());
  });
}

class SmartShoppe extends StatelessWidget {
  const SmartShoppe({super.key});

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
                  create: (context) {
                    return ThemeProvider();
                  },
                ),
                ChangeNotifierProvider(create: (context) {
                  return ProductProvider();
                }),
                ChangeNotifierProvider(create: (context) {
                  return CartProvider();
                }),
                ChangeNotifierProvider(create: (context) {
                  return WishlistProvider();
                }),
                ChangeNotifierProvider(create: (context) {
                  return ViewedRecentlyProvider();
                }),
                ChangeNotifierProvider(create: (context) {
                  return UserProvider();
                }),
                ChangeNotifierProvider(create: (context) {
                  return OrdersProvider();
                }),
              ],
              child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                return MaterialApp(
                  routes: {
                    ProductDetailsScreen.routName: (context) =>
                        const ProductDetailsScreen(),
                    WishlistScreen.routName: (context) =>
                        const WishlistScreen(),
                    ViewedRecentlyScreen.routName: (context) =>
                        const ViewedRecentlyScreen(),
                    LoginScreen.routName: (context) => const LoginScreen(),
                    RegisterScreen.routName: (context) =>
                        const RegisterScreen(),
                    OrdersScreen.routeName: (context) => const OrdersScreen(),
                    ForgotPasswordScreen.routeName: (context) =>
                        const ForgotPasswordScreen(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                    RootScreen.routName: (context) => const RootScreen(),
                  },
                  debugShowCheckedModeBanner: false,
                  title: 'Smart Shoppe',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const RootScreen(),
                );
              }),
            );
          }),
    );
  }
}
