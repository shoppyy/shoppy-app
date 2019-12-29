import 'package:custom_navigator/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:listassist/models/Group.dart';
import 'package:listassist/models/User.dart';
import 'package:listassist/services/db.dart';
import 'package:listassist/widgets/group/group_view.dart';
import 'package:listassist/models/current-screen.dart';
import 'package:listassist/services/auth.dart';
import 'package:listassist/widgets/settings/settings_view.dart';
import 'package:listassist/widgets/invites/invite_view.dart';
import 'package:listassist/widgets/shoppinglist/shopping_list_view.dart';
import 'package:provider/provider.dart';


class Sidebar extends StatefulWidget {
  @override
  _Sidebar createState() => _Sidebar();
}
class _Sidebar extends State<Sidebar> {

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: Text(user.displayName),
            accountEmail: Text(user.email),
            currentAccountPicture: Hero(
              tag: "profilePicture",
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Einkaufslisten"),
            onTap: () {
              ScreenModel.of(context).setScreen(MultiProvider(
                  providers: [
                    StreamProvider.value(value: databaseService.streamLists(user.uid)),
                    StreamProvider.value(value: databaseService.streamListsHistory(user.uid))
                  ],
                  child: CustomNavigator(
                    home: ShoppingListView(),
                    pageRoute: PageRoutes.materialPageRoute,
                  )
              ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text("Statistiken"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text("Angebote"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Gruppen"),
            onTap: () {
              ScreenModel.of(context).setScreen(StreamProvider<List<Group>>.value(
                value: databaseService.streamGroupsFromUser(user.uid),
                child: CustomNavigator(
                  home: GroupView(),
                  pageRoute: PageRoutes.materialPageRoute,
                )
              ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Einladungen"),
            onTap: () {
              ScreenModel.of(context).setScreen(InviteView());
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsView()));
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Logout"),
            onTap: () {
              authService.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }
}
