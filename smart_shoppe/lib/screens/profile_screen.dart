import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/assets_manager.dart';
import 'package:smart_shoppe/models/user_model.dart';
import 'package:smart_shoppe/providers/user_provider.dart';
import 'package:smart_shoppe/screens/auth/login_screen.dart';
import 'package:smart_shoppe/screens/inner_screens/orders_screen.dart';
import 'package:smart_shoppe/screens/inner_screens/viewed_recently.dart';
import 'package:smart_shoppe/screens/inner_screens/wishlist_screen.dart';
import 'package:smart_shoppe/widgets/custom_list_tile_widget.dart';
import 'package:smart_shoppe/widgets/loading_widget.dart';
import 'package:smart_shoppe/widgets/text/subtitle_text_widget.dart';
import 'package:smart_shoppe/widgets/text/text_effect_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../constants/app_methods.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      if (!mounted) return;
      await AppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "$error",
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TextEffectWidget(label: 'SmartShoppe'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
      ),
      body: LoadingWidget(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TitleTextWidget(
                    label: "Please login to have ultimate access",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: userModel == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 3),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userModel!.userImage,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TitleTextWidget(label: userModel!.userName),
                                SubtitleTextWidget(label: userModel!.userEmail),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TitleTextWidget(label: 'General'),
              ),
              user == null
                  ? const SizedBox.shrink()
                  : CustomListTileWidget(
                      imagePath: AssetsManager.orderSvg,
                      text: "All orders",
                      function: () {
                        Navigator.pushNamed(context, OrdersScreen.routeName);
                      },
                    ),
              user == null
                  ? const SizedBox.shrink()
                  : CustomListTileWidget(
                      imagePath: AssetsManager.wishlistSvg,
                      text: "Wishlist",
                      function: () async {
                        await Navigator.pushNamed(
                            context, WishlistScreen.routName);
                      },
                    ),
              user == null
                  ? const SizedBox.shrink()
                  : CustomListTileWidget(
                      imagePath: AssetsManager.recent,
                      text: "Viewed recently",
                      function: () async {
                        await Navigator.pushNamed(
                            context, ViewedRecentlyScreen.routName);
                      },
                    ),
              CustomListTileWidget(
                imagePath: AssetsManager.address,
                text: "Address",
                function: () {},
              ),
              const Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TitleTextWidget(label: 'Settings'),
              ),
              SwitchListTile(
                secondary: Image.asset(
                  height: 30,
                  AssetsManager.theme,
                ),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) {
                  themeProvider.setDarkTheme(themeValue: value);
                },
                title: Text(
                    themeProvider.getIsDarkTheme ? "Dark mode" : "Light mode"),
              ),
              const Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TitleTextWidget(label: 'Others'),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomListTileWidget(
                    imagePath: AssetsManager.privacy,
                    text: 'Privacy & Policy',
                    function: () {}),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    user == null
                        ? Navigator.pushNamed(context, LoginScreen.routName)
                        : await AppMethods.showErrorORWarningDialog(
                            context: context,
                            subtitle: 'Confirm Logout?',
                            fct: () async {
                              await FirebaseAuth.instance.signOut();
                              if (!mounted) return;
                              await Navigator.pushReplacementNamed(
                                  context, LoginScreen.routName);
                            },
                            isError: false,
                          );
                    // if (!mounted) return;
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                  label: Text(user == null ? 'Login' : 'Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
