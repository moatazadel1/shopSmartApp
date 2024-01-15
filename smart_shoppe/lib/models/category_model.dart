import '../constants/assets_manager.dart';

class CategoryModel {
  final String img, name, id;

  CategoryModel({required this.img, required this.name, required this.id});

  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: AssetsManager.mobiles,
      img: AssetsManager.mobiles,
      name: "Phones",
    ),
    CategoryModel(
      id: AssetsManager.pc,
      img: AssetsManager.pc,
      name: "Laptops",
    ),
    CategoryModel(
      id: AssetsManager.electronics,
      img: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoryModel(
      id: AssetsManager.watch,
      img: AssetsManager.watch,
      name: "Watches",
    ),
    CategoryModel(
      id: AssetsManager.fashion,
      img: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoryModel(
      id: AssetsManager.shoes,
      img: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoryModel(
      id: AssetsManager.book,
      img: AssetsManager.book,
      name: "Books",
    ),
    CategoryModel(
      id: AssetsManager.cosmetics,
      img: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];
}
