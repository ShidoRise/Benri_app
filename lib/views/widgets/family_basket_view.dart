import 'package:benri_app/views/screens/login_screen.dart';
import 'package:benri_app/views/widgets/family_home_view.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:provider/provider.dart';

class FamilyBasketView extends StatelessWidget {
  const FamilyBasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BasketViewModel>(
      builder: (context, basketViewModel, _) {
        if (basketViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (basketViewModel.isLoggedIn != null &&
            !basketViewModel.isLoggedIn!) {
          return _buildLoginRequired(context);
        }

        if (basketViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!basketViewModel.hasInternet) {
          return _buildNoInternet();
        }

        if (!basketViewModel.hasFamily) {
          return _buildWelcomeFamily(context, basketViewModel);
        }

        return FamilyHomeView(basketViewModel: basketViewModel);
      },
    );
  }

  Widget _buildLoginRequired(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Yêu cầu đăng nhập',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng đăng nhập để sử dụng chế độ gia đình.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: const Text('Đăng nhập',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternet() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Không có kết nối mạng',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeFamily(
      BuildContext context, BasketViewModel basketViewModel) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.family_restroom, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Chào mứng tới chức năng Gia Đình.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => basketViewModel.createFamily('My Family'),
                    child: const Text('Tạo gia đình',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () =>
                        _showJoinFamilyDialog(context, basketViewModel),
                    child: const Text('Tham gia gia đình',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinFamilyDialog(
      BuildContext context, BasketViewModel basketViewModel) {
    final codeController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tham gia gia đình',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Nhập code gia đình',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.family_restroom),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(width: 0.9),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (codeController.text.isNotEmpty) {
                        Navigator.pop(context);
                        await basketViewModel.joinFamily(codeController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tham gia',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
