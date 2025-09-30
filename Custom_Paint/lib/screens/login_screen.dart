import 'package:flutter/material.dart';
import 'package:CustomPaint/screens/custom_paint.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import '../core/db_helper.dart';
import 'package:CustomPaint/screens/register_screen.dart';
import 'package:CustomPaint/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simula espera

    final user = await DBHelper.loginUser(
      emailController.text.trim(),
      passController.text.trim(),
    );

    setState(() => isLoading = false);
    if (Localizations.localeOf(context).languageCode == "es") {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomPaintScreen()),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sesión iniciada")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
      }
    } else {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomPaintScreen()),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signed in")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")),
        );
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
                Text(
                  "Bienvenido a I-Strategies ",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/i-strategies.png'),
                ),
                const SizedBox(height: 24),
                Text(
                  "Iniciar Sesión",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(hint: "Correo", controller: emailController),
                const SizedBox(height: 16),
                CustomInput(
                  hint: "Contraseña",
                  obscure: true,
                  controller: passController,
                ),
                const SizedBox(height: 16),
                CustomButton(text: "Iniciar Sesión", onPressed: _login),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text("¿Olvidaste tu contraseña?"),
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
                Text(
                  "Welcome to I-Strategies",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/i-strategies.png'),
                ),
                const SizedBox(height: 24),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                CustomInput(hint: "Enail", controller: emailController),
                const SizedBox(height: 16),
                CustomInput(
                  hint: "Password",
                  obscure: true,
                  controller: passController,
                ),
                const SizedBox(height: 16),
                CustomButton(text: "Login", onPressed: _login),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text("Forgot your password?"),
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
