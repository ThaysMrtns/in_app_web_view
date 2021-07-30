import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String selectedUrl = 'https://www.livima.com.br/busca_inicial';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
    name: 'Print',
    onMessageReceived: (JavascriptMessage message){
      print(message.message);
    }
  )
].toSet();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(home: new MyApp())
  );
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentPage = 0;
  final _pageController = PageController(); //current page
  final flutterWebviewPlugin = FlutterWebviewPlugin(); //plugin fluter web

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App web view"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i){
          setState(() {
            _currentPage = i;
          });
        },
        children: [
          Container(
            padding: EdgeInsets.only(top: 90),
            height: MediaQuery.of(context).size.height,
            child: WebviewScaffold(
              url: selectedUrl,
              javascriptChannels: jsChannels,
              mediaPlaybackRequiresUserGesture: false,
              withZoom: true,
              withLocalStorage: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(child: Text('Aguarde...'),)
              ),
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
        backgroundColor: Colors.transparent,
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

