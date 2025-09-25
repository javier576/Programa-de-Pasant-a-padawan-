import 'package:flutter/material.dart';
import 'package:formulario/screens/login_screen.dart';
import 'package:formulario/screens/register_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import '../core/db_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  void _resetPassword() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    bool exists = await DBHelper.emailExists(emailController.text.trim());

    if (exists) {
      await DBHelper.resetPassword(
        emailController.text.trim(),
        passController.text.trim(),
      );
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Contraseña cambiada")));
      Navigator.pop(context);
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Correo no encontrado")));
    }
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
