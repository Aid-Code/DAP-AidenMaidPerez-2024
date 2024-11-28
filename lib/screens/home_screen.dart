import 'package:firebase_test/entities/kit.dart';
import 'package:firebase_test/providers/kit_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  bool _isAdding = false;  // Controla si estamos mostrando el formulario para agregar un kit

  @override
  void initState() {
    super.initState();
    final kitProvider = Provider.of<KitProvider>(context, listen: false);
    kitProvider.fetchKits();
  }

  @override
  Widget build(BuildContext context) {
    final kitProvider = Provider.of<KitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();  // Usar context.pop() si estás usando go_router
        },
      ),
      ),
      body: Column(
        children: [
          // Lista de kits
          Expanded(
            child: Consumer<KitProvider>(
              builder: (context, kitProvider, child) {
                if (kitProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (kitProvider.errorMessage != null) {
                  return Center(child: Text('Error: ${kitProvider.errorMessage}'));
                } else if (kitProvider.kits.isEmpty) {
                  return const Center(child: Text('No se encontraron kits.'));
                }

                final kits = kitProvider.kits;

                return ListView.builder(
                  itemCount: kits.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(kits[index].nombre),
                        subtitle: Text(kits[index].precio),
                        leading: Image.network(
                          kits[index].imagen,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        onTap: () {
                          // Navegar a DetailsScreen, pasando el kit seleccionado como argumento
                          context.push("/home/details/:kit", extra: kits[index]);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Si estamos en el modo de agregar un kit, mostrar el formulario
          if (_isAdding) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  TextField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                    ),
                  ),
                  TextField(
                    controller: _imagenController,
                    decoration: const InputDecoration(
                      labelText: 'Imagen (URL)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final nombre = _nombreController.text;
                      final precio = _precioController.text;
                      final imagen = _imagenController.text;

                      if (nombre.isNotEmpty && precio.isNotEmpty && imagen.isNotEmpty) {
                        final newKit = Kit(
                          id: '',  // Firestore asignará el ID automáticamente
                          nombre: nombre,
                          precio: precio,
                          imagen: imagen,
                        );

                        // Agregar el kit al provider y a Firestore
                        await kitProvider.addKit(newKit);
                        setState(() {
                          _isAdding = false;  // Ocultar el formulario después de agregar el kit
                        });

                        // Limpiar los campos del formulario
                        _nombreController.clear();
                        _precioController.clear();
                        _imagenController.clear();
                      }
                    },
                    child: const Text('Agregar Kit'),
                  ),
                ],
              ),
            ),
          ],
          
          // Botón para agregar un kit, que estará al final de la pantalla
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAdding = !_isAdding;  // Alternar la visibilidad del formulario
                });
              },
              child: Text(_isAdding ? 'Cancelar' : 'Agregar Nuevo Kit'),
            ),
          ),
        ],
      ),
    );
  }
}
