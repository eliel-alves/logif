import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  int i = 0;

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> _getUsers() {
      return FirebaseFirestore.instance
                .collection('users')
                .orderBy('score', descending: true)
                .snapshots();
    }

    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Ranking de Usuários'),
          titleTextStyle: AppTheme.typo.scaffoldTitle,
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text('Carregando', style: AppTheme.typo.title),
                        addVerticalSpace(20),
                        const CircularProgressIndicator()
                      ]));
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());

                    return const Text(
                        'Ocorreu algum erro ao tentar recuperar o ranking');
                  } else if (snapshot.hasData) {
                    i = 0;

                    // Todos os docs
                    final data = snapshot.data!;

                    // Index do Jogador Logado
                    var currentUserIndex = 0;
                    var ind = 0;

                    // Descobrindo a posicao do usuario atual
                    for (var doc in data.docs) {
                      if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
                        currentUserIndex = ind;
                      } else {
                        ind++;
                      }
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Total de usuários: ' + snapshot.data!.size.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            )
                          )
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              debugPrint('index: ' + index.toString());
                              if (index >= 1) {
                                debugPrint('Maior q um');
                                if (data.docs[index]['score'] ==
                                    data.docs[index - 1]['score']) {
                                  debugPrint('Igual');
                                  debugPrint(
                                      'posicao: ' + (index + 1).toString());
                                } else {
                                  i++;
                                  debugPrint(
                                      'posicao: ' + (index + 1).toString());
                                }
                              }

                              return buildUserScore(
                                index,
                                context,
                                data.docs[index]['url_photo'],
                                data.docs[index]['name'],
                                data.docs[index]['score']
                              );
                            })),
                        buildAtualUserPosition(currentUserIndex,
                            data.docs[currentUserIndex]['score'])
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              }
            }));
  }
}

Widget buildUserScore(
  userIndex, context, userPhoto, userName, userScore
) {
  var medal = const TextStyle(fontSize: 30);

  return Card(
    margin: const EdgeInsets.only(bottom: 15.0),
    color: AppTheme.colors.darkBackgroundVariation,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: userIndex == 0
                  ? Colors.amber
                  : userIndex == 1
                      ? Colors.grey
                      : userIndex == 2
                          ? Colors.brown
                          : AppTheme.colors.darkBackgroundVariation,
              width: userIndex == 0
                  ? 2
                  : userIndex == 1
                      ? 2
                      : userIndex == 2
                          ? 2
                          : 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15)),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                child: CircleAvatar(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  NetworkImage(userPhoto),
                            )))),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userName,
                          style: AppTheme.typo.normalBold,
                          maxLines: 6,
                        )),
                    Text("Pontos Totais: " + userScore.toString(),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Inter',
                            fontSize: 15)),
                  ],
                ),
              ),
              const Spacer(),
              userIndex == 0
                  ? Text("🥇", style: medal)
                  : userIndex == 1
                      ? Text("🥈", style: medal)
                      : userIndex == 2
                          ? Text("🥉", style: medal)
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text((userIndex + 1).toString() + 'º',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildAtualUserPosition(int userIndex, int userScore) {
  return Card(
      color: AppTheme.colors.purple,
      margin: const EdgeInsets.all(0),
      elevation: 5,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 30,
                color: Colors.deepPurple.shade100,
              ),
              addHorizontalSpace(10),
              Text('Sua posição: ', style: AppTheme.typo.normalBold),
              userIndex == 0
                  ? const Text('🥇', style: TextStyle(fontSize: 25))
                  : userIndex == 1
                      ? const Text('🥈', style: TextStyle(fontSize: 25))
                      : userIndex == 2
                          ? const Text('🥉', style: TextStyle(fontSize: 25))
                          : Text((userIndex + 1).toString() + 'º',
                              style: AppTheme.typo.normalBold),
              const Spacer(),
              Icon(
                Icons.workspace_premium_outlined,
                size: 30,
                color: Colors.deepPurple.shade100,
              ),
              addHorizontalSpace(10),
              Text(userScore.toString() + ' Pontos Totais',
                  style: AppTheme.typo.normalBold),
            ],
          )));
}
