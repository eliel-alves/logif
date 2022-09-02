import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logif/databases/firestore_databases.dart';
import 'package:logif/page/quiz_result_page.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/model/question.dart';

class Quiz extends StatefulWidget {
  Quiz({Key? key, required this.doc}) : super(key: key);

  late List<Question> questions = [];
  final DocumentSnapshot doc;

  @override
  State<Quiz> createState() => _QuizState();
}

List<Question> shuffle(List<Question> shuffleList, List<dynamic> json) {
  debugPrint('Criou lista de perguntas');
  debugPrint(shuffleList.length.toString());

  // Limpa lista antiga
  shuffleList.clear();

  for (var question in json) {
    // Indice da resposta correta
    int correctIndex = question['correct_answer'];

    // Respostas da pergunta
    List answers = question['answers'];

    // String da resposta correta
    String correctAnswer = question['answers'][correctIndex - 1];

    // Embaralhando alternativas
    answers.shuffle();

    // Encontra a nova resposta correta
    int i = 1;
    for (var answer in answers) {
      if (answer == correctAnswer) {
        correctIndex = i;
      }

      i++;
    }
    question['correct_answer'] = correctIndex;

    // Adiciona pergunta com respostas embaralhadas a lista
    shuffleList.add(Question.fromMap(question));
  }

  debugPrint('embaralhou');

  for (var question in shuffleList) {
    debugPrint(question.question);
  }

  return shuffleList;
}

class _QuizState extends State<Quiz> {
  int questionNumber = 1;
  int corrects = 0;
  int errors = 0;
  List<Question> questionList = [];

  @override
  Widget build(BuildContext context) {
    void answered(int answerIndex) {
      debugPrint('pergunta $questionNumber and ${questionList.length}');
      setState(() {
        if (questionList[questionNumber - 1].correctAnswer == answerIndex) {
          debugPrint('acertou pergunta $questionNumber');
          corrects++;
        } else {
          errors++;
        }

        // debugPrint('acertos totais: $corrects erros totais: $errors');

        if (questionNumber == questionList.length) {
          // debugPrint('terminou o quiz');
          Navigator.pushNamed(context, '/results',
              arguments: Arguments(corrects, questionList.length, widget.doc));
        } else {
          questionNumber++;
        }
      });
    }

    Future<List<Question>>? _getQuestions() async {
      debugPrint('entrou');
      final FirebaseFirestore db = FirestoreDatabase.get();
      List<Question> list = [];

      final subCollQuerySnapshot = await db
          .collection('categories')
          .doc(widget.doc.id)
          .collection('questions')
          .get();

      debugPrint('pegou as questions');

      for (var subCollDoc in subCollQuerySnapshot.docs) {
        list.add(Question.fromMap(subCollDoc.data()));
        debugPrint('add 1');
      }

      debugPrint('adicionou na lista');
      // return data.docs.map<Question>(Question.fromJson).toList();
      // return subCollQuerySnapshot.docs.map<Question>((json) => Question.fromJson(json as Map<String, dynamic>)).toList();

      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.doc.get('name')}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Question>>(
              future: _getQuestions(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final questions = snapshot.data!;
                      List temp = [];

                      for (var q in questions) {
                        temp.add(q.toJson());
                        debugPrint(temp.toString());
                      }

                      questionList = shuffle(questions, temp);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Badge(
                            padding: const EdgeInsets.all(10),
                            badgeContent: Text(
                              'PERGUNTA $questionNumber de ${questionList.length}',
                              style: AppTheme.typo.badgeText,
                            ),
                            toAnimate: false,
                            shape: BadgeShape.square,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            badgeColor: AppTheme.colors.green,
                          ),
                          addVerticalSpace(20),
                          Text(
                            'Pergunta:\n' +
                                questionList[questionNumber - 1].question,
                            style: AppTheme.typo.subtitle,
                          ),
                          addVerticalSpace(50),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    answered(1);
                                  },
                                  style: AppTheme.buttons.buttonSecondary,
                                  child: Text(questionList[questionNumber - 1]
                                      .answers[0]))),
                          addVerticalSpace(20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    answered(2);
                                  },
                                  style: AppTheme.buttons.buttonSecondary,
                                  child: Text(questionList[questionNumber - 1]
                                      .answers[1]))),
                          addVerticalSpace(20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    answered(3);
                                  },
                                  style: AppTheme.buttons.buttonSecondary,
                                  child: Text(questionList[questionNumber - 1]
                                      .answers[2]))),
                          addVerticalSpace(20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    answered(4);
                                  },
                                  style: AppTheme.buttons.buttonSecondary,
                                  child: Text(questionList[questionNumber - 1]
                                      .answers[3]))),
                        ],
                      );
                    } else {
                      return const Text('Sem informações');
                    }
                }
              })),
    );
  }
}
