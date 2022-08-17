import 'package:flutter/material.dart';
import 'package:logif/page/quiz_page.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Teste Quiz'),
          centerTitle: true,
        ),
        body: const StartQuiz());
  }
}

class StartQuiz extends StatelessWidget {
  const StartQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: AppTheme.buttons.buttonPrimary,
        child: const Text('Iniciar Quiz'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Quiz(),
          ));
        },
      ),
    );
  }
}
