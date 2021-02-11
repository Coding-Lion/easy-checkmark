import 'package:flutter/material.dart';
import 'package:livesafe_form/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xFF97002E),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
              title: "Gannon Health Survey",
            ),
        '/webview': (context) => WebviewPage(
              title: "Gannon Health Survey",
            )
      },
    );
  }
}

class User {
  String firstName = '';
  String lastName = '';
  String email = '';
  String area = '';
  String phone = '';

  User({this.firstName, this.lastName, this.email, this.area, this.phone});
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var areaController = TextEditingController();
  var phoneController = TextEditingController();
  SharedPreferences prefs;
  User user = User();

  initSharedPrefrences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = User(
        firstName: prefs.getString("firstName"),
        lastName: prefs.getString("lastName"),
        email: prefs.getString("email"),
        area: prefs.getString("area"),
        phone: prefs.getString("phone"),
      );
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      areaController.text = user.area;
      phoneController.text = user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) initSharedPrefrences();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 16,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'First Name',
                              contentPadding: EdgeInsets.all(8.0)),
                          controller: firstNameController,
                          onChanged: (value) {
                            user.firstName = value;
                            prefs?.setString('firstName', value);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Last Name',
                              contentPadding: EdgeInsets.all(8.0)),
                          controller: lastNameController,
                          onChanged: (value) {
                            user.lastName = value;
                            prefs?.setString('lastName', value);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: Row(
                          children: [
                            new Flexible(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Area Code',
                                  contentPadding: EdgeInsets.all(8.0)),
                              controller: areaController,
                              onChanged: (value) {
                                user.area = value;
                                prefs?.setString('area', value);
                              },
                            )),
                            Container(
                              width: 8,
                            ),
                            new Flexible(
                                flex: 2,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'Phone Number',
                                      contentPadding: EdgeInsets.all(8.0)),
                                  controller: phoneController,
                                  onChanged: (value) {
                                    user.phone = value;
                                    prefs?.setString('phone', value);
                                  },
                                )),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Gannon Email Address',
                              contentPadding: EdgeInsets.all(8.0)),
                          controller: emailController,
                          onChanged: (value) {
                            user.email = value;
                            prefs?.setString('email', value);
                          },
                        )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.red.shade800)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/webview",
                              arguments:
                                  WebviewPageSettings(skip: false, user: user));
                        },
                        child: Text("There is a problem")),
                    Flexible(child: Container()),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.green.shade800)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/webview",
                              arguments:
                                  WebviewPageSettings(skip: true, user: user));
                        },
                        child: Text("I'm feeling fine")),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
