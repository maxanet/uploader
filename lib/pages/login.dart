import 'dart:async';

import 'package:flutter/material.dart';
import '../UserData.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {

  var _loadedInitials = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value),
        duration: const Duration(seconds: 3),
    ));
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Future _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please complete the login form');
    } else {
      showInSnackBar('Logging In..');
      form.save();
      await user.save();
      if (user.ftpValid == 'true') {
        Navigator.of(context).pushReplacementNamed('/inventories');
      } else {
        Navigator.of(context).pushReplacementNamed('/settings');
      }
    }
  }

  String _validateEmail(String value) {
    if (value.isEmpty)
      return 'Workgroup is required';
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty)
      return 'Password is required';
    return null;
  }

  void init() async {
    await user.load();
    setState(() { _loadedInitials = true; });
  }

  @override
  Widget build(BuildContext context) {

    if (!_loadedInitials) init();

    if (_loadedInitials) {
      return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(title: new Text('Login to Maxanet')),
          body: new SafeArea(
            top: false,
            bottom: false,
            child: new Form(
              key: _formKey,
              child: new Container(
                padding: new EdgeInsets.symmetric(horizontal: 30.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset('images/icon-small.png', width: 100.0),
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.group),
                        hintText: 'Your WorkGroup',
                        labelText: 'Your WorkGroup',
                      ),
                      initialValue: user.email,
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        user.email = value.toLowerCase();
                      },
                      validator: _validateEmail,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: 'Your Password',
                        labelText: 'Password',
                      ),
                      initialValue: user.password,
                      obscureText: true,
                      onSaved: (String value) {
                        user.password = value;
                      },
                      validator: _validatePassword,
                    ),
                    new Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: new RaisedButton(
                        child: const Text('LOGIN'),
                        onPressed: _handleSubmitted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    } else {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar( title: new Text('Login to Maxanet')),
        body: new Center( key: _formKey, child: new CircularProgressIndicator()),
      );
    }
  }
}
