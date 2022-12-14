import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/constants.dart' as Constants;

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({@required this.parentContext}) {}

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState(parentContext: parentContext);
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  final BuildContext parentContext;

  NavigationDrawerState({@required this.parentContext}) {}

  Map drawerItems = {};
  Map uniServicesItems = {};

  @override
  void initState() {
    super.initState();

    drawerItems = {
      Constants.navPersonalArea: _onSelectPage,
      Constants.navSchedule: _onSelectPage,
      Constants.navExams: _onSelectPage,
      Constants.navStops: _onSelectPage,
      Constants.navServices: _onSelectPage,
      Constants.navMap: _onSelectPage,
      Constants.navReminders: _onSelectPage,
      Constants.navAbout: _onSelectPage,
      Constants.navBugReport: _onSelectPage,
    };

    uniServicesItems = {Constants.navServices: _onSelectPage,
      Constants.navMap: _onSelectPage,
      Constants.navReminders: _onSelectPage,
    };
  }

  // Callback Functions
  getCurrentRoute() => ModalRoute.of(parentContext).settings.name == null
      ? drawerItems.keys.toList()[0]
      : ModalRoute.of(parentContext).settings.name.substring(1);

  _onSelectPage(String key) {
    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != key) {
      Navigator.pushNamed(context, '/' + key);
    }
  }

  _onLogOut(String key) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/' + key, (Route<dynamic> route) => false);
  }

  // End of Callback Functions

  Decoration _getSelectionDecoration(String name) {
    return (name == getCurrentRoute())
        ? BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).accentColor, width: 3.0)),
            color: Theme.of(context).dividerColor,

          )
        : null;
  }

  Widget createLogoutBtn() {
    return OutlinedButton(
      onPressed: () => _onLogOut(Constants.navLogOut),
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.all(0.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(Constants.navLogOut,
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Theme.of(context).accentColor)),
      ),
    );
  }

  Widget createDrawerNavigationOption(String d) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return Container(
        decoration: _getSelectionDecoration(d),
        child: ListTile(
          trailing: (uniServicesItems.containsKey(d))
            ? SvgPicture.asset(
            'assets/images/ni_logo.svg',
            color: Colors.cyan,
            width: queryData.size.height / 16,
            height: queryData.size.height / 16,
            )
            : null,
          title: Container(
            padding: EdgeInsets.only(bottom: 3.0, left: 20.0),
            child: Text(d,
                style: TextStyle(
                    fontSize: 18.0,
                    color: (uniServicesItems.containsKey(d))
                    ? Colors.cyan
                    : Theme.of(context).accentColor,
                    fontWeight: FontWeight.normal)),
          ),
          dense: true,
          key: Key('key_$d'), //BMCL
          contentPadding: EdgeInsets.all(0.0),
          selected: d == getCurrentRoute(),
          onTap: () => drawerItems[d](d),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptions = [];

    for (var key in drawerItems.keys) {
      drawerOptions.add(createDrawerNavigationOption(key));
    }

    return Drawer(
        key: const Key('menu'), //BMCL
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.only(top: 55.0),
          child: ListView(
            children: drawerOptions,
          ),
        )),
        Row(children: <Widget>[Expanded(child: createLogoutBtn())], )
      ],
    ));

  }
}
