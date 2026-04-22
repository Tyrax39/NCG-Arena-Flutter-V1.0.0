import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/account/components/switch_button.dart';
import 'package:neoncave_arena/screens/account/view_model/notification_prefrences_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class NotificationsPreferences extends StatefulWidget {
  const NotificationsPreferences({super.key});

  @override
  State<NotificationsPreferences> createState() =>
      _NotificationsPreferencesState();
}

class _NotificationsPreferencesState extends State<NotificationsPreferences> {
  late NotificationsPreferencesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: LocaleKeys.notifications.tr()),
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.h(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                title: LocaleKeys.notificationTitle.tr(),
                color: AppColor.black,
                size: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap.h(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                softWrap: true,
                title: LocaleKeys.notificationDescription.tr(),
                color: AppColor.grey,
                size: 14,
                maxLines: 2,
                alignment: TextAlign.start,
              ),
            ),
            Gap.h(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<NotificationsPreferencesViewModel>(
                builder: (context, model, child) {
                  return Column(
                    children: [
                      _buildNotificationRow(
                        LocaleKeys.joinTournament.tr(),
                        model.joinTournament,
                        (val) => model.updatePreference('joinTournament', val),
                      ),
                      Gap.h(30),
                      _buildNotificationRow(
                        LocaleKeys.followChannel.tr(),
                        model.followChannel,
                        (val) => model.updatePreference('followChannel', val),
                      ),
                      Gap.h(30),
                      _buildNotificationRow(
                        LocaleKeys.followUsers.tr(),
                        model.followUsers,
                        (val) => model.updatePreference('followUsers', val),
                      ),
                      Gap.h(30),
                      _buildNotificationRow(
                        LocaleKeys.followOrganizations.tr(),
                        model.followOrganizations,
                        (val) =>
                            model.updatePreference('followOrganizations', val),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationRow(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        CustomText(
          title: title,
          size: 16,
          fontWeight: FontWeight.w400,
          color: AppColor.black,
        ),
        const Spacer(),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
