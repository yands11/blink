import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blink',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Blink'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextStyle _appBarTextStyle = const TextStyle(
      fontSize: 22.0,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold);

  final controller = new TextEditingController();
  String currentText;

  @override
  void initState() {
    controller.addListener(_textChangedCallback);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _textChangedCallback() {
    currentText = controller.text;
    print("Changed Text: ${controller.text}");
  }

  _buttonPressedCallback(String string) async {
    if (string.length > 0) {
      print("Origind URL: ${string}");
      loadUrl(string);
    }
  }

  void loadUrl(String url) {
    String clientId = "JTyd6JPXfllV7ftKGDCV";
    String clientSecret = "tcpATloEHl";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: myTextField(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: myButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myAppBar() {
    return AppBar(
      title: Center(
          child: Text(
        'BLINK',
        style: _appBarTextStyle,
      )),
    );
  }

  Widget myTextField() {
    final Radius _radius = Radius.circular(16.0);
    final TextStyle _textStyle = TextStyle(fontSize: 18.0, color: Colors.black);

    return TextFormField(
      style: _textStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: _radius,
                topRight: _radius,
                bottomLeft: _radius,
                bottomRight: _radius)),
        labelText: 'Long URL',
      ),
      controller: controller,
    );
  }

  Widget myButton() {
    final BorderRadius _radius = BorderRadius.all(Radius.circular(16.0));
    return CupertinoButton(
      pressedOpacity: 0.7,
      borderRadius: _radius,
      onPressed: () {
        _buttonPressedCallback(currentText);
      },
      child: Text('Done'),
      color: Colors.green,
    );
  }
}
