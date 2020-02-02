import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listassist/models/User.dart';
import 'package:listassist/services/db.dart';
import 'package:listassist/services/info_overlay.dart';
import 'package:listassist/widgets/shoppinglist/shopping_list_detail.dart';
import 'package:listassist/models/ShoppingList.dart' as model;
import 'package:provider/provider.dart';
import 'edit_shopping_list.dart';


class ShoppingList extends StatefulWidget {
  final int index;
  ShoppingList({this.index});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  model.ShoppingList list;

  @override
  Widget build(BuildContext context) {
    list = Provider.of<List<model.ShoppingList>>(context)[widget.index];
    //print(list);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShoppingListDetail(index: widget.index)),
      ),
      onLongPressStart: (details) async {
        RenderBox overlay = Overlay.of(context).context.findRenderObject();
        dynamic picked = await showMenu(
          context: context,
          position: RelativeRect.fromRect(
              details.globalPosition & Size(10, 10), // smaller rect, the touch area
              Offset.zero & overlay.semanticBounds.size   // Bigger rect, the entire screen
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              value: 0,
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  Text("Bearbeiten"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete,),
                  Text("Löschen"),
                ],
              ),
            )
          ]
        );
        // Edit
        if(picked == 0){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditShoppingList(index: widget.index)),
          );
        // Delete
        }else if(picked == 1) {
          _showDeleteDialog();
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(list.name, style: Theme.of(context).textTheme.title),
              Text(list.items.length > 0 ? "${list.items.map((e) => e.bought ? 1 : 0).reduce((a, b) => a + b)}/${list.items.length} eingekauft" : "Keine Produkte vorhanden")
            ],
          ),
        ),
      )
    );
  }

  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Einkaufsliste löschen"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          color: Theme.of(context).textTheme.title.color,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Sind Sie sicher, dass Sie die Einkaufsliste "),
                          TextSpan(
                              text: "${list.name}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: " löschen möchten?")
                        ]))
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.red,
              child: Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Löschen"),
              onPressed: () {
                String name = list.name;
                databaseService.deleteList(Provider.of<User>(context).uid, list.id).catchError((_) {
                  InfoOverlay.showErrorSnackBar("Fehler beim Löschen der Einkaufsliste");
                }).then((_) {
                  InfoOverlay.showInfoSnackBar("Einkaufsliste $name gelöscht");
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}