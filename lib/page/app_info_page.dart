import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/buttons.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  final _buttonText = const TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      color: Color.fromARGB(255, 71, 83, 255));
  final _normalText = const TextStyle(
      fontFamily: 'Inter', height: 1.4, fontSize: 16, color: Colors.white70);
  final _boldText = const TextStyle(
      fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Sobre o App'),
          titleTextStyle: AppTheme.typo.scaffoldTitle,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção sobre infos do app
                Text('Sobre o Logif:', style: _boldText),
                addVerticalSpace(10),
                Text(
                    'Ferramenta open-source multiplataforma desenvolvida como parte da avaliação do Trabalho de Conclusão do curso de Bacharelado em Ciência da Computação. Tem como objetivo auxiliar alunos no processo de aprendizagem de lógica e conceitos de programação de computadores.',
                    style: _normalText),
                addVerticalSpace(40),


                // Dados sobre desenvolvedor, orientador e instituição
                Row(children: [
                  Text('Desenvolvedor: ', style: _boldText),
                  addHorizontalSpace(5),
                  Text('Eliel Alves da Silva', style: _normalText)
                ]),
                addVerticalSpace(10),
                Row(children: [
                  Text('Orientador: ', style: _boldText),
                  addHorizontalSpace(5),
                  Text('Adilso Nunes de Souza', style: _normalText)
                ]),
                addVerticalSpace(10),
                Row(children: [
                  Text('Coorientadora: ', style: _boldText),
                  addHorizontalSpace(5),
                  Text('Anubis Graciela de Moraes Rossetto', style: _normalText)
                ]),
                addVerticalSpace(10),
                Text(
                    'Instituto Federal de Educação Ciência e Tecnologia Sul-riograndense (IFSul) - Campus Passo Fundo',
                    style: _normalText),
                addVerticalSpace(40),


                // Seção sobre feedback
                Text('Gostou do aplicativo e deseja avaliar?',
                    style: _boldText),
                addVerticalSpace(10),
                Text(
                    'Se você gostou do aplicativo (ou não) e deseja contribuir com o seu feedback, basta clicar no botão abaixo que você será redirecionado para um questionário na plataforma Google Forms, lá você poderá descrever a sua experiência utilizando a aplicação. As informações desta pesquisa serão confidenciais, e serão divulgadas apenas em eventos ou publicações científicas, não havendo identificação das participantes, sendo assegurado o sigilo sobre sua participação.',
                    style: _normalText),
                addVerticalSpace(20),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: AppTheme.buttons.buttonPrimary,
                        child:
                            const Text('Clique aqui e envie o seu feedback!'),
                        onPressed: _launchFeedbackForm)),
                addVerticalSpace(40),


                // Seção sobre bugs e problemas encontradors
                Text('Encontrou algum erro, bug ou problema?',
                    style: _boldText),
                addVerticalSpace(10),
                Text(
                    'O aplicativo está em sua primeira versão, isso quer dizer que é possível que eventualmente algum usuário encontre falhas ou bugs. Você pode ajudar o desenvolvedor reportando o bug encontrado, para isso basta enviar um e-mail para o endereço "elielalves.cc@gmail.com". Recomendamos que envie um e-mail contendo um print do problema encontrado, desta forma fica mais fácil corrigir o problema. Se preferir, basta clicar no botão abaixo e você será automaticamente redirecionado para enviar um e-mail diretamente para o desenvolvedor.',
                    style: _normalText),
                addVerticalSpace(20),
                primaryFullButton('Relatar um problema', _launchUrlEmailToDev),
                addVerticalSpace(40),

                
                // Seção sobre ferramentas utilizadas
                Text('Ferramentas Utilizadas:', style: _boldText),
                addVerticalSpace(10),
                TextButton(
                    onPressed: _launchUrlFlutter,
                    child: Text(
                      'Flutter',
                      style: _buttonText,
                    )),
                addVerticalSpace(10),
                TextButton(
                    onPressed: _launchUrlFirebase,
                    child: Text(
                      'Google Firebase',
                      style: _buttonText,
                    )),
                addVerticalSpace(40),


                // Seção sobre o código fonte do app
                Text('Código Fonte:', style: _boldText),
                addVerticalSpace(10),
                TextButton(
                    onPressed: _launchUrlGithub,
                    child: Text(
                      'Github',
                      style: _buttonText,
                    )),
              ],
            )));
  }
}

Future<void> _launchUrlGithub() async {
  final Uri _url = Uri.parse('https://github.com/eliel-alves');

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}

Future<void> _launchFeedbackForm() async {
  final Uri _url = Uri.parse('https://forms.gle/RAdZgnTUC5eg6WA97');

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}

Future<void> _launchUrlFlutter() async {
  final Uri _url = Uri.parse('https://flutter.dev/');

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}

Future<void> _launchUrlFirebase() async {
  final Uri _url = Uri.parse('https://firebase.google.com/?hl=pt');

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}

Future<void> _launchUrlEmailToDev() async {
  final Uri _url = Uri.parse('mailto:elielalves.cc@gmail.com');

  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $_url';
  }
}
