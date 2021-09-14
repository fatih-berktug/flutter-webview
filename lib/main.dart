import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController webViewController;

  bool showSpinner = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF626262),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: WebView(

            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "https://badminton.gov.tr/",
            onWebViewCreated: (controller) {
              webViewController = controller;
              print("::: onWebViewCreated");

            },
            onPageStarted: (text) {
              print("::: onPageStarted");

            },
            onPageFinished: (text) {
              print("::: onPageFinished");
              setState(() {
                showSpinner = false;
              });
            },
            onWebResourceError: (error) {
              print("::: onWebResourceError");
            },
            navigationDelegate: (NavigationRequest request) {
              if (!request.url.contains('https://badminton.gov.tr/')) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text("Tarayıda aç?"),
                        //backgroundColor: Color(0xFFEDD23B),
                        actions: <Widget>[
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text("Hayır"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Evet"),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  if (await canLaunch(request.url)) {
                                    await launch(
                                      request.url,
                                      forceSafariVC: false,
                                      forceWebView: false,
                                      headers: <String, String>{
                                        'Badminton ': 'Badminton'
                                      },
                                    );
                                  } else {
                                    throw 'Could not launch $request.url';
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      );
                    });
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 45,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xFF626262),
                    ),
                    label: Text(
                      "ANASAYFA",
                      style: TextStyle(
                        color: Color(0xFF626262),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });
                      webViewController.loadUrl("https://badminton.gov.tr/");
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VerticalDivider(),
                ),
               
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.apps,
                      color: Color(0xFF626262),
                    ),
                    label: Text(
                      "SBS",
                      style: TextStyle(
                        color: Color(0xFF626262),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });
                      webViewController.loadUrl("https://sbs.badminton.gov.tr/");
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
