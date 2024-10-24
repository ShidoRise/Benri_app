class Recipes {
  String name;
  String description;
  String imgPath;
  String rating;
  String timeCooking;
  static const String defaultImagePath = 'assets/images/ingredient/default.png';
  Recipes(
      {required this.name,
      required this.description,
      required this.imgPath,
      required this.rating,
      required this.timeCooking});

  String getImagePath() {
    return imgPath.isNotEmpty ? imgPath : defaultImagePath;
  }
}
