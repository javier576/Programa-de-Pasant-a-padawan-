import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/components/logo.dart';
import 'package:getx/controllers/forgot_password_controller.dart';
import 'package:getx/screens/longinScreen.dart';
import 'package:getx/screens/registerScreen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';

class Forgottpasswordscreen extends StatelessWidget {
  const Forgottpasswordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final isSpanish = Localizations.localeOf(context).languageCode == 'es';
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Logo(),
                      const SizedBox(height: 24),
                      Text(
                        isSpanish ? "Restablecer Contraseña" : "Reset Password",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      CustomInput(
                        hint: isSpanish ? "Correo Electrónico" : "Email",
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isSpanish
                                ? "Por favor ingrese su correo electrónico"
                                : "Please enter your email";
                          } else if (!GetUtils.isEmail(value)) {
                            return isSpanish
                                ? "Por favor ingrese un correo electrónico válido"
                                : "Please enter a valid email";
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: isSpanish
                            ? "Enviar enlace de restablecimiento"
                            : "Send Reset Link",
                        onPressed: controller.resetPassword,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Get.off(() => const Longinscreen());
                        },
                        child: Text(
                          isSpanish
                              ? "Volver a Iniciar Sesión"
                              : "Back to Login",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(() => const Registerscreen());
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
          ),
        ),
      ),
    );
  }
}
