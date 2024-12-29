import 'package:benri_app/services/family_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/views/widgets/family_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FamilyHomeView extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const FamilyHomeView({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _basketMiniCalendar(context, basketViewModel),
        SizedBox(height: 5),
        _showMemberBuyIngredients(context, basketViewModel),
        SizedBox(height: 5),
        _familyContent(basketViewModel),
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
        lastDate: DateTime(2025, 12, 31),
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
          if (basketViewModel.checkFamilyIngredientsEmpty(formattedDate))
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

  Widget _familyContent(BasketViewModel basketViewModel) {
    return (basketViewModel
            .checkFamilyIngredientsEmpty(basketViewModel.focusDateFormatted))
        ? Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: FamilyService
                        .familyShoppingListData[
                            basketViewModel.focusDateFormatted]!
                        .ingredients
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
    final ingredient = FamilyService
        .familyShoppingListData[basketViewModel.focusDateFormatted]!
        .ingredients[index];

    return FamilyItem(
      ingredient: ingredient,
      status: ingredient.status,
      basketViewModel: basketViewModel,
      index: index,
      deleteFunction: (context) => basketViewModel.deleteFamilytItem(index),
      editFunction: (context) => basketViewModel.editFamilyItem(context, index),
    );
  }

  Widget _emptyBasketMessage() {
    return const Expanded(
      child: Center(
        child: Text(
          'Không có nguyên liệu nào,\nbấm vào + để thêm',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
      ),
    );
  }

  Widget _showMemberBuyIngredients(
      BuildContext context, BasketViewModel basketViewModel) {
    return GestureDetector(
      onTap: () {
        (basketViewModel.userRole == 'admin')
            ? basketViewModel.showMemberBuyIngredients(
                context, basketViewModel.focusDateFormatted)
            : Fluttertoast.showToast(
                msg: 'Admin mới có quyền chọn nguời đi chợ',
                backgroundColor: BColors.darkGrey);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 10, 16, 5),
        decoration: BoxDecoration(
          color: BColors.grey,
          boxShadow: [
            BoxShadow(
              color: BColors.grey,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Người đi chợ: ${basketViewModel.familyMemberBuyIngredients(basketViewModel.focusDateFormatted)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
