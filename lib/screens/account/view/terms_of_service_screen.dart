import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:neoncave_arena/constant/config.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(AppConfig.termsOfServiceUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBar(title: LocaleKeys.termsOfServices.tr(),),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
} 