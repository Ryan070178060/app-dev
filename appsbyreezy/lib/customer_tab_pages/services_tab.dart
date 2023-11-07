import 'package:flutter/material.dart';


class ServicesTabPage extends StatefulWidget {
  const ServicesTabPage({super.key});

  @override
  State<ServicesTabPage> createState() => _ServicesTabPageState();
}

class _ServicesTabPageState extends State<ServicesTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Services",
      ),
    );
  }
}