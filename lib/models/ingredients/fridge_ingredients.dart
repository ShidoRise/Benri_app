
class FridgeIngredient {

  final String name;
  final String quantity;
  final String imgPath;
  final DateTime expirationDate;
  // Define the default image path here

  static const String defaultImagePath = 'assets/images/ingredient/default.png';
  FridgeIngredient({

    required this.name,
    required this.quantity,
    required this.imgPath,
    required this.expirationDate,
  });
  // Method to format the expiration date for display
  String getFormattedExpirationDate() {
    return "${expirationDate.day}-${expirationDate.month}-${expirationDate.year}";
  }

  // Method to check if the ingredient is expired
  bool isExpired() {
    return DateTime.now().isAfter(expirationDate);
  }

  // Method to get the image path, returning default if no image is available
  String getImagePath() {
    return imgPath.isNotEmpty ? imgPath : defaultImagePath;
  }
}
