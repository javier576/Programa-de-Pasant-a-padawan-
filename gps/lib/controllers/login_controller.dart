import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx/screens/CustomPaint.dart';
import 'package:getx/screens/mapsScreen.dart';
import 'package:getx/services/auth_services.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final emailController = TextEditingController();
  final passController = TextEditingController();

  var isLoading = false.obs;

  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      final user = await _authService.SignIn(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      if (user != null) {
        Get.offAll(() => const MapsScreen());
        Get.snackbar(
          'Exito',
          'Has iniciado sesion correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error al iniciar sesion",
        e.toString().replaceAll("Exception", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }
}
