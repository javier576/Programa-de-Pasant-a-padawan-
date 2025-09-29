import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulario/screens/login_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/loading_overlay.dart';
import '../core/db_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final nacimientoController = TextEditingController();
  final telefonoController = TextEditingController();

  bool isLoading = false;

  // Lista de países de Centroamérica con prefijo y longitud de teléfono
  final Map<String, Map<String, dynamic>> countries = {
    "El Salvador": {"prefix": "+503", "maxLength": 8},
    "Guatemala": {"prefix": "+502", "maxLength": 8},
    "Honduras": {"prefix": "+504", "maxLength": 8},
    "Nicaragua": {"prefix": "+505", "maxLength": 8},
    "Costa Rica": {"prefix": "+506", "maxLength": 8},
    "Panamá": {"prefix": "+507", "maxLength": 8},
    "Belice": {"prefix": "+501", "maxLength": 7},
  };

  String? selectedCountry;
  String phonePrefix = "";
  int phoneMaxLength = 8;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year - 13,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (picked != null) {
      setState(() {
        nacimientoController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  ///Método para registrar usuario
  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final name = nameController.text.trim();
    final nacimiento = nacimientoController.text.trim();
    final telefono = telefonoController.text.trim();
    final pais = selectedCountry ?? "";

    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        nacimiento.isEmpty ||
        telefono.isEmpty ||
        pais.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    if (telefono.length != phoneMaxLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "El teléfono debe tener $phoneMaxLength dígitos para $pais",
          ),
        ),
      );
      return;
    }

    // nombre
    List<String> partes = name.split(" ");
    if (partes.length < 2 || partes.any((parte) => parte.length < 3)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa tu nombre completo (nombre y apellido)"),
        ),
      );
      return;
    }
    setState(() => isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulación de carga

      bool exists = await DBHelper.emailExists(email);

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El correo ya está registrado")),
        );
      } else {
        await DBHelper.registerUser(
          email,
          password,
          name,
          nacimiento,
          int.parse(telefono),
          pais,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado con éxito")),
        );

        Navigator.pop(context); // volver al login
      }
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
                "Crear cuenta",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              // Correo
              CustomInput(hint: "Correo", controller: emailController),
              const SizedBox(height: 16),
              // Nombre
              CustomInput(hint: "Nombre Completo", controller: nameController),
              const SizedBox(height: 16),

              //Fecha de nacimiento
              TextField(
                controller: nacimientoController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Fecha de Nacimiento",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(context),
              ),
              const SizedBox(height: 16),

              // Selector de país
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: const InputDecoration(labelText: "País"),
                items: countries.keys
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    phonePrefix = countries[value]!["prefix"];
                    phoneMaxLength = countries[value]!["maxLength"];
                    telefonoController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Teléfono con prefijo dinámico
              TextField(
                controller: telefonoController,
                keyboardType: TextInputType.number,
                maxLength: phoneMaxLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  prefixText: "$phonePrefix ",
                ),
              ),
              const SizedBox(height: 16),
              // Contraseña
              CustomInput(
                hint: "Contraseña",
                obscure: true,
                controller: passController,
              ),

              const SizedBox(height: 24),
              CustomButton(text: "Registrarse", onPressed: _register),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text("Tienes una cuenta? Iniciar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
