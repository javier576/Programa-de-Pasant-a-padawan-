import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/components/logo.dart';
import 'package:getx/controllers/login_controller.dart'; // Importa el controlador
import 'package:getx/screens/registerScreen.dart';
import 'package:getx/screens/forgottPasswordScreen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';

class Longinscreen extends StatelessWidget {
  const Longinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = LoginController();
    final isSpanish = Localizations.localeOf(context).languageCode == 'es';
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  isSpanish
                      ? 'Bienvenido a I-Strategies'
                      : 'Welcome to I-Strategies',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Logo(),
                const SizedBox(height: 24),
                Text(
                  isSpanish ? 'Iniciar Sesión' : 'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(
                  hint: isSpanish ? 'Correo Electrónico' : 'Email',
                  controller: controller.emailController,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  hint: isSpanish ? 'Contraseña' : 'Password',
                  obscure: true,
                  controller: controller.passController,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: isSpanish ? 'Iniciar Sesión' : 'Login',
                  onPressed: controller.loginUser,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Get.to(() => const Forgottpasswordscreen());
                  },
                  child: Text(
                    isSpanish
                        ? '¿Olvidaste tu contraseña?'
                        : 'Forgot Password?',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const Registerscreen());
                  },
                  child: Text(
                    isSpanish
                        ? '¿No tienes una cuenta? Regístrate'
                        : "Don't have an account? Sign Up",
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
