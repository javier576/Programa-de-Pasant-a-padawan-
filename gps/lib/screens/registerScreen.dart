import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/components/logo.dart';
import 'package:getx/controllers/register_controller.dart'; // Importa el controller
import 'package:getx/screens/longinscreen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    final isSpanish = Localizations.localeOf(context).languageCode == 'es';

    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Logo(),
                const SizedBox(height: 24),
                Text(
                  isSpanish ? 'Crear una cuenta' : 'Create an Account',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(
                  hint: isSpanish ? "Correo" : "Email",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  hint: isSpanish ? "Contraseña" : "Password",
                  controller: controller.passController,
                  obscure: true,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  hint: isSpanish ? "Confirmar Contraseña" : "Confirm Password",
                  controller: controller.confirmarPassController,
                  obscure: true,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: isSpanish ? "Registrarse" : "Register",
                  onPressed: controller.registerUser,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Get.to(() => const Longinscreen());
                  },
                  child: Text(
                    isSpanish
                        ? "¿Ya tienes una cuenta? Inicia sesión"
                        : "Already have an account? Log in",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
