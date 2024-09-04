import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class sosDialog {

  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();

  Future<void> sosDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Enter phone numbers you would like to contact"),
              content: new SingleChildScrollView(
                  child: new ListBody(children: <Widget>[
                TextFormField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    labelText: 'Enter your name:',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controller2,
                  decoration: InputDecoration(
                    labelText: 'Enter phone number 1:',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controller3,
                  decoration: InputDecoration(
                    labelText: 'Enter phone number 2:',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controller4,
                  decoration: InputDecoration(
                    labelText: 'Enter phone number 3:',
                  ),
                ),
                new SizedBox(height: 10),
                // ignore: deprecated_member_use
                new ElevatedButton(
                  onPressed: () {
                    setData((_controller1.text), (_controller2.text),
                        (_controller3.text), _controller4.text);
                  },

                  child: Container(
                    color: Colors.cyan,
                    child: Text(
                      "Save Information",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ])));
        });
  }

  setData(String n, String n1, String n2, String n3)  async {

  final  SharedPreferences prefs = await SharedPreferences.getInstance();
    print(n);
    print(n1);
    print(n2);
    print(n3);
//save data value to there keys name,n1,n2,n3
     prefs.setString('name', n);
     prefs.setString('n1', n1);
     prefs.setString('n2', n2);
     prefs.setString('n3', n3);

  }
}
