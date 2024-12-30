import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ingredient_chart.dart';
import '../../view_models/review_viewmodel.dart';

class ReviewScreen extends StatelessWidget {
  final int month;
  final int year;

  const ReviewScreen({
    Key? key,
    this.month = 12,
    this.year = 2024,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch data when the screen is built

    return ChangeNotifierProvider(
      create: (_) => ReviewProvider(),
      child: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Review'),
            ),
            body: Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                if (reviewProvider.ingredientMap['basket'].isEmpty &&
                    reviewProvider.pendingIngredientMap['basket'].isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        IngredientList(
                          ingredientMap:
                              reviewProvider.pendingIngredientMap['basket'],
                          title:
                              'Trong giỏ hàng của bạn tháng ${month.toString()}',
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
