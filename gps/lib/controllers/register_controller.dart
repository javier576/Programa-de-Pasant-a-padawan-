import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmarPassController = TextEditingController();

  var isLoading = false.obs;

  Future<void> registerUser() async {
    if (emailController.text.trim().isEmpty ||
        passController.text.trim().isEmpty ||
        confirmarPassController.text.trim().isEmpty) {
      Get.snackbar(
        "Error al registrar usuario",
        "Por favor rellena todos los campos",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (passController.text.trim() != confirmarPassController.text.trim()) {
      Get.snackbar(
        "Error al registrar usuario",
        "Las contraseñas no coinciden",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authService.registerUser(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      Get.back();
      Get.snackbar(
        '¡Cuenta Creada!',
        'Usuario registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Error al registrar usuario",
        e.toString().replaceAll("Exception:", ""),
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
    confirmarPassController.dispose();
    super.onClose();
  }
}
