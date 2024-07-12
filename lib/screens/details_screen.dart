import 'package:flutter/material.dart';
import '../entities/kit.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  static const name = 'Details';

  final Kit kit;

  const DetailsScreen({super.key, required this.kit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kit.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Image.asset(kit.imagen),
          Text('${kit.nombre} ${kit.precio}'),
        ],
      ),
    );
  }
}
