import 'package:benri_app/views/widgets/family_home_view.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';

class FamilyBasketView extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const FamilyBasketView({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    basketViewModel.checkFamilyStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      basketViewModel.initConnectivity();
    });

    return AnimatedBuilder(
      animation: basketViewModel,
      builder: (context, child) {
        if (!basketViewModel.hasInternet) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check your connection and try again',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => basketViewModel.initConnectivity(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (basketViewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!basketViewModel.hasFamily) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.family_restroom,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Family Mode',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await basketViewModel.createFamily("My Family");
                        basketViewModel.loadFamilyCode();
                      },
                      child: const Text('Create Family'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement join family
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text('Coming Soon'),
                            content:
                                Text('Join family feature is coming soon!'),
                          ),
                        );
                      },
                      child: const Text('Join Family'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return FamilyHomeView(basketViewModel: basketViewModel);
      },
    );
  }
}
