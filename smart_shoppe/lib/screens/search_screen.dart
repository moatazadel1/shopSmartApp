import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/providers/product_provider.dart';
import 'package:smart_shoppe/widgets/product_widget.dart';
import '../constants/assets_manager.dart';
import '../models/product_model.dart';
import '../widgets/text/title_text_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const routeName = 'SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<ProductModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    String? categoryName =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> categoryList = categoryName == null
        ? productProvider.getProductList
        : productProvider.findByCategory(categoryName: categoryName);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
          title: TitleTextWidget(label: categoryName ?? 'Store products'),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(
              AssetsManager.shoppingCart,
            ),
          ),
        ),
        body:
            // categoryList.isEmpty
            //     ? Center(
            //         child: TitleTextWidget(
            //             label: categoryName == null
            //                 ? "No products available"
            //                 : "This Category is empty"),
            //       )
            //     :
            StreamBuilder<List<ProductModel>>(
                stream: productProvider.fetchDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: TitleTextWidget(label: '${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || categoryList.isEmpty) {
                    return Center(
                      child: TitleTextWidget(
                          label: categoryName == null
                              ? 'No products available'
                              : 'This Category is empty'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              searchList = productProvider.searchQuery(
                                  passedList: categoryList,
                                  searchText: controller.text);
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              searchList = productProvider.searchQuery(
                                  passedList: categoryList,
                                  searchText: controller.text);
                            });
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            prefixIconColor: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .color,
                            suffixIconColor: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .color,
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle!
                                  .color,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.clear();
                                FocusScope.of(context).unfocus();
                              },
                              child: const Icon(
                                Icons.clear,
                              ),
                            ),
                            label: const Text("Search"),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (controller.text.isNotEmpty &&
                            searchList.isEmpty) ...[
                          const TitleTextWidget(
                              label: 'No results found ', fontSize: 40),
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            builder: (context, index) {
                              return ProductWidget(
                                  productId: controller.text.isNotEmpty
                                      ? searchList[index].productId
                                      : categoryList[index].productId);
                            },
                            itemCount: controller.text.isNotEmpty
                                ? searchList.length
                                : categoryList.length,
                            crossAxisCount: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
