import 'package:flutter/material.dart';
import 'package:login_firebase/screens/login_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import '../services/auth_service.dart'; // Importa tu servicio de Firebase

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Llamada a Firebase
      await registerUser(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta creada exitosamente")),
      );

      Navigator.pop(context); // Volver al login
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
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
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/i-strategies.png'),
              ),
              const SizedBox(height: 24),
              Text(
                isSpanish ? "Crear cuenta" : "Create account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              CustomButton(
                text: isSpanish ? "Registrarse" : "Create account",
                onPressed: _register,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: Text(
                  isSpanish
                      ? "¿Ya tienes cuenta? Inicia sesión"
                      : "Have an account? Sign in",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
