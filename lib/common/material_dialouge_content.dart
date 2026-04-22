import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';


class MaterialDialogContent {
  final String title;
  final String content;
  final String positiveText;
  final String negativeText;

  MaterialDialogContent(
      {required this.title,
        required this.content,
        this.positiveText = LocaleKeys.tryAgain,
        this.negativeText = LocaleKeys.cancel});

  MaterialDialogContent.networkError()
      : this(title: LocaleKeys.limitedNetworkConnection.tr(), content: LocaleKeys.limitedConnectionContent.tr());

  @override
  String toString() {
    return 'MaterialDialogContent{title: $title, content: $content, positiveText: $positiveText, negativeText: $negativeText}';
  }
}