import 'package:benri_app/services/baskets_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/views/widgets/basket_item.dart';
import 'package:benri_app/views/widgets/basket_total_money.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:intl/intl.dart';

class PersonalBasketView extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const PersonalBasketView({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _basketMiniCalendar(context, basketViewModel),
        _separatorLineWithShadow(),
        _basketContent(basketViewModel),
      ],
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
          if (basketViewModel.checkBasketIngredientsEmpty(formattedDate))
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
    return (basketViewModel
            .checkBasketIngredientsEmpty(basketViewModel.focusDateFormatted))
        ? Expanded(
            child: Column(
              children: [
                TotalMoneyInput(basketViewModel: basketViewModel),
                Expanded(
                  child: ListView.builder(
                    itemCount: BasketService
                        .baskets[basketViewModel.focusDateFormatted]!
                        .basketIngredients
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildBasketItem(context, basketViewModel, index);
                    },
                  ),
                ),
              ],
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
    return const Expanded(
      child: Center(
        child: Text(
          'No ingredients here,\nclick + to add',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
      ),
    );
  }
}
