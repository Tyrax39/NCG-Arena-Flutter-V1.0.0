import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_environment.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/brackets_web_view/brackets_webview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BracketsTab extends StatefulWidget {
  final AllTournaments tournamentData;
  final String currentUserId;
  const BracketsTab(
      {super.key, required this.tournamentData, required this.currentUserId});

  @override
  State<BracketsTab> createState() => _BracketsTabState();
}

class _BracketsTabState extends State<BracketsTab> {
  @override
  Widget build(BuildContext context) {
    final appColor = Provider.of<AppColor>(context);
    final size = MediaQuery.of(context).size.height;
    return widget.tournamentData.isStart.toString() == "1"
        ? WebViewBracket(
            url:
            '${AppEnvironment.webBaseUrl}/brackets/${widget.tournamentData.id}?theme=${appColor.getCurrentThemeForUrl()}',
            currentuserid: widget.currentUserId,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size * .15),
              Icon(
                Icons.emoji_events,
                size: 64,
                color: AppColor.primaryColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              CustomText(
                title: LocaleKeys.emptyNeoncaveArenaTextTitle.tr(),
                color: AppColor.black,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 8),
              CustomText(
                title: LocaleKeys.emptyNeoncaveArenaText.tr(),
                color: AppColor.grey,
                size: 14,
                maxLines: 2,
              ),
            ],
          );
  }
}
