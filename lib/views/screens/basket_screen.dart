import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/basket_item.dart';
import 'package:benri_app/views/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart'; // Import provider for state management
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart'; // For formatting dates

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BAppBar(title: 'My Basket'),
      body: Consumer<BasketViewModel>(
        builder: (context, basketViewModel, child) {
          return Column(
            children: [
              _basketHeader(context, basketViewModel),
              _basketMiniCalendar(context, basketViewModel),
              _separatorLineWithShadow(),
              (basketViewModel.db.baskets[basketViewModel.focusDateFormatted]
                          ?.isNotEmpty ??
                      false)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: basketViewModel
                                .db
                                .baskets[basketViewModel.focusDateFormatted]
                                ?.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildBasketItem(
                              context, basketViewModel, index);
                        },
                      ),
                    )
                  : _emptyBasketMessage(),
            ],
          );
        },
      ),
      floatingActionButton: _basketFloatingButton(context),
    );
  }

  Widget _separatorLineWithShadow() {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4), // Adjust the spacing if needed
      height: 0.5, // Thickness of the line
      decoration: const BoxDecoration(
        color: BColors.grey, // Color of the line
        boxShadow: [
          BoxShadow(
            color: BColors.grey, // Shadow color
            blurRadius: 1, // Softness of the shadow
            offset:
                Offset(0, 2), // Position of the shadow (horizontal, vertical)
          ),
        ],
      ),
    );
  }

  Widget _basketHeader(BuildContext context, BasketViewModel basketViewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              width: 45,
              height: 45,
              decoration: const ShapeDecoration(
                color: BColors.grey,
                shape: OvalBorder(),
              ),
            ),
            Container(
              width: 80,
              height: 30,
              padding: const EdgeInsets.only(top: 3),
              decoration: ShapeDecoration(
                color: BColors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: const Text(
                'For You',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF717171),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            width: 40,
            height: 40,
            decoration: const ShapeDecoration(
              color: BColors.white,
              shape: OvalBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Icon(Iconsax.calendar_1),
          ),
        ),
      ],
    );
  }

  Widget _basketMiniCalendar(
      BuildContext context, BasketViewModel basketViewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
      child: EasyInfiniteDateTimeLine(
        selectionMode: const SelectionMode.autoCenter(),
        firstDate: DateTime(2024),
        focusDate: basketViewModel.focusDate,
        lastDate: DateTime(2024, 12, 31),
        onDateChange: (selectedDate) {
          basketViewModel.updateFocusDate(selectedDate);
        },
        dayProps: EasyDayProps(width: 64, height: 64),
        itemBuilder: (context, date, isSelected, onTap) {
          return _buildCalendarItem(
              context, basketViewModel, date, isSelected, onTap);
        },
      ),
    );
  }

  Widget _buildCalendarItem(
    BuildContext context,
    BasketViewModel basketViewModel,
    DateTime date,
    bool isSelected,
    VoidCallback onTap,
  ) {
    String formattedDate =
        DateFormat('yMd').format(date); // Use formatted date string

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: 164.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: BColors.grey,
              ),
              color: isSelected ? BColors.primaryFirst : null,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xff393646),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  EasyDateFormatter.shortDayName(date, "en_US").toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : BColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          if (basketViewModel.db.baskets[formattedDate]?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                isSelected ? Icons.circle : Icons.circle,
                size: 8,
                color: isSelected ? Colors.white : BColors.primaryFirst,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasketItem(
      BuildContext context, BasketViewModel basketViewModel, int index) {
    final ingredient =
        basketViewModel.db.baskets[basketViewModel.focusDateFormatted]![index];

    return BasketItem(
      ingredient: ingredient,
      isSelected: ingredient.isSelected,
      basketViewModel: basketViewModel,
      index: index,
      deleteFunction: (context) => basketViewModel.deleteBasketItem(index),
    );
  }

  Widget _emptyBasketMessage() {
    return Expanded(
      child: Center(
        child: Text(
          'No ingredients here,\nclick + to add',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
      ),
    );
  }

  Widget _basketFloatingButton(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      margin: EdgeInsets.all(5.0),
      child: FloatingActionButton(
        backgroundColor: BColors.white,
        onPressed: () async {
          final basketViewModel = context.read<BasketViewModel>();
          final ingredient = await openDialog(context);
          if (ingredient != null && ingredient.isNotEmpty) {
            basketViewModel.addIngredient(ingredient);
          }
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  Future<String?> openDialog(BuildContext context) {
    final TextEditingController ingredientInputController =
        TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: ingredientInputController,
                decoration:
                    const InputDecoration(hintText: 'Enter your ingredient'),
                onSubmitted: (_) {
                  Navigator.of(context).pop(ingredientInputController.text);
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(ingredientInputController.text);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }
}
