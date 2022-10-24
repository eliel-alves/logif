// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logif/model/card.dart';
import 'package:logif/page/quiz_page.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class CardPage extends StatefulWidget {
  final DocumentSnapshot category;

  const CardPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final currentOrder = 1;

  @override
  Widget build(BuildContext context) {
    String categoryName = widget.category['name'];
    Size size = MediaQuery.of(context).size;
    DocumentSnapshot doc = widget.category;

    return StreamBuilder<QuerySnapshot>(
      stream: getCards(),
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Não possui nenhum card!'));
            }

            List<CategoryCard> cards = List.generate(
                snapshot.data!.docs.length,
                (index) => CategoryCard(
                    content: snapshot.data!.docs[index]['content'],
                    order: snapshot.data!.docs[index]['order'],
                    urlButton: snapshot.data!.docs[index]['url_button']));

            return SizedBox(
                height: size.height,
                width: size.width,
                child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 60,
                      title: Text(categoryName),
                      titleTextStyle: AppTheme.typo.scaffoldTitle,
                      centerTitle: true,
                    ),
                    body: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        //final DocumentSnapshot doc = snapshot.data!.docs[index];

                        return BuildCards(
                            index: index,
                            cards: cards,
                            categoryName: categoryName,
                            doc: doc);
                      },
                    )));
        }
      },
    );
  }

  getCards() {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.category.id)
        .collection('cards')
        .orderBy('order')
        .snapshots();
  }
}

class BuildCards extends StatefulWidget {
  final List<CategoryCard> cards;
  final String categoryName;
  final DocumentSnapshot doc;
  int index;

  BuildCards(
      {Key? key,
      required this.index,
      required this.cards,
      required this.categoryName,
      required this.doc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BuildCardsState();
}

class _BuildCardsState extends State<BuildCards> {
  @override
  Widget build(BuildContext context) {
    // Verifica se usuario visualizou todos os cards
    if (widget.index != widget.cards.length) {
      return Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Badge(
                padding: const EdgeInsets.all(10),
                badgeContent: Text(
                  'CARD ' +
                      widget.cards[widget.index].order.toString() +
                      '/' +
                      widget.cards.length.toString(),
                  style: AppTheme.typo.badgeText,
                ),
                toAnimate: false,
                shape: BadgeShape.square,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                badgeColor: AppTheme.colors.green,
              ),
              Html(data: widget.cards[widget.index].content, style: _styleHtml),
              // Só exibe o botão do card caso tenha alguma URL inserida
              widget.cards[widget.index].urlButton == ''
                  ? addVerticalSpace(5)
                  : Column(children: [
                      addVerticalSpace(20),
                      const Text(
                          'O conteúdo dos cards acaba por aqui, mas ainda não foi o suficiente?'),
                      addVerticalSpace(5),
                      const Text(
                          'Não se preocupe, clicando no botão abaixo você pode assistir um vídeo pra estudar ainda mais sobre o assunto!'),
                      addVerticalSpace(20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _launchLinkButton(
                                  widget.cards[widget.index].urlButton);
                            },
                            style: AppTheme.buttons.cardButton,
                            label: const Text('Ver Mais'),
                            icon: const Icon(Icons.link)),
                      )
                    ])
            ]),
          )),

          // Footer
          Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
              ),
              color: AppTheme.colors.darkBackgroundVariation,
              width: double.maxFinite,
              child: IntrinsicHeight(
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton.icon(
                        style: AppTheme.buttons.navigationButton,
                        label: const Text('Anterior'),
                        icon: const Icon(Icons.keyboard_arrow_left_outlined),
                        onPressed: () {
                          setState(() {
                            if (widget.index != 0) {
                              widget.index--;
                            }
                          });
                        },
                      ),
                      VerticalDivider(
                          color: AppTheme.colors.darkBackgroundVariation,
                          width: 1,
                          thickness: 2),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          style: AppTheme.buttons.navigationButton,
                          label: const Text('Próximo'),
                          icon: const Icon(Icons.keyboard_arrow_right_outlined),
                          onPressed: () {
                            setState(() {
                              if (widget.index != widget.cards.length) {
                                widget.index++;
                              }
                            });
                          },
                        ),
                      )
                    ]),
              ))
        ],
      );
    }

    // Tela de Pre-quiz
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            addSpace(),
            Badge(
              padding: const EdgeInsets.all(10),
              badgeContent: Text(
                'QUIZ',
                style: AppTheme.typo.badgeText,
              ),
              toAnimate: false,
              shape: BadgeShape.square,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              badgeColor: AppTheme.colors.blue,
            ),
            addVerticalSpace(10),
            Text(
              widget.categoryName,
              style: AppTheme.typo.quizTitle,
            ),
            addVerticalSpace(20),
            Text(
              'Após estudar os conceitos, está na hora de certificar de que você aprendeu.\nVocê está prestes a responder um quiz contendo algumas perguntas sobre o assunto estudado.',
              style: AppTheme.typo.normal,
              textAlign: TextAlign.center,
            ),
            addVerticalSpace(10),
            Text('E aí, está preparado?', style: AppTheme.typo.subtitle),
            addVerticalSpace(40),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.buttons.buttonPrimary,
                  child: const Text('Sim, estou!'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Quiz(doc: widget.doc),
                    ));
                  },
                )),
            addVerticalSpace(10),
            primaryFullButton('Ainda não, preciso estudar mais', () {
              widget.index = 0;
              Navigator.of(context).pop();
            }),
            addSpace()
          ],
        ));
  }

  final Map<String, Style> _styleHtml = {
    "p": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
    ),
    "body": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
    ),
    "h4": Style(fontSize: const FontSize(18)),
    "table": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
      border: const Border(
        bottom: BorderSide(color: Colors.grey), 
        left: BorderSide(color: Colors.grey),
        right: BorderSide(color: Colors.grey),
        top: BorderSide(color: Colors.grey),
        ),
    ),
    "td": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
    ),
    "tr": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
    ),
    "th": Style(
      fontFamily: 'Inter',
      fontSize: const FontSize(16),
    )
  };
}

Future<void> _launchLinkButton(String url) async {
  final Uri _url = Uri.parse(url);

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}
