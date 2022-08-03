import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logif/page/app_info_page.dart';
import 'package:logif/page/home_page.dart';
import 'package:logif/page/logged_in_widget.dart';
import 'package:logif/page/profile_widget.dart';
import 'package:logif/page/ranking_page.dart';
import 'package:logif/provider/google_sign_in.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: AppTheme.colors.purple,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: user.photoURL!,
              name: user.displayName!,
              email: user.email!,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()))
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home_outlined,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  addVerticalSpace(16),
                  buildMenuItem(
                    text: 'Meu Perfil',
                    icon: Icons.person_outline,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  addVerticalSpace(16),
                  buildMenuItem(
                    text: 'Ranking',
                    icon: Icons.flag_outlined,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  addVerticalSpace(16),
                  buildMenuItem(
                    text: 'Informações',
                    icon: Icons.info_outline,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  addVerticalSpace(24),
                  Divider(color: AppTheme.colors.light),
                  addVerticalSpace(24),
                  buildMenuItem(
                    text: 'Desconectar',
                    icon: Icons.logout_outlined,
                    onClicked: () => selectedItem(context, 4),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildHeader({
    required String urlImage,
    required String name,
    required String email,
    VoidCallback? onClicked,
  }) => InkWell(
    onTap: onClicked,
    child: Container(
      padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(urlImage),
          ),
          addHorizontalSpace(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTheme.typo.title,
              ),
              addVerticalSpace(4),
              Text(
                email,
                style: AppTheme.typo.littleText,
              )
            ],
          ),
        ],
      ),
    )
  );

  buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = AppTheme.colors.light;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: AppTheme.typo.sidebarMenuItem,
      ),
      style: ListTileStyle.drawer,
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoggedInMainPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RankingPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppInfoPage(),
        ));
        break;
      case 4:
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.logout();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        break;
    }
  }
}