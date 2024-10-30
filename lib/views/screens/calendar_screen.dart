import 'package:benri_app/services/basket_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/basket_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BasketViewModel>(context, listen: false)
          .updateFocusDate(DateTime.now());
    });

    return Scaffold(
      appBar: BAppBar(title: 'Calendar'),
      body: Consumer<BasketViewModel>(
        builder: (context, basketViewModel, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TableCalendar(
                  rowHeight: 50,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  selectedDayPredicate: (day) =>
                      isSameDay(day, basketViewModel.focusDate),
                  focusedDay: basketViewModel.focusDate,
                  firstDay: DateTime(2024),
                  lastDay: DateTime(2030),
                  onDaySelected: (selectedDay, focusedDay) {
                    basketViewModel.updateFocusDate(selectedDay);
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildCalendarItem(context, basketViewModel, day,
                          isSelected: false);
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildCalendarItem(context, basketViewModel, day,
                          isSelected: true);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return _buildCalendarItem(context, basketViewModel, day,
                          isSelected: false);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ngày ${basketViewModel.focusDate.day} tháng ${basketViewModel.focusDate.month}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              (BasketService.baskets
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
    );
  }

  Widget _buildCalendarItem(
      BuildContext context, BasketViewModel basketViewModel, DateTime day,
      {required bool isSelected}) {
    String formattedDate = basketViewModel.formatDateTimeToString(day);

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isSelected ? BColors.primaryFirst : BColors.white,
        shape: isSelected ? BoxShape.circle : BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (BasketService.baskets.containsKey(formattedDate) &&
              BasketService
                  .baskets[formattedDate]!.basketIngredients.isNotEmpty)
            Icon(
              Icons.circle,
              size: 8,
              color: isSelected ? BColors.white : BColors.primaryFirst,
            ),
        ],
      ),
    );
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
          'No ingredients here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
      ),
    );
  }
}
