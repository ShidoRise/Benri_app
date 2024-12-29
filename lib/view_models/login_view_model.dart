import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/services/baskets_service.dart';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/view_models/recipe_creation_provider.dart';
import 'package:benri_app/views/screens/forgot_password.dart';
import 'package:benri_app/views/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void routeToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUp()));
  }

  void routeToForgotPassword(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ForgotPassword()));
  }

  Future<bool> loginWithGG(BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final bool loginSuccess = await AuthService.signInWithGoogle();

      if (loginSuccess) {
        final currentContext = context;
        if (currentContext.mounted) {
          final profileViewModel = Provider.of<ProfileViewModel>(
            currentContext,
            listen: false,
          );
          final basketViewModel = Provider.of<BasketViewModel>(
            currentContext,
            listen: false,
          );
          final recipeViewModel = Provider.of<FavouriteRecipeProvider>(
            context,
            listen: false,
          );
          await profileViewModel.checkLoginStatus();
          if (profileViewModel.isLoggedIn) {
            await basketViewModel.checkIsLoggedIn();
            await basketViewModel.initializeFamilyStatus();
            await BasketService.syncLocalBackLogin();
            await RecipesService.syncLocalRecipeBackLogin();
            basketViewModel.initializeData();
            recipeViewModel.initializeData();
          }
        }
        setLoading(false);

        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during login: $e';
      setLoading(false);
      return false;
    }
  }

  Future<bool> login(BuildContext context) async {
    print('LoginViewModel - login');
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final bool loginSuccess = await AuthService.login(
        emailController.text,
        passwordController.text,
      );

      if (loginSuccess) {
        final currentContext = context;
        if (currentContext.mounted) {
          final profileViewModel = Provider.of<ProfileViewModel>(
            currentContext,
            listen: false,
          );
          final basketViewModel = Provider.of<BasketViewModel>(
            currentContext,
            listen: false,
          );

          await profileViewModel.checkLoginStatus();
          if (profileViewModel.isLoggedIn) {
            await basketViewModel.checkIsLoggedIn();
            await basketViewModel.initializeFamilyStatus();
          }
        }
        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during login: $e';
      setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
