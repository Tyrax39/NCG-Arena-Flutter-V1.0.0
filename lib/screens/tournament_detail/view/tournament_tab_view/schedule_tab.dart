import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentDetailViewmodel>(
        builder: (context, value, child) {
      return value.tournamentData!.schedule != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: HtmlWidget(
                value.tournamentData!.schedule!,
                renderMode: RenderMode.column,
                textStyle: TextStyle(fontSize: 13, color: AppColor.black),
              ),
            )
          : const SizedBox();
    });
  }
}
