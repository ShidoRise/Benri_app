import 'package:benri_app/services/basket_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:benri_app/views/widgets/basket_item.dart';
import 'package:benri_app/views/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';

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
              _basketContent(basketViewModel),
            ],
          );
        },
      ),
      floatingActionButton: _basketFloatingButton(context),
    );
  }

  Widget _separatorLineWithShadow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 0.5,
      decoration: const BoxDecoration(
        color: BColors.grey,
        boxShadow: [
          BoxShadow(
            color: BColors.grey,
            blurRadius: 1,
            offset: Offset(0, 2),
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
            _profileIcon(),
            _ToggleMode(),
          ],
        ),
        _calendarIcon(context),
      ],
    );
  }

  Widget _profileIcon() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: 45,
      height: 45,
      decoration: const ShapeDecoration(
        color: BColors.grey,
        shape: OvalBorder(),
      ),
    );
  }

  Widget _ToggleMode() {
    return Container(
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
          ),
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
    );
  }

  Widget _calendarIcon(BuildContext context) {
    return GestureDetector(
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
            ),
          ],
        ),
        child: const Icon(Iconsax.calendar_1),
      ),
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
    String formattedDate = DateFormat('yMd').format(date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          _calendarItem(date, isSelected),
          if (BasketService.baskets.containsKey(formattedDate) &&
              BasketService
                  .baskets[formattedDate]!.basketIngredients.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.circle,
                size: 8,
                color: isSelected ? Colors.white : BColors.primaryFirst,
              ),
            ),
        ],
      ),
    );
  }

  Widget _calendarItem(DateTime date, bool isSelected) {
    return Container(
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
    );
  }

  Widget _basketContent(BasketViewModel basketViewModel) {
    return (BasketService.baskets
                .containsKey(basketViewModel.focusDateFormatted) &&
            BasketService.baskets[basketViewModel.focusDateFormatted]!
                .basketIngredients.isNotEmpty)
        ? Expanded(
            child: ListView.builder(
              itemCount: BasketService
                  .baskets[basketViewModel.focusDateFormatted]!
                  .basketIngredients
                  .length,
              itemBuilder: (BuildContext context, int index) {
                return _buildBasketItem(context, basketViewModel, index);
              },
            ),
          )
        : _emptyBasketMessage();
  }

  Widget _buildBasketItem(
      BuildContext context, BasketViewModel basketViewModel, int index) {
    final ingredient = BasketService
        .baskets[basketViewModel.focusDateFormatted]!.basketIngredients[index];

    return BasketItem(
      ingredient: ingredient,
      isSelected: ingredient.isSelected,
      basketViewModel: basketViewModel,
      index: index,
      deleteFunction: (context) => basketViewModel.deleteBasketItem(index),
      editFunction: (context) => basketViewModel.editBasketItem(context, index),
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
          final ingredient = await addIngredientDialog(context);
          if (ingredient != null && ingredient.name != "") {
            basketViewModel.addIngredient(ingredient);
          }
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: BColors.black,
        ),
      ),
    );
  }
}
