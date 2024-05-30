import 'package:app_idx/screens/arduinouno_screen.dart';
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4018608794.
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const name = 'HomeScreen';
  String userName;

  final List<Map<String, String>> placas = [
    {
      'Nombre': 'Arduino Uno',
      'Precio': '\$19.999',
      'Imagen':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Arduino-uno-perspective-transparent.png/1164px-Arduino-uno-perspective-transparent.png'
    },
    {
      'Nombre': 'Arduino Mega',
      'Precio': '\$46.080',
      'Imagen':
          'https://static.wixstatic.com/media/c2df3c_aae97bb9244f409d9c32f7735151e28c~mv2.png/v1/fill/w_480,h_480,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/c2df3c_aae97bb9244f409d9c32f7735151e28c~mv2.png'
    },
    {
      'Nombre': 'Arduino Nano',
      'Precio': '\$9.500',
      'Imagen':
          'https://www.mouser.hn/images/marketingid/2022/img/166335835.png?v=071923.0931'
    },
    {
      'Nombre': 'ESP 32',
      'Precio': '\$12.000',
      'Imagen':
          'https://joy-it.net/files/files/Produkte/SBC-NodeMCU-ESP32/SBC-NodeMCU-ESP32-01.png'
    }
  ];

  HomeScreen({super.key, required this.userName});

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
            itemCount: placas.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(placas[index]['Nombre']!),
                subtitle: Text(placas[index]['Precio']!),
                leading: Image.network(placas[index]['Imagen']!),
                onTap: () {
                  if (placas[index]['Nombre'] == 'Arduino Uno') {
                    context.pushNamed(ArduinoUno.name);
                  }
                },
              ));
            }));
  }
}
