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
  Color my = Colors.brown, checkMyColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var medal = const TextStyle(color: Colors.purpleAccent, fontSize: 30);

    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Ranking'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('score', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
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

                              return Card(
                                margin: const EdgeInsets.only(bottom: 15.0),
                                color: AppTheme.colors.darkBackgroundVariation,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: i == 0
                                              ? Colors.amber
                                              : i == 1
                                                  ? Colors.grey
                                                  : i == 2
                                                      ? Colors.brown
                                                      : AppTheme.colors
                                                          .darkBackgroundVariation,
                                          width: i == 0
                                              ? 2
                                              : i == 1
                                                  ? 2
                                                  : i == 2
                                                      ? 2
                                                      : 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 5, bottom: 5),
                                            child: CircleAvatar(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              data.docs[index][
                                                                  'url_photo']),
                                                        )))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      data.docs[index]['name'],
                                                      style:
                                                          AppTheme.typo.title,
                                                      maxLines: 6,
                                                    )),
                                                Text(
                                                    "Pontos: " +
                                                        data.docs[index]
                                                                ['score']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontFamily: 'Inter',
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          i == 0
                                              ? Text("🥇", style: medal)
                                              : i == 1
                                                  ? Text("🥈", style: medal)
                                                  : i == 2
                                                      ? Text("🥉", style: medal)
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Text(
                                                              (index + 1)
                                                                      .toString() +
                                                                  'º',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                    Card(
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
                                Text( 'Sua posição: ',
                                    style: AppTheme.typo.normalBold),
                                currentUserIndex == 0
                                  ? const Text('🥇',
                                      style: TextStyle(fontSize: 25)
                                    )
                                  : currentUserIndex == 1
                                  ? const Text('🥈',
                                      style: TextStyle(fontSize: 25)
                                    )
                                  : currentUserIndex == 2
                                  ? const Text('🥉',
                                      style: TextStyle(fontSize: 25)
                                    )
                                  : Text(
                                      (currentUserIndex+1).toString() + 'º',
                                      style: AppTheme.typo.normalBold
                                    ),
                                const Spacer(),
                                Icon(Icons.workspace_premium_outlined,
                                    size: 30,
                                    color: Colors.deepPurple.shade100,),
                                addHorizontalSpace(10),
                                Text(
                                    data.docs[currentUserIndex]['score']
                                            .toString() +
                                        ' Pontos',
                                    style: AppTheme.typo.normalBold),
                              ],
                            )))
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
