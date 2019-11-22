import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:listassist/main.dart';
import 'package:listassist/models/ShoppingList.dart' as model;
import 'package:listassist/models/User.dart';
import 'package:listassist/services/db.dart';
import 'package:listassist/widgets/authentication/authentication.dart';
import 'package:listassist/widgets/shoppinglist/shopping-list.dart';
import 'package:listassist/widgets/shoppinglist/add-shoppinglist.dart';
import 'package:provider/provider.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    List<Widget> listItem = List();
//    listItem.add(ShoppingList(title: "Automatische Einkaufsliste", total: 18, bought: 0,));
//    listItem.add(ShoppingList(title: "Grillen am Wochenende", total: 4, bought: 3,));
//    listItem.add(ShoppingList());

    User user = Provider.of<User>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddShoppinglist()));
          },
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Einkaufslisten"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Zu erledigen",),
              Tab(text: "Erledigt")
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Open navigation menu",
            onPressed: () => mainScaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: TabBarView(
          children: [
            ShoppingLists(),
            Text("VERLAUF DER EINKAUFSLISTEN"),
          ],
        ),
      )
    );
  }
}

class ShoppingLists extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    List<model.ShoppingList> lists = Provider.of<List<model.ShoppingList>>(context);
    return lists != null ? ListView.separated(
        separatorBuilder: (ctx, i) => Divider(
          indent: 10,
          endIndent: 10,
          color: Colors.grey,
        ),
        itemCount: lists.length,
        itemBuilder: (ctx, index) => ShoppingList(index: index)
    ) : SpinKitDoubleBounce(color: Colors.blueAccent,);
  }
}