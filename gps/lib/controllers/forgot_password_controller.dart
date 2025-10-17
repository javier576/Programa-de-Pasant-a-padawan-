import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx/screens/longinScreen.dart';
import 'package:getx/services/auth_services.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      await _authService.resetPassword(email: emailController.text.trim());
      Get.offAll(() => const Longinscreen());
      Get.snackbar(
        'Revisa tu Correo',
        'Se ha enviado un enlace para restablecer tu contraseña.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error al cambiar la contraseña",
        e.toString().replaceAll("Exception:", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }

    @override
    void onClose() {
      emailController.dispose();
      super.onClose();
    }
  }
}
