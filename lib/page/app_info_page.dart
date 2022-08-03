import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/navigation_drawer_widget.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Sobre o App'),
        centerTitle: true,
      ),
    );
  }
}