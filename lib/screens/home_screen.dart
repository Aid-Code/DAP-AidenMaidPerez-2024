import 'package:app_idx/entities/kit.dart';
import 'package:app_idx/screens/arduinouno_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const name = 'HomeScreen';

  final List<Kit> kits = [
    Kit('Arduino Uno', '\$19.999',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Arduino-uno-perspective-transparent.png/1164px-Arduino-uno-perspective-transparent.png'),
    Kit('Arduino Mega', '\$46.080',
        'https://static.wixstatic.com/media/c2df3c_aae97bb9244f409d9c32f7735151e28c~mv2.png/v1/fill/w_480,h_480,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/c2df3c_aae97bb9244f409d9c32f7735151e28c~mv2.png'),
    Kit('Arduino Nano', '\$9.500',
        'https://www.mouser.hn/images/marketingid/2022/img/166335835.png?v=071923.0931'),
    Kit('ESP 32', '\$12.000',
        'https://joy-it.net/files/files/Produkte/SBC-NodeMCU-ESP32/SBC-NodeMCU-ESP32-01.png'),
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
                leading: Image.network(kits[index].imagen),
                onTap: () {
                  if (kits[index].nombre == 'Arduino Uno') {
                    context.pushNamed(ArduinoUno.name, extra: kits[index]);
                  }
                },
              ));
            }));
  }
}
