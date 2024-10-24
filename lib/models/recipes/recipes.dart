class Recipes {
  String name;
  String description;
  String imgPath;
  String rating;
  static const String defaultImagePath = 'assets/images/ingredient/default.png';
  Recipes(
      {required this.name,
      required this.description,
      required this.imgPath,
      required this.rating});

  String getImagePath() {
    return imgPath.isNotEmpty ? imgPath : defaultImagePath;
  }
}
