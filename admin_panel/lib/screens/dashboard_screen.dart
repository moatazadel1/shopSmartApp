import 'package:admin_panel/widgets/text/text_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/assets_manager.dart';
import '../models/dashboard_model.dart';
import '../providers/theme_provider.dart';
import '../widgets/dashboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TextEffectWidget(label: "Dashboard Screen", fontSize: 20),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashboardsWidget(
              title: DashboardModel.dashboardBtnList(context)[index].text,
              imagePath:
                  DashboardModel.dashboardBtnList(context)[index].imagePath,
              onPressed: () {
                DashboardModel.dashboardBtnList(context)[index].onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}
