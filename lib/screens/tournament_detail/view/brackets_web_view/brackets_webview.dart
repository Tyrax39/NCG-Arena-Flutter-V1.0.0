import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewBracket extends StatefulWidget {
  final String url;
  final String currentuserid;
  const WebViewBracket({
    super.key,
    required this.url,
    required this.currentuserid,
  });

  @override
  State<WebViewBracket> createState() => _WebViewBracketState();
}

class _WebViewBracketState extends State<WebViewBracket> {
  late WebViewController _controller;
  double? webViewHeight;
  double? webViewWidth;
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant WebViewBracket oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeController();
  }

  void _initializeController() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (some) async {
            final dynamic heightResult =
            await _controller.runJavaScriptReturningResult(
              "document.documentElement.scrollHeight;",
            );
            final dynamic widthResult =
            await _controller.runJavaScriptReturningResult(
              "document.documentElement.scrollWidth;",
            );

            if (heightResult != null && widthResult != null) {
              final double? height = double.tryParse(heightResult.toString());
              final double? width = double.tryParse(widthResult.toString());

              if (height != null && width != null) {
                setState(() {
                  webViewHeight = height;
                  webViewWidth = width;
                });
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Print',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message != '0') {
            Navigator.pushNamed(context, MyRoutes.matchDetailScreen,
                arguments: [
                  int.tryParse(message.message.toString()),
                  widget.currentuserid,
                ]).then((value) {
              if (value == true) {
                _initializeController();
              }
            });
          } else {
            snackbarHelper
              ..injectContext(context)
              ..showSnackbar(
                  snackbarMessage: const SnackbarMessage(
                      content:
                      "Please wait until previous round matches are completed before viewing match details.",
                      isLongMessage: true,
                      isForError: true));
          }
        },
      )
      ..loadRequest(Uri.parse(widget.url));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: webViewHeight ?? 300,
        maxWidth: webViewWidth ?? AppConfig(context).width,
      ),
      child: WebViewWidget(controller: _controller),
    );
  }
}