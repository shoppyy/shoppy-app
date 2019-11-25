import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:listassist/assets/custom_icons_icons.dart';
import 'package:listassist/models/ShoppingList.dart';
import 'package:listassist/models/User.dart';
import 'package:listassist/services/date_formatter.dart';
import 'package:listassist/services/db.dart';
import 'package:listassist/services/info-overlay.dart';
import 'package:provider/provider.dart';
import 'package:listassist/models/CompletedShoppingList.dart';

class CompletedShoppingListDetail extends StatefulWidget {
  final int index;
  CompletedShoppingListDetail({this.index});

  @override
  _CompletedShoppingListDetailState createState() => _CompletedShoppingListDetailState();
}

class _CompletedShoppingListDetailState extends State<CompletedShoppingListDetail> {

  String _newName = "";

  @override
  Widget build(BuildContext context) {
    CompletedShoppingList list = Provider.of<List<CompletedShoppingList>>(context)[this.widget.index];
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(list.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text("Einkauf am ${DateFormatter.getDate(list.completed.toDate())} erledigt", style: Theme.of(context).textTheme.headline)
          ),
          Expanded(
              child: ListView.builder(
                itemCount: list.items.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: Icon(Icons.check),
                    title: Text("${list.items[index].name}", style: TextStyle(fontSize: 16))
                  );
                }
              )
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.easeIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.35,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(CustomIcons.content_copy),
            backgroundColor: Colors.green,
            label: "Copy to new",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              ShoppingList newList;
              await _showCreateCopyDialog();
              if(_newName != null && _newName != "" && _newName.trim() != "") {
                newList = list.createNewCopy(_newName);
              }else {
                newList = list.createNewCopy();
              }

              databaseService.createList(user.uid, newList).then((onComplete) {
                InfoOverlay.showInfoSnackBar("Einkaufsliste wurde erfolgreich Kopiert");
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.picture_as_pdf),
            backgroundColor: Colors.red,
            label: "Export as PDF",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateCopyDialog() async {
    TextEditingController _controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Einkaufsliste kopieren"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: new InputDecoration(
                    hintText: "Neuer Einkaufslistenname"
                  ),
                  keyboardType: TextInputType.text,
                ),
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
              child: Text("Neue Einkaufsliste erstellen"),
              onPressed: () {
                _newName = _controller.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}