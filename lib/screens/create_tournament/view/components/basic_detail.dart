// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/info_detail.dart';
import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BasicDetail extends StatelessWidget {
  BasicDetail({super.key});
  List<DropdownMenuEntry<String>> timezones = [];
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TournamentCreateViewmodel>(context, listen: true);
    tz.initializeTimeZones();
    final allTimezones = tz.timeZoneDatabase.locations.keys.toList();
    timezones = allTimezones
        .map((timezone) => DropdownMenuEntry<String>(
              value: timezone,
              label: timezone,
            ))
        .toList();

    return Consumer<TournamentCreateViewmodel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.h(24),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      size: 48,
                      color: AppColor.primaryColor,
                    ),
                    Gap.h(16),
                    CustomText(
                      title: LocaleKeys.tournamentDetails.tr(),
                      size: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                    Gap.h(8),
                    CustomText(
                      title: LocaleKeys.fillBasicInfoText.tr(),
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black.withOpacity(0.6),
                      alignment: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Gap.h(32),
              FormSection(
                title: LocaleKeys.headerImage.tr(),
                subtitle: LocaleKeys.addBannerText.tr(),
                hasError: viewModel.headerImageError != null,
                errorText: viewModel.headerImageError,
                child: InkWell(
                  onTap: () async {
                    FilePickerHnadler.showImagePicker(
                      context: context,
                      onGetImage: (val) async {
                        if (val != null) {
                          viewModel.newImageHeaderPath(val.path);
                        }
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: viewModel.imageHeaderPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(viewModel.imageHeaderPath),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 12,
                                  top: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 48,
                                color: AppColor.primaryColor,
                              ),
                              Gap.h(12),
                              CustomText(
                                title: LocaleKeys.headerImage.tr(),
                                size: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black.withOpacity(0.6),
                              ),
                              Gap.h(8),
                              CustomText(
                                title:
                                    '${LocaleKeys.recommendedSize.tr()} 1200x400',
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black.withOpacity(0.4),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Gap.h(24),
              FormSection(
                title: LocaleKeys.tournamentName.tr(),
                subtitle: LocaleKeys.chooseTournamentName.tr(),
                hasError: viewModel.tournamentNameError != null,
                errorText: viewModel.tournamentNameError,
                child: TextFormField(
                  controller: viewModel.tournamentName,
                  onChanged: (_) => viewModel.clearNameError(),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enterTournamentName.tr(),
                    hintStyle: TextStyle(
                      color: AppColor.grey.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: .3,
                        color: AppColor.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: .3,
                        color: AppColor.grey.withOpacity(0.2),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: .3,
                        color: AppColor.grey.withOpacity(0.2),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: .3,
                        color: AppColor.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: .5,
                        color: AppColor.grey.withOpacity(0.2),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: Icon(
                      Icons.emoji_events_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
              Gap.h(24),
              Row(
                children: [
                  Expanded(
                    child: FormSection(
                      title: LocaleKeys.startDate.tr(),
                      hasError: viewModel.startDateError != null,
                      errorText: viewModel.startDateError,
                      child: _buildDatePicker(
                        context,
                        viewModel.selectedStartDate,
                        (date) => viewModel.selectStartDate(date),
                        LocaleKeys.startDate.tr(),
                      ),
                    ),
                  ),
                  Gap.w(16),
                  Expanded(
                    child: FormSection(
                      title: LocaleKeys.finishDate.tr(),
                      hasError: viewModel.finishDateError != null,
                      errorText: viewModel.finishDateError,
                      child: _buildDatePicker(
                        context,
                        viewModel.selectedFinishDate,
                        (date) => viewModel.selectFinishDate(date),
                        LocaleKeys.endDate.tr(),
                      ),
                    ),
                  ),
                ],
              ),
              Gap.h(24),
              FormSection(
                title: LocaleKeys.startTime.tr(),
                subtitle: LocaleKeys.whenDoesYourTournamentBegin.tr(),
                hasError: viewModel.startTimeError != null,
                errorText: viewModel.startTimeError,
                child: InkWell(
                  onTap: () async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: AppColor.screenBG,
                              hourMinuteShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            colorScheme: ColorScheme.light(
                              primary: AppColor.primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedTime != null) {
                      viewModel.handleTimeSelection(selectedTime, context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: AppColor.primaryColor,
                        ),
                        Gap.w(12),
                        CustomText(
                          title: viewModel.startTime.text.isEmpty
                              ? LocaleKeys.selectStartTime.tr()
                              : viewModel.startTime.text,
                          size: 14,
                          fontWeight: FontWeight.w400,
                          color: viewModel.startTime.text.isEmpty
                              ? AppColor.grey.withOpacity(0.7)
                              : AppColor.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap.h(24),
              FormSection(
                title: LocaleKeys.selectTimeZone.tr(),
                subtitle: LocaleKeys.chooseYourTournamentTimezone.tr(),
                hasError: viewModel.timeZoneError != null,
                errorText: viewModel.timeZoneError,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownMenu<String>(
                    controller: viewModel.timeZoneController,
                    width: MediaQuery.of(context).size.width - 80,
                    menuHeight: 300,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: AppColor.black,
                    ),
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColor.screenBG,
                      ),
                      elevation: WidgetStateProperty.all(4),
                      shadowColor: WidgetStateProperty.all(
                        AppColor.black.withOpacity(0.1),
                      ),
                      surfaceTintColor:
                          WidgetStateProperty.all(Colors.transparent),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: .3,
                          color: AppColor.grey.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: .3,
                          color: AppColor.grey.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: .5,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: .3,
                          color: AppColor.grey.withOpacity(0.2),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      hintStyle: TextStyle(
                        color: AppColor.grey.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    leadingIcon: Icon(
                      Icons.public,
                      color: AppColor.primaryColor,
                    ),
                    onSelected: (value) =>
                        viewModel.handleTimeZoneSelection(value),
                    dropdownMenuEntries: timezones
                        .map((entry) => DropdownMenuEntry<String>(
                              value: entry.value,
                              label: entry.label,
                              labelWidget: Container(
                                padding: const EdgeInsets.all(8),
                                child: CustomText(
                                  title: entry.label,
                                  size: 14,
                                  color: AppColor.black,
                                ),
                              ),
                            ))
                        .toList(),
                    hintText: LocaleKeys.selectTimeZone.tr(),
                    selectedTrailingIcon: Icon(
                      Icons.check,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
              Gap.h(24),
              FormSection(
                title: LocaleKeys.about.tr(),
                subtitle: LocaleKeys.describeYourTournament.tr(),
                hasError: viewModel.aboutError != null,
                errorText: viewModel.aboutError,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.screenBG,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: QuillSimpleToolbar(
                          controller: viewModel.controller,
                          config: const QuillSimpleToolbarConfig(
                            multiRowsDisplay: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: QuillEditor.basic(
                          controller: viewModel.controller,
                          config: QuillEditorConfig(
                            showCursor: true,
                            padding: const EdgeInsets.all(16),
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                  color: AppColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                            ),
                            textSelectionThemeData: TextSelectionThemeData(
                              cursorColor: AppColor.primaryColor,
                              selectionColor:
                                  AppColor.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap.h(32),
              PrimaryBTN(
                  height: 56,
                  callback: () {
                    if (!viewModel.basicInfoValidator()) return;
                    viewModel.updatePagerIndex(4);
                  },
                  borderRadius: 10,
                  color: AppColor.primaryColor,
                  title: LocaleKeys.next.tr(),
                  width: AppConfig(context).width),
              Gap.h(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
    String hintText,
  ) {
    return InkWell(
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColor.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: AppColor.primaryColor,
              size: 20,
            ),
            Gap.w(12),
            CustomText(
              title: selectedDate != null
                  ? selectedDate.toLocal().toString().split(' ')[0]
                  : hintText,
              size: 14,
              fontWeight: FontWeight.w400,
              color: selectedDate != null
                  ? AppColor.black
                  : AppColor.grey.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
