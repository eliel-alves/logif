import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';

class Arguments {
  int corrects = 0;
  int total = 0;
  DocumentSnapshot doc;

  Arguments(this.corrects, this.total, this.doc);
}

class QuizResultPage extends StatelessWidget {
  static const routeName = '/results';
  const QuizResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Arguments;
    final catName = arguments.doc.get('name');

    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz: $catName'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                padding: const EdgeInsets.all(10),
                badgeContent: Text(
                  'QUIZ',
                  style: AppTheme.typo.badgeText,
                ),
                toAnimate: false,
                shape: BadgeShape.square,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                badgeColor: AppTheme.colors.green,
              ),
              addVerticalSpace(10),
              Text('Resultado', style: AppTheme.typo.title),
              addVerticalSpace(30),
              Text(
                'Parabéns, você acertou',
                style: AppTheme.typo.normal,
              ),
              addVerticalSpace(5),
              Text(
                '${arguments.corrects} de ${arguments.total}',
                style: AppTheme.typo.normalBold,
              ),
              addVerticalSpace(5),
              Text(
                'perguntas.',
                style: AppTheme.typo.normal,
              ),
              addVerticalSpace(30),
              Badge(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                badgeContent: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_outlined,
                        color: AppTheme.colors.purple, size: 30),
                    addHorizontalSpace(5),
                    Text(
                      '+50 pontos',
                      style: AppTheme.typo.subtitle,
                    ),
                  ],
                ),
                toAnimate: false,
                shape: BadgeShape.square,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                badgeColor: AppTheme.colors.lightPurple,
              ),
              addVerticalSpace(50),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => const HomePage(),
                        // ));
                        Navigator.pushNamed(context, '/');
                      },
                      style: AppTheme.buttons.buttonPrimary,
                      child: const Text('Entendido'))),
            ],
          ),
        )));
  }
}
