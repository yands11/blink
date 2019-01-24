import 'dart:convert';

import 'package:blink/Response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  String shortenUrl;

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

//  void loadUrl(String url) {

//  }

  Future<Null> getData(String url) async {
    String clientId = "JTyd6JPXfllV7ftKGDCV";
    String clientSecret = "tcpATloEHl";
    print("Origind URL: ${url}");

    http.Response response = await http.get(
        Uri.encodeFull(
            "https://openapi.naver.com/v1/util/shorturl.json?url=${url}"),
        headers: {
          "Accept": "application/json",
          "X-Naver-Client-Id": clientId,
          "X-Naver-Client-Secret": clientSecret
        });

    print(response.body);
    final json = jsonDecode(response.body);
    setState(() {
      final res = new Response.fromJson(json);
      if (res.code == "200") {
        shortenUrl = res.result.url;
      } else {
        shortenUrl = "ERROR!";
      }
    });
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: futureWidgetOnButtonPress(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: futureQrImageOnButtonPress(),
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
      onPressed: () => getData(currentText),
      child: Text('Done'),
      color: Colors.green,
    );
  }

  Widget futureWidgetOnButtonPress() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (shortenUrl != null) {
        return new GestureDetector(
          child: new Text(shortenUrl),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: shortenUrl));
            _showToast(context);
          },
        );
      }
      return new Text("");
    });
  }

  Widget futureQrImageOnButtonPress() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (shortenUrl != null) {
        return new Image.network("$shortenUrl.qr");
      }
      return new Text("");
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Copy completed'),
        action: SnackBarAction(
            label: 'CONFIRM', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
