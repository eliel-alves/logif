import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/navigation_drawer_widget.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Ranking'),
        centerTitle: true,
      ),
    );
  }
}