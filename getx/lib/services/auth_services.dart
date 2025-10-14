import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        print("Usuario registrado con exito: ${user.email}");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'El correo electrónico ya está en uso.');
      } else {
        Get.snackbar('Error', 'Error de autenticación: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error: $e');
    }
  }

  Future<User?> SignIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No se encontró ningún usuario con ese correo.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Contraseña incorrecta.');
      } else {
        Get.snackbar('Error', 'Error de autenticación: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Éxito',
        'Correo de restablecimiento de contraseña enviado.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No se encontró ningún usuario con ese correo.');
      } else {
        Get.snackbar('Error', 'Error de autenticación: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error: $e');
    }
  }
}
