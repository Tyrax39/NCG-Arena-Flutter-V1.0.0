import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';

class DetailTab extends StatelessWidget {
  final AllTournaments tournamentdata;
  const DetailTab({super.key, required this.tournamentdata});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organization Details
          _buildInfoCard(
            icon: Icons.business,
            title: LocaleKeys.organizationDetail.tr(),
            mainInfo: tournamentdata.organization?.name?.toString() ?? '',
            subInfo: null,
          ),
          Gap.h(16),

          // Game and Region
          _buildInfoCard(
            icon: Icons.sports_esports,
            title: LocaleKeys.gameAndRegion.tr(),
            mainInfo: tournamentdata.gameName ?? '',
            subInfo: tournamentdata.region?.name ?? '',
          ),
          Gap.h(16),

          // Date and Time
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: LocaleKeys.dateAndTime.tr(),
            mainInfo: tournamentdata.dateIni != null
                ? DateFormat('EEEE, MMMM d, yyyy')
                    .format(tournamentdata.dateIni!)
                : '',
            subInfo: tournamentdata.startTime?.toString() ?? '',
            trailing: Icon(Icons.access_time, color: AppColor.primaryColor),
          ),
          Gap.h(16),

          // Format
          _buildInfoCard(
            icon: Icons.people_alt,
            title: LocaleKeys.format.tr(),
            mainInfo: tournamentdata.format == 1 ? "1V1" : "Team VS Team",
            subInfo: null,
            trailing: Icon(
              tournamentdata.format == 1 ? Icons.person : Icons.groups,
              color: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String mainInfo,
    String? subInfo,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.offwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    softWrap: true,
                    alignment: TextAlign.justify,
                    title: title,
                    color: AppColor.primaryColor,
                    size: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  Gap.h(8),
                  CustomText(
                    softWrap: true,
                    alignment: TextAlign.justify,
                    title: mainInfo,
                    color: AppColor.black,
                    size: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  if (subInfo != null) ...[
                    Gap.h(4),
                    CustomText(
                      softWrap: true,
                      alignment: TextAlign.justify,
                      title: subInfo,
                      color: AppColor.black.withOpacity(0.7),
                      size: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
