import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(
    MaterialApp(home: new MyApp())
  );
}

class MyApp extends StatefulWidget {
  final MyAppInBrowser browser = new MyAppInBrowser();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(hideUrlBar: false),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(javaScriptEnabled: true))
  );

  int _currentPage = 0;
  final _pageController = PageController(); //current page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App web view"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i){
          // define o index da página atual
          setState(() {
            _currentPage = i;
          });
        },
        children: [
          Container(
            color: Colors.blue,
            child: ElevatedButton(
              child: Text("Busca inicial"),
              onPressed: (){
                widget.browser.openUrlRequest(
                  urlRequest: URLRequest(url: Uri.parse("https://www.livima.com.br/busca_inicial")),
                  options: options
                );
              }
            ),
          ),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.greenAccent.shade100,
          ),
          Container(
            color: Colors.orange,
          ),
        ]
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int i){
          _pageController.jumpToPage(i);
          setState(() {
            _currentPage = i;
          });
        },
        backgroundColor: Colors.blue[50],
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
            activeColor: Colors.red,
            darkActiveColor: Colors.red.shade400, // Optional
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
            activeColor: Colors.greenAccent.shade700,
            darkActiveColor: Colors.greenAccent.shade400, // Optional
          ),
          BottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class MyAppInBrowser extends InAppBrowser{
  //Funções dos estados
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}