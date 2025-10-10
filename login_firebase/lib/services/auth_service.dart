import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

Future<void> registerUser({
  required String email,
  required String password,
}) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    if (user != null) {
      print("Usuario registrado con éxito: ${user.email}");
    }
  } on FirebaseAuthException catch (e) {
    print("Error de registro: ${e.code}");

    if (e.code == 'weak-password') {
      throw Exception('La contraseña es demasiado débil.');
    } else if (e.code == 'email-already-in-use') {
      throw Exception('Ya existe una cuenta con este correo electrónico.');
    } else {
      throw Exception('Error al registrar: ${e.message}');
    }
  } catch (e) {
    print(e);
    throw Exception('Ocurrió un error inesperado.');
  }
}

Future<User?> SignIn({required String email, required String password}) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    print("Error de login: ${e.code}");
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      throw Exception(
        'Credenciales incorrectas. Verifique su correo y contraseña.',
      );
    } else {
      throw Exception('Error de inicio de sesión: ${e.message}');
    }
  }
}

Future<void> resetPassword({required String email}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    print("Correo de restablecimiento de contraseña enviado a $email");
  } on FirebaseAuthException catch (e) {
    print("Error al enviar correo: ${e.code}");
    if (e.code == 'user-not-found') {
      throw Exception(
        'No existe una cuenta registrada con este correo electrónico.',
      );
    } else {
      throw Exception('Error al restablecer contraseña: ${e.message}');
    }
  }
}
