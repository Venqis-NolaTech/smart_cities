import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/util/string_util.dart';
import 'fade_indexed_stack.dart';

class WebViewArgs {
  final String title;
  final String url;
  final String callbackUrl;
  final Map<String, String> headers;

  WebViewArgs({
    this.title,
    this.headers,
    this.callbackUrl,
    @required this.url,
  });
}

class WebViewPage extends StatefulWidget {
  static const id = "web_view_page";

  WebViewPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final WebViewArgs args;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _showLoading();
  }

  void _onUrlLoaded(
    BuildContext context,
    InAppWebViewController controller,
    String url,
  ) {
    final args = widget.args;

    Future.delayed(Duration(milliseconds: 250), () {
      if (url == args.url) _hideLoading();
    });

    final callbackUrl = args.callbackUrl;

    if (callbackUrl.isNullOrEmpty) return;

    if (url.contains(callbackUrl)) {
      Navigator.pop(context, url);
    }
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args?.title ?? ""),
      ),
      body: FadeIndexedStack(
        index: _isLoading ? 1 : 0,
        children: [
          Positioned.fill(
            child: InAppWebView(
              initialUrl: widget.args.url,
              initialHeaders: widget.args?.headers,
              onLoadStop: (controller, url) =>
                  _onUrlLoaded(context, controller, url),
              onEnterFullscreen: (_) => SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]),
              onExitFullscreen: (_) => SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
