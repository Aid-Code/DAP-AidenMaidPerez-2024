import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_test/entities/user.dart'; // Asegúrate de tener esta entidad

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Simulación de verificación de contraseñas (Reemplazar con bcrypt)
  bool _verifyPassword(String password, String hashedPassword) {
    // Implementar usando bcrypt si es posible
    return password == hashedPassword; // Solo para texto plano
  }

  // Registro de usuarios
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Verificar si el email ya está en uso
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        _errorMessage = 'Email is already in use';
        return false;
      }

      // Agregar el nuevo usuario
      await FirebaseFirestore.instance.collection('users').add({
        'username': username,
        'email': email,
        'password': password, // Asegúrate de almacenar un hash
      });

      _errorMessage = '';
      return true;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Inicio de sesión
  Future<bool> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();

  try {
    print('Iniciando autenticación para el email: $email');

    // Consulta a Firestore para buscar al usuario por email
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Verificar si se encontró el usuario
    if (userQuery.docs.isNotEmpty) {
      print('Usuario encontrado en Firestore.');
      var userDoc = userQuery.docs.first;

      // Recuperar y verificar la contraseña almacenada
      String storedPasswordHash = userDoc.get('password');
      print('Verificando contraseña para el usuario con ID: ${userDoc.id}');

      bool isPasswordCorrect = _verifyPassword(password, storedPasswordHash);

      if (isPasswordCorrect) {
        // Crear instancia del usuario autenticado
        _currentUser = User(
          id: userDoc.id,
          username: userDoc.get('username'),
          email: userDoc.get('email'),
        );
        print('Usuario autenticado exitosamente: ${_currentUser?.username}');

        _errorMessage = '';
        return true;
      } else {
        print('Contraseña incorrecta para el email: $email');
        _errorMessage = 'Incorrect password';
        return false;
      }
    } else {
      print('No se encontró un usuario con el email: $email');
      _errorMessage = 'User not found';
      return false;
    }
  } catch (e, stackTrace) {
    // Log detallado del error y su traza
    print('Error durante la autenticación: $e');
    print('StackTrace: $stackTrace');
    _errorMessage = 'An unexpected error occurred: $e';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // Actualización del usuario
  void updateUser({String? username, String? email}) {
    if (_currentUser == null) return;

    _currentUser = User(
      id: _currentUser!.id,
      username: username ?? _currentUser!.username,
      email: email ?? _currentUser!.email,
    );
    notifyListeners();
  }

  // Cerrar sesión
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
