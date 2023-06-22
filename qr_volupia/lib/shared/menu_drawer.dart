import 'package:flutter/material.dart';
import 'package:qr_volupia/screens/management_screen.dart';
import '../main.dart';
import '../screens/home_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> menuTitles = [];
    menuTitles = ["Home", "Deelnemers"];

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.red[700] : Colors.red[200],
            ),
            child: Center(
              child: Image.asset(
                "assets/VolupiaLogo_WIT.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: makeDrawerContent(context, menuTitles),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> makeDrawerContent(
      BuildContext context, List<String> menuTitles) {
    final ThemeData theme = Theme.of(context);
    List<Widget> menuItems = [];

    for (String menuItem in menuTitles) {
      Widget screen = Container();
      menuItems.add(ListTile(
        leading: getIcon(menuItem, context.isDarkMode),
        title: Text(menuItem,
            style: theme.textTheme.headlineMedium!
                .copyWith(color: Colors.red.shade400, fontSize: 24)),
        onTap: () {
          screen = getScreen(menuItem);
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ));
    }
    return menuItems;
  }

  Icon getIcon(String menuItem, bool isDarkMode) {
    late IconData returnIcon;
    switch (menuItem) {
      case "Home":
        returnIcon = Icons.home;
        break;
      case "Deelnemers":
        returnIcon = Icons.groups;
        break;
      default:
        returnIcon = Icons.question_mark;
        break;
    }
    return Icon(
      returnIcon,
      color: isDarkMode ? Colors.red[700] : Colors.redAccent,
      size: 35,
    );
  }

  Widget getScreen(String menuItem) {
    switch (menuItem) {
      case "Home":
        return const HomeScreen();
      case "Deelnemers":
        return const ManagementScreen();
      default:
        return const HomeScreen();
    }
  }
}
