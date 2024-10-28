// import 'package:flutter/foundation.dart';
// import 'package:benri/models/user.dart';
// import 'package:benri/services/user_service.dart';
// import 'package:flutter/material.dart';

// class ProfileViewModel extends ChangeNotifier {
//   final UserService _userService;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController sexController = TextEditingController();
//   User? _user;
//   bool _isLoading = false;
//   String _errorMessage = '';

//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   String get errorMessage => _errorMessage;
//   ProfileViewModel(this._userService);

//   Future<void> loadUserProfile() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _user = await _userService.getCurrentUser();
//       _errorMessage = '';
//     } catch (e) {
//       _errorMessage = 'Failed to load user data';
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> updateUser({
//     String? name,
//     String? sex,
//     String? phone,
//     String? avatar,
//   }) async {
//     if (_user == null) return;

//     _isLoading = true;
//     notifyListeners();

//     try {
//       if (name != null) _user!.userName = name;
//       if (sex != null) _user!.userSex = sex;
//       if (phone != null) _user!.userPhone = phone;
//       if (avatar != null) _user!.userAvatar = avatar;

//       await _userService.updateUser(_user!);
//       _errorMessage = '';
//     } catch (e) {
//       _errorMessage = 'Failed to update user data';
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }
