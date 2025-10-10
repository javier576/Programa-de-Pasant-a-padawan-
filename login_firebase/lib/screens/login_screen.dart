import 'package:flutter/material.dart';
import 'package:login_firebase/screens/custom_paint.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import 'package:login_firebase/screens/register_screen.dart';
import 'package:login_firebase/screens/forgot_password_screen.dart';
import 'package:login_firebase/services/auth_service.dart'; // tu servicio Firebase

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  // Método para iniciar sesión usando Firebase
  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      final user = await SignIn(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      setState(() => isLoading = false);

      if (user != null) {
        // Login correcto → ir a pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomPaintScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == "es"
                  ? "Sesión iniciada correctamente"
                  : "Signed in successfully",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == "es"
                ? "Error: ${e.toString().replaceAll('Exception:', '').trim()}"
                : "Error: ${e.toString().replaceAll('Exception:', '').trim()}",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSpanish = Localizations.localeOf(context).languageCode == "es";

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                isSpanish
                    ? "Bienvenido a I-Strategies"
                    : "Welcome to I-Strategies",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/i-strategies.png'),
              ),
              const SizedBox(height: 24),
              Text(
                isSpanish ? "Iniciar Sesión" : "Login",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              CustomInput(
                hint: isSpanish ? "Correo" : "Email",
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                hint: isSpanish ? "Contraseña" : "Password",
                obscure: true,
                controller: passController,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: isSpanish ? "Iniciar Sesión" : "Login",
                onPressed: _login,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: Text(
                  isSpanish
                      ? "¿Olvidaste tu contraseña?"
                      : "Forgot your password?",
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: Text(isSpanish ? "Crear cuenta" : "Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
