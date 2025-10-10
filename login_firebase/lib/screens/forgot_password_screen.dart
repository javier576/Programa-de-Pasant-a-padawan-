import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_firebase/screens/login_screen.dart';
import 'package:login_firebase/screens/register_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == "es"
                ? "Se ha enviado un correo para restablecer la contraseña."
                : "A password reset email has been sent.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String message;
      if (Localizations.localeOf(context).languageCode == "es") {
        if (e.code == 'user-not-found') {
          message = "No existe una cuenta con ese correo.";
        } else if (e.code == 'invalid-email') {
          message = "Correo electrónico no válido.";
        } else {
          message = "Error al enviar el correo: ${e.message}";
        }
      } else {
        if (e.code == 'user-not-found') {
          message = "No account found with that email.";
        } else if (e.code == 'invalid-email') {
          message = "Invalid email address.";
        } else {
          message = "Error sending email: ${e.message}";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSpanish = Localizations.localeOf(context).languageCode == "es";

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
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
                      isSpanish ? "Restablecer Contraseña" : "Reset Password",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    CustomInput(
                      hint: isSpanish ? "Correo electrónico" : "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isSpanish
                              ? "Por favor, ingresa tu correo."
                              : "Please enter your email.";
                        } else if (!value.contains("@")) {
                          return isSpanish
                              ? "Correo no válido."
                              : "Invalid email.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: isSpanish
                          ? "Enviar enlace de recuperación"
                          : "Send reset link",
                      onPressed: _resetPassword,
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
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        isSpanish ? "Crear cuenta" : "Create account",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
