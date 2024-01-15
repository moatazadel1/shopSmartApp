import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/app_constants.dart';
import 'package:smart_shoppe/models/category_model.dart';
import 'package:smart_shoppe/widgets/category_widget.dart';
import 'package:smart_shoppe/widgets/latest_arrival_product_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';

import '../constants/assets_manager.dart';
import '../providers/product_provider.dart';
import '../widgets/text/text_effect_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.22,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: const SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.white, activeColor: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                child: productProvider.getProductList.isEmpty
                    ? const SizedBox.shrink()
                    : const TitleTextWidget(label: 'Latest Arrival'),
              ),
              Visibility(
                child: productProvider.getProductList.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: size.height * 0.2,
                        child: ListView.builder(
                            itemCount: productProvider.getProductList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                  value: productProvider.getProductList[index],
                                  child: LatestArrivalProductWidget(
                                    productId: productProvider
                                        .getProductList[index].productId,
                                  ));
                            }),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              const TitleTextWidget(label: 'Categories'),
              const SizedBox(
                height: 20,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children:
                    List.generate(CategoryModel.categoriesList.length, (index) {
                  return CategortWidget(
                    categoryImg: CategoryModel.categoriesList[index].img,
                    categoryName: CategoryModel.categoriesList[index].name,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
