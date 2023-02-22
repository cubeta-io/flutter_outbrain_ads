library flutter_outbrain_ads;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:url_launcher/url_launcher.dart';

const outbrainWidgetURL =
    "https://widgets.outbrain.com/reactNativeBridge/index.html";

const double webViewInitialHeight = 100;

class OutbrainAd extends StatefulWidget {
  const OutbrainAd({
    Key? key,
    required this.permalink,
    this.outbrainAndroidWidgetId,
    this.outbrainIosWidgetId,
    this.outbrainAndroidDataObInstallationKey,
    this.outbrainIosDataObInstallationKey,
    this.darkMode = false,
    this.onOrganicClick,
  }) : super(key: key);

  final String permalink;
  final String? outbrainAndroidWidgetId;
  final String? outbrainIosWidgetId;
  final String? outbrainAndroidDataObInstallationKey;
  final String? outbrainIosDataObInstallationKey;
  final bool darkMode;
  final Function(String)? onOrganicClick;

  @override
  State<OutbrainAd> createState() => _OutbrainAdState();
}

class _OutbrainAdState extends State<OutbrainAd> {
  WebViewController? _controller;
  bool darkMode = false;

  double webViewHeight = webViewInitialHeight;
  String? webviewUrl;

  _onWebViewMessage(JavascriptMessage event) {
    var result = jsonDecode(event.message);
    if (result['height'] != null) {
      setState(() {
        webViewHeight = double.parse(result['height'].toString()) + 10;
      });
    }
    if (result['url'] != null) {
      if (widget.onOrganicClick == null) {
        _launchUrl(Uri.parse(result['url']));
      } else {
        widget.onOrganicClick!(result['url']);
      }
    }
  }

  _buildWidgetURL() async {
    setState(() {
      darkMode = widget.darkMode;
    });
    String? advertisingId;
    try {
      advertisingId = await AdvertisingId.id(true);
    } catch (e) {
      advertisingId = null;
    }
    String url;
    if (Platform.isAndroid) {
      url =
          '$outbrainWidgetURL?permalink=${widget.permalink}&widgetId=${widget.outbrainAndroidWidgetId}';

      if (widget.outbrainAndroidDataObInstallationKey != null) {
        url +=
            '&installationKey=${widget.outbrainAndroidDataObInstallationKey}';
      }
    } else {
      url =
          '$outbrainWidgetURL?permalink=${widget.permalink}&widgetId=${widget.outbrainIosWidgetId}';

      if (widget.outbrainIosDataObInstallationKey != null) {
        url += '&installationKey=${widget.outbrainIosDataObInstallationKey}';
      }
    }

    if (widget.darkMode) {
      url += '&darkMode=true';
    }

    if (advertisingId != null) {
      url += '&userId=$advertisingId';
    }

    //Check if webview already loaded and dark mode changed then load new url
    if (webviewUrl != null) {
      _controller?.loadUrl(url);
    } else {
      setState(() {
        webviewUrl = url;
      });
    }
  }

  @override
  void initState() {
    _buildWidgetURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.darkMode != darkMode) {
      _buildWidgetURL();
    }
    return webviewUrl == null
        ? Container()
        : SizedBox(
            height: webViewHeight,
            child: WebView(
              initialUrl: webviewUrl,
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              zoomEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: Colors.transparent,
              javascriptChannels: {
                JavascriptChannel(
                  name: 'ReactNativeWebView',
                  onMessageReceived: _onWebViewMessage,
                )
              },
              onWebViewCreated: (controller) => _controller = controller,
              onPageFinished: (url) {
                _controller?.runJavascript(
                    "var timesRun = 0;var interval = setInterval(function(){    timesRun += 1;    if(timesRun === 2){        clearInterval(interval);    }   let result = {} ;           let height = document.body.scrollHeight ;      result['height'] = height;          ReactNativeWebView.postMessage(JSON.stringify(result)) ;  }, 1000);");
              },
              navigationDelegate: (nav) {
                if (nav.url.contains('https://widgets.outbrain.com')) {
                  return NavigationDecision.navigate;
                }
                _launchUrl(nav.url);

                return NavigationDecision.prevent;
              },
            ),
          );
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
