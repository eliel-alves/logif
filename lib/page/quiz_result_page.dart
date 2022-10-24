import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _readUser() async {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final user = FirebaseFirestore.instance.collection('users').doc(userId);
      final snapshot = await user.get();

      if (snapshot.exists) {
        return snapshot;
      }

      return null;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments as Arguments;

    debugPrint('Arguments: ' + arguments.toString());

    // if (arguments == null) {
    //   Navigator.pushNamed(context, '/');
    // }

    // Nome da categoria
    final catName = arguments.doc.get('name');
    // Índice da categoria (vetor de pontuações do usuário)
    final catIndex = arguments.doc.get('order');
    // Máximo de pontos
    final catMaxPoints = arguments.doc.get('value_points');

    // Calcula a pontuação atingida pelo usuário
    int earnedScore =
        ((catMaxPoints / arguments.total) * arguments.corrects).round();

    debugPrint('máximo de pontos' + catMaxPoints.toString());
    debugPrint('index da cat: ' + catIndex.toString());
    debugPrint('pontos ganhos: ' + earnedScore.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz: $catName'),
          titleTextStyle: AppTheme.typo.scaffoldTitle,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<DocumentSnapshot?>(
            future: _readUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    var userTotalScore = user!.get('score');
                    var userScores = user.get('scores');
                    bool higher;

                    // Caso a pontuação obtida seja maior que a pontuação do usuário
                    if (earnedScore > userScores[catIndex]) {
                      higher = true;

                      // Remove pontuação antiga da pontuação total
                      userTotalScore -= userScores[catIndex];
                      // Adiciona a pontuação obtida na pontuação total
                      userTotalScore += earnedScore;
                      // Adiciona a pontuação obtida no array de pontos
                      userScores[catIndex] = earnedScore;

                      debugPrint('pontuação total a ser adicionada: ' +
                          userTotalScore.toString());

                      // Atualiza informações no BD
                      user.reference.update(
                          {'score': userTotalScore, 'scores': userScores});
                      debugPrint('pontuação adicionada!');
                    } else {
                      higher = false;
                    }

                    return Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildResult(context, arguments.corrects,
                            arguments.total, earnedScore, higher));
                  } else {
                    return const Center(child: Text('Houve um erro'));
                  }
              }
            }));
  }
}

Widget _buildResult(context, corrects, total, score, higher) {
  const _normalText =
      TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w400);

  return Column(
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
      const Text(
        'Você acertou',
        style: _normalText,
      ),
      addVerticalSpace(5),
      Text(
        '$corrects de $total',
        style: _normalText,
      ),
      addVerticalSpace(5),
      const Text(
        'perguntas.',
        style: _normalText,
      ),
      addVerticalSpace(30),
      Badge(
        elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        badgeContent: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined,
                color: AppTheme.colors.purple, size: 30),
            addHorizontalSpace(5),
            Text(
              '+' + score.toString() + ' pontos',
              style: AppTheme.typo.subtitle,
            ),
          ],
        ),
        toAnimate: false,
        shape: BadgeShape.square,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        badgeColor: AppTheme.colors.lightPurple,
      ),
      higher
          ? const Text('')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  addVerticalSpace(30),
                  const Text(
                    'Observação: você já obteve pontuação maior nessa categoria, portanto'
                    ' sua pontuação não será atualizada!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  )
                ]),
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
  );
}
