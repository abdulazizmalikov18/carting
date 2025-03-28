import 'package:flutter/material.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({super.key});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transport qo‘shish")),
    );
  }
}
