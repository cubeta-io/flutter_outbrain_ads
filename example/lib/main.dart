import 'package:flutter/material.dart';
import 'package:flutter_outbrain_ads/flutter_outbrain_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outbrain Ads',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Outbrain Ads'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'You can show Ads easily like this:',
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: OutbrainAd(
                permalink:
                    'http://www.webx0.com/2010/07/some-posthype-thoughts-about-flipboard.html',
                outbrainAndroidDataObInstallationKey:
                    'DEMOP1MN24J3E1MGLQ92067LH',
                outbrainAndroidWidgetId: 'AR_1',
                outbrainIosDataObInstallationKey: 'DEMOP1MN24J3E1MGLQ92067LH',
                outbrainIosWidgetId: 'AR_1',
                darkMode: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
