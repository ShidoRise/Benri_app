import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final Map<String, dynamic> ingredientMap;
  final String title;

  const IngredientList(
      {Key? key, required this.ingredientMap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ingredientMap.length,
          itemBuilder: (context, index) {
            final ingredient = ingredientMap.values.elementAt(index);
            return Card(
              elevation: 0, // Loại bỏ hiệu ứng nổi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Góc vuông vức
                side: BorderSide(color: Colors.grey.shade300), // Đường viền
              ),
              child: ListTile(
                title: Text(ingredient['name']),
                subtitle: Text(
                    'Quantity: ${ingredient['quantity']} ${ingredient['unit']}'),
                trailing: Text(ingredient['category']),
              ),
            );
          },
        ),
      ],
    );
  }
}
