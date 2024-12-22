import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/utils/constants/colors.dart';

class TotalMoneyInput extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const TotalMoneyInput({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: BColors.primaryFirst,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: basketViewModel.totalMoneyController
                ..text = basketViewModel.getTotalMoney(),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: BColors.darkGrey,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsFormatter(),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter total money',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                suffixText: '₫',
                suffixStyle: const TextStyle(
                  color: BColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onChanged: (value) {
                final cleanValue = value.replaceAll(',', '');
                basketViewModel.updateTotalMoney(cleanValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.parse(newValue.text.replaceAll(',', ''));
    final formatted = value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
