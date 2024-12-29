import 'package:benri_app/models/onboarding/onboarding_info.dart';

class OnboardingItems {
  static List<OnboardingInfo> items = [
    OnboardingInfo(
      title: 'Lập danh sách đi chợ dễ dàng',
      description:
          'Tạo danh sách nguyên liệu cần mua chỉ trong vài bước và sẵn sàng để đi chợ bất kỳ lúc nào.',
      image: 'assets/images/onboarding/baskets.png',
    ),
    OnboardingInfo(
      title: 'Kết nối gia đình qua giỏ hàng',
      description:
          'Chia sẻ giỏ hàng với cả nhà, cùng chọn nguyên liệu và giao nhiệm vụ đi chợ dễ dàng.',
      image: 'assets/images/onboarding/family.png',
    ),
    OnboardingInfo(
      title: 'Quản lý nguyên liệu trong tủ lạnh',
      description:
          'Lưu trữ nguyên liệu của bạn, theo dõi chúng và tránh lãng phí thực phẩm.',
      image: 'assets/images/onboarding/fridge.png',
    ),
    OnboardingInfo(
      title: 'Khám phá và nấu ăn cùng công thức yêu thích',
      description:
          'Tìm công thức mới lạ, lưu lại món yêu thích và thêm nguyên liệu vào giỏ chỉ với một chạm.',
      image: 'assets/images/onboarding/recipe.png',
    ),
    OnboardingInfo(
      title: 'Sẵn sàng để trải nghiệm mới!',
      description:
          'Cùng Benri khám phá cách đi chợ thông minh, tiện lợi và kết nối gia đình ngay hôm nay!',
      image: 'assets/images/onboarding/started.png',
    ),
  ];
}
