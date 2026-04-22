import 'package:neoncave_arena/Theme/colors.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebView extends StatefulWidget {
  final String url;
  const WebView({
    super.key,
    required this.url,
  });

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
  void didUpdateWidget(covariant WebView oldWidget) {
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
        onMessageReceived: (JavaScriptMessage message) {},
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
    return SafeArea(
      child: Container(
        color: AppColor.screenBG,
        constraints: BoxConstraints(
          maxHeight: webViewHeight ?? 300,
          maxWidth: webViewWidth ?? double.infinity,
        ),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
