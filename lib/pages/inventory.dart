import 'dart:io';

import 'package:flutter/material.dart';
import '../HomeDrawer.dart';
import '../InventoryData.dart';
import 'inventoryModify.dart';

class Inventory extends StatefulWidget {
  @override
  InventoryState createState() => new InventoryState();
}

class InventoryState extends State<Inventory> {

  var _loadedInv = false;

  loadInventory () async {
    await inventory.load();
    setState(() { _loadedInv = true; });
  }

  body () {
    if (_loadedInv) {
      if (inventory.items.length < 1) {
        return new Center(
          child: new Text('You have no inventory yet', style: new TextStyle(fontSize: 20.0),));
      } else {
        return _inventoryWidget();
      }
    } else {
      return new Center(
        child: new CircularProgressIndicator()
      );
    }
  }

  _inventoryWidget () {
    return new ListView(
      children: inventory.items.map((InventoryItem item) {
        return new ListTile(
          title: new Text(item.name),
          subtitle: new Text(item.description),
          onTap: () { _toInventoryModify(inventory.items.indexOf(item), item); },
          isThreeLine: true,
          trailing: new Container(
            height: 80.0,
            width: 80.0,
            child: new Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: item.photos.getRange(0, item.photos.length > 2 ? 3 : item.photos.length).toList().reversed.map((photo) {
                return new Positioned(
                  right: 20.0*item.photos.indexOf(photo),
                  width: 60.0,
                  height: 60.0,
                  child: new Container(
                    child: new Image.file(new File(photo), fit: BoxFit.cover),
                    decoration: new BoxDecoration(
                      border: new Border(right: new BorderSide(
                        width: photo == item.photos.first ? 0.0 : 1.0,
                        color: Colors.white)
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  _toInventoryModify (int index, InventoryItem item) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => new InventoryModify(index, item)
      )
    );
  }

  _toInventoryCreate () {
    Navigator.of(context).push(
      new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => new InventoryModify(null, null),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!_loadedInv) loadInventory();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Inventory'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.signal_wifi_off), onPressed: null),
        ],
      ),
      drawer: new HomeDrawer('/inventory'),
      body: body(),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add',
        child: new Icon(Icons.add),
        onPressed: _toInventoryCreate,
      ),
    );
  }

}
