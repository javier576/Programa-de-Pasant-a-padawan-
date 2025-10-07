import 'package:flutter/material.dart';
import 'package:CustomPaint/screens/login_screen.dart';
import 'package:CustomPaint/screens/register_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import 'package:CustomPaint/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final ApiService api = ApiService();

  bool isLoading = false;

  void _resetPassword() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    String changePasword = await api.changePassword(
      emailController.text,
      passController.text,
    );
    if (Localizations.localeOf(context).languageCode == "es") {
      if (changePasword == "Contraseña Cambiada") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Contraseña cambiada")));
        Navigator.pop(context);
      } else if (changePasword ==
          "La nueva contraseña no puede ser igual a la anterior") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "La nueva contraseña no puede ser igual a la anterior",
            ),
          ),
        );
      } else if (changePasword == "Usuario no encontrado") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Correo no encontrado")));
      }
    } else {
      if (changePasword == "Contraseña Cambiada") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Password changed")));
        Navigator.pop(context);
      } else if (changePasword ==
          "La nueva contraseña no puede ser igual a la anterior") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "The new password cannot be the same as the previous one.",
            ),
          ),
        );
      } else if (changePasword == "Usuario no encontrado") {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Email not found")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "es") {
      return LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/i-strategies.png'),
                ),
                const SizedBox(height: 24),
                Text(
                  "Restablecer Contraseña",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(hint: "Correo", controller: emailController),
                const SizedBox(height: 16),
                CustomInput(
                  hint: "Nueva contraseña",
                  obscure: true,
                  controller: passController,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Cambiar contraseña",
                  onPressed: _resetPassword,
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text("Tiene cuenta? Iniciar sesión"),
                ),

                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text("Crear cuenta"),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/i-strategies.png'),
                ),
                const SizedBox(height: 24),
                Text(
                  "Reset Password",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(hint: "Email", controller: emailController),
                const SizedBox(height: 16),
                CustomInput(
                  hint: "New password",
                  obscure: true,
                  controller: passController,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Change password",
                  onPressed: _resetPassword,
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text("Have an account? Sign in"),
                ),

                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text("Create account"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
