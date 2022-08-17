import 'package:flutter/material.dart';
import 'package:logif/provider/google_sign_in.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          addSpace(),
          Image.asset('lib/assets/images/logo-do-app-dark-v2.png', width: 200),
          addVerticalSpace(20),
          Align(
            alignment: Alignment.center,
            child: Text('Aprenda lógica e programação de maneira simples.',
                style: AppTheme.typo.subtitle, textAlign: TextAlign.center),
          ),
          addVerticalSpace(60),
          SocialLoginButton(
            text: 'Conectar-se com Google',
            borderRadius: 10,
            buttonType: SocialLoginButtonType.google,
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
          addVerticalSpace(20),
          addSpace(),
          const TextButton(
              onPressed: _launchUrlGithub,
              child: Text('App desenvolvido por Eliel Alves')),
        ]));
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
