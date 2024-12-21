import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmBottomSheet(BuildContext context, String title) async {
  return await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: BColors.primaryFirst, width: 2),
                        backgroundColor: Colors.white,
                        foregroundColor: BColors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      ),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.primaryFirst,
                        foregroundColor: BColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      ),
                      child: const Text(
                        'Đồng ý',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20)
            ]),
          ));
}
