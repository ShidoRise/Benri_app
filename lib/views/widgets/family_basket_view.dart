import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/screens/login_screen.dart';
import 'package:benri_app/views/widgets/family_home_view.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';

class FamilyBasketView extends StatelessWidget {
  final BasketViewModel basketViewModel;
  final ProfileViewModel profileViewModel;

  const FamilyBasketView({
    super.key,
    required this.basketViewModel,
    required this.profileViewModel,
  });

  @override
  Widget build(BuildContext context) {
    profileViewModel.checkLoginStatus();

    if (!profileViewModel.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please login to use family mode',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

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
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Join Family'),
                            content: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Family Code',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (code) async {
                                try {
                                  Navigator.pop(context);
                                  await basketViewModel.joinFamily(code);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error joining family: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
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
