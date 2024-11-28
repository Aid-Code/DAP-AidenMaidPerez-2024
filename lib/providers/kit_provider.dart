import 'package:firebase_test/entities/kit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KitProvider extends ChangeNotifier {
  final List<Kit> _kits = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Kit> get kits => _kits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchKits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('kits').get();

      _kits.clear();
      for (var doc in snapshot.docs) {
        _kits.add(
          Kit(
            id: doc.id,  // Aseguramos que el id del documento se asigna al Kit
            nombre: doc['nombre'] ?? '',
            precio: doc['precio'] ?? '',
            imagen: doc['imagen'] ?? '',
          ),
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to load kits: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addKit(Kit kit) async {
    try {
      // Creamos un nuevo documento en Firestore
      DocumentReference docRef = await FirebaseFirestore.instance.collection('kits').add({
        'nombre': kit.nombre,
        'precio': kit.precio,
        'imagen': kit.imagen,
      });

      // Ahora que Firestore ha asignado un ID al nuevo documento, lo asignamos a la clase Kit
      final newKit = Kit(
        id: docRef.id,  // Asignamos el ID del nuevo documento
        nombre: kit.nombre,
        precio: kit.precio,
        imagen: kit.imagen,
      );

      _kits.add(newKit);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add kit: $e';
      notifyListeners();
    }
  }

  Future<void> deleteKit(String kitId) async {
    try {
      // Eliminamos el documento de Firestore usando su ID
      await FirebaseFirestore.instance.collection('kits').doc(kitId).delete();

      // Eliminamos el kit de la lista local usando el id del kit
      _kits.removeWhere((kit) => kit.id == kitId);  // Usamos kit.id, que es único
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete kit: $e';
      notifyListeners();
    }
  }

  Future<void> updateKit(Kit kit) async {
  try {
    // Actualizar el documento en Firestore usando el ID del kit
    await FirebaseFirestore.instance.collection('kits').doc(kit.id).update({
      'nombre': kit.nombre,
      'precio': kit.precio,
      'imagen': kit.imagen,
    });

    // Actualizar el kit en la lista local
    final index = _kits.indexWhere((k) => k.id == kit.id);
    if (index != -1) {
      _kits[index] = kit;
      notifyListeners();
    }
  } catch (e) {
    _errorMessage = 'Failed to update kit: $e';
    notifyListeners();
  }
}
}
