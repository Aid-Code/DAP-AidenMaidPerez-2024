import 'package:app_idx/entities/kit.dart';
import 'package:app_idx/screens/details_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const name = 'HomeScreen';

  final List<Kit> kits = [
    Kit(
        nombre: 'Arduino Uno',
        precio: '\$19.999',
        imagen: 'assets/images/arduinouno_image.png'),
    Kit(
        nombre: 'Arduino Mega',
        precio: '\$46.080',
        imagen: 'assets/images/arduinomega_image.png'),
    Kit(
        nombre: 'Arduino Nano',
        precio: '\$9.500',
        imagen: 'assets/images/arduinonano_image.png'),
    Kit(
        nombre: 'ESP 32',
        precio: '\$12.000',
        imagen: 'assets/images/esp_image.png'),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
            itemCount: kits.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                      title: Text(kits[index].nombre),
                      subtitle: Text(kits[index].precio),
                      leading: Image.asset(kits[index].imagen),
                      onTap: () {
                        context.pushNamed(DetailsScreen.name,
                            pathParameters: {'kit': kits[index].nombre},
                            extra: kits[index]);
                      }));
            }));
  }
}
