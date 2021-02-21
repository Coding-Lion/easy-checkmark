import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

class WebviewPageSettings {
  bool skip;
  User user;

  WebviewPageSettings({@required this.skip, @required this.user});
}

class WebviewPage extends StatefulWidget {
  WebviewPage({Key key, this.title}) : super(key: key) {}

  final String title;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController _controller;
  User user;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    var skip = false;
    User user = User();

    if (args is WebviewPageSettings) {
      skip = args.skip;
      user = args.user;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: 'https://livesafe.jotform.com/201595537337865/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        onWebResourceError: (error) {
          print("error");
          print(error);
          if (error is WebResourceError) {
            if (error.description == 'net::ERR_SSL_PROTOCOL_ERROR') {
              _controller.reload();
            }
            print(error.description);
            print(error.failingUrl);
          }
        },
        onPageFinished: (url) async {
          print(url);
          if (url == 'https://livesafe.jotform.com/201595537337865/') {
            await _controller.evaluateJavascript(
                'document.getElementById("first_3").value = "${user.firstName}";' +
                    'document.getElementById("last_3").value = "${user.lastName}";' +
                    'document.getElementById("input_20").value = "${user.email}";' +
                    'document.getElementById("input_25_area").value = "${user.area}";' +
                    'document.getElementById("input_25_phone").value = "${user.phone}";' +
                    'document.getElementById("input_26").value = "Student";');
            if (skip) {
              await _controller.evaluateJavascript(
                  'document.getElementById("input_15_1").click();' +
                      'document.getElementById("input_5_1").click();' +
                      'document.getElementById("input_6_1").click();' +
                      'document.getElementById("input_27_1").click();' +
                      'document.getElementById("input_2").click();');
            }
          }
        },
      ),
    );
  }
}
