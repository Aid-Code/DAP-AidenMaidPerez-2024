import 'package:firebase_test/entities/kit.dart';
import 'package:firebase_test/providers/kit_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  static const name = 'Details';

  // Recibe el Kit como parámetro
  final Kit kit;
  const DetailsScreen({super.key, required this.kit});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Controladores de texto para los campos editables
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _imagenController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores actuales del Kit
    _nombreController = TextEditingController(text: widget.kit.nombre);
    _precioController = TextEditingController(text: widget.kit.precio);
    _imagenController = TextEditingController(text: widget.kit.imagen);
  }

  @override
  void dispose() {
    // Liberamos los controladores cuando la pantalla sea destruida
    _nombreController.dispose();
    _precioController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kitProvider = Provider.of<KitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kit.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();  // Volver a la pantalla anterior
          },
        ),
        actions: [
          // Botón para editar la información
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Hacemos que los campos se conviertan en editables
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Editar Kit"),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo para editar el nombre
                          TextField(
                            controller: _nombreController,
                            decoration: const InputDecoration(labelText: 'Nombre'),
                          ),
                          const SizedBox(height: 16),
                          // Campo para editar el precio
                          TextField(
                            controller: _precioController,
                            decoration: const InputDecoration(labelText: 'Precio'),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          // Campo para editar la URL de la imagen
                          TextField(
                            controller: _imagenController,
                            decoration: const InputDecoration(labelText: 'Imagen URL'),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      // Botón de cancelar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);  // Cerrar el formulario sin hacer cambios
                        },
                        child: const Text('Cancelar'),
                      ),
                      // Botón de guardar cambios
                      TextButton(
                        onPressed: () async {
                          // Crear el Kit actualizado
                          final updatedKit = Kit(
                            id: widget.kit.id,
                            nombre: _nombreController.text,
                            precio: _precioController.text,
                            imagen: _imagenController.text,
                          );

                          // Actualizar el Kit en Firebase a través de KitProvider
                          await kitProvider.updateKit(updatedKit);

                          // Volver a la pantalla anterior
                          Navigator.pop(context);  // Cerrar el formulario
                          context.pop();  // Volver a la pantalla anterior
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la imagen del Kit
            Image.network(widget.kit.imagen, errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);  // Si la imagen no carga, muestra un ícono
            }),
            const SizedBox(height: 16),
            // Mostrar los detalles del Kit (nombre, precio)
            Text(
              'Nombre: ${widget.kit.nombre}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Precio: ${widget.kit.precio}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
