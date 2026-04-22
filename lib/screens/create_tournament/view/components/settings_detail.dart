import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/info_detail.dart';
import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter/services.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class SettingsDetail extends StatefulWidget {
  const SettingsDetail({super.key});

  @override
  State<SettingsDetail> createState() => _SettingsDetailState();
}

class _SettingsDetailState extends State<SettingsDetail> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createTournament(
      TournamentCreateViewmodel tournamentVm,
      BuildContext context,
      DialogHelper dialogHelper,
      String timeZoneName) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.creatingTournament.tr());
    try {
      final response = await tournamentVm.createTournament();
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        debugPrint('response--- ${response.status}');
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage:
                SnackbarMessage.smallMessageError(content: response.message),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
          );
        return;
      }
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessage(
              content: LocaleKeys.tournamentCreated.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.mainScreen, arguments: true, (route) => false);
      });
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => _createTournament(
              tournamentVm, context, dialogHelper, timeZoneName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentCreateViewmodel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.h(24),
              // Header Section
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.settings_rounded,
                      size: 48,
                      color: AppColor.primaryColor,
                    ),
                    Gap.h(16),
                    CustomText(
                      title: LocaleKeys.tournamentSettings.tr(),
                      size: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                    Gap.h(8),
                    CustomText(
                      title: LocaleKeys.configureYourTournamentPreferences.tr(),
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black.withOpacity(0.6),
                      alignment: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Gap.h(32),
              // Game Region Section
              FormSection(
                title: LocaleKeys.gameRegion.tr(),
                subtitle: LocaleKeys.selectRegionText.tr(),
                hasError: viewModel.gameRegionError != null,
                errorText: viewModel.gameRegionError,
                child: _buildDropdownButton<Country>(
                  icon: Icons.public,
                  value: viewModel.selectedCountry,
                  hint: LocaleKeys.selectRegion.tr(),
                  items: viewModel.countryData?.map((country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: CustomText(
                        title: country.name,
                        size: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    );
                  }).toList(),
                  onChanged: (Country? country) {
                    if (country != null) {
                      viewModel.setSelectedRegion(country);
                    }
                  },
                ),
              ),
              Gap.h(24),
              // Tournament Format Section
              FormSection(
                title: LocaleKeys.tournamentFormat.tr(),
                subtitle: LocaleKeys.chooseTournamentStructureText.tr(),
                hasError: viewModel.tournamentFormatError != null,
                errorText: viewModel.tournamentFormatError,
                child: _buildDropdownButton<String>(
                  icon: Icons.format_list_bulleted_rounded,
                  value: viewModel.tournamentFormatId != null
                      ? viewModel.tournamentFormatName.keys.firstWhere(
                          (type) =>
                              viewModel.tournamentFormatName[type] ==
                              viewModel.tournamentFormatId,
                          orElse: () => LocaleKeys.selectFormat.tr(),
                        )
                      : null,
                  hint: LocaleKeys.selectFormat.tr(),
                  items: viewModel.tournamentFormatName.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: CustomText(
                        title: type,
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? format) {
                    if (format != null) {
                      viewModel.setSelectedTournamentFormat(format);
                    }
                  },
                ),
              ),
              Gap.h(24),
              // Bracket Format Section
              FormSection(
                title: LocaleKeys.bracketsFormat.tr(),
                subtitle: LocaleKeys.selectHowMatchesWillBeOrganized.tr(),
                hasError: viewModel.bracketFormatError != null,
                errorText: viewModel.bracketFormatError,
                child: _buildDropdownButton<String>(
                  icon: Icons.account_tree_rounded,
                  value: viewModel.bracketFormatId != null
                      ? viewModel.bracketFormatName.keys.firstWhere(
                          (type) =>
                              viewModel.bracketFormatName[type] ==
                              viewModel.bracketFormatId,
                          orElse: () => LocaleKeys.selectFormat.tr(),
                        )
                      : null,
                  hint: LocaleKeys.selectFormat.tr(),
                  items: viewModel.bracketFormatName.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: CustomText(
                        title: type,
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? format) {
                    if (format != null) {
                      viewModel.setSelectedBracketFormat(format);
                    }
                  },
                ),
              ),
              Gap.h(24),
              // Registration Regions Section
              FormSection(
                title: LocaleKeys.registrationRegions.tr(),
                subtitle: LocaleKeys.defineWhoCanParticipate.tr(),
                child: Column(
                  children: [
                    // Region Type Selection
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSelectionButton(
                              title: LocaleKeys.all.tr(),
                              isSelected:
                                  viewModel.selectedRegisterRegionsIndex == 0,
                              onTap: () =>
                                  viewModel.updateRegisterRegionIndex(0),
                            ),
                          ),
                          Gap.w(12),
                          Expanded(
                            child: _buildSelectionButton(
                              title: LocaleKeys.selectedRegions.tr(),
                              isSelected:
                                  viewModel.selectedRegisterRegionsIndex == 1,
                              onTap: () =>
                                  viewModel.updateRegisterRegionIndex(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (viewModel.selectedRegisterRegionsIndex == 1) ...[
                      Gap.h(16),
                      MultiSelectDropDown(
                        dropdownBackgroundColor: AppColor.screenBG,
                        borderRadius: 12,
                        borderColor: AppColor.grey.withOpacity(0.2),
                        borderWidth: 1,
                        focusedBorderColor: AppColor.primaryColor,
                        fieldBackgroundColor: AppColor.screenBG,
                        controller: viewModel.multiSelectController,
                        onOptionSelected: (options) {
                          final selectedCountryIds = options
                              .map((option) => int.parse(option.value!))
                              .toList();
                          Provider.of<TournamentCreateViewmodel>(context,
                                  listen: false)
                              .updateSelectedRegions(selectedCountryIds);
                        },
                        options: viewModel.countryData!.map((country) {
                          return ValueItem(
                            label: country.name,
                            value: country.id.toString(),
                          );
                        }).toList(),
                        selectionType: SelectionType.multi,
                        chipConfig: ChipConfig(
                          wrapType: WrapType.wrap,
                          backgroundColor: AppColor.primaryColor,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        dropdownHeight: 300,
                        optionTextStyle:
                            TextStyle(fontSize: 16, color: AppColor.black),
                        selectedOptionIcon: Icon(
                          Icons.check_circle,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Gap.h(24),
              // Check-in Time Section
              FormSection(
                title: LocaleKeys.checkInTimeInMinutes.tr(),
                subtitle: LocaleKeys.setHowEarlyParticipants.tr(),
                hasError: viewModel.checkInTimeError != null,
                errorText: viewModel.checkInTimeError,
                child: _buildDropdownButton<String>(
                  icon: Icons.timer_rounded,
                  value: viewModel.checkTimeId != null
                      ? viewModel.checkTime.keys.firstWhere(
                          (type) =>
                              viewModel.checkTime[type] ==
                              viewModel.checkTimeId,
                          orElse: () => LocaleKeys.selectCheckInTime.tr(),
                        )
                      : null,
                  hint: LocaleKeys.selectCheckInTime.tr(),
                  items: viewModel.checkTime.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: CustomText(
                        title: type,
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? time) {
                    if (time != null) {
                      viewModel.setSelectedCheckTime(time);
                    }
                  },
                ),
              ),
              Gap.h(24),
              // Participant Limit Section
              FormSection(
                title: LocaleKeys.registrationParticipantLimit.tr(),
                subtitle: LocaleKeys.setMaximumNumberParticipants.tr(),
                hasError: viewModel.participantLimitError != null,
                errorText: viewModel.participantLimitError,
                child: TextFormField(
                  controller: viewModel.participentsLimit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    viewModel.handleParticipantLimitChange(value);
                  },
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.black,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: AppColor.grey.withOpacity(0.6),
                    ),
                    hintText: LocaleKeys.enterLimit.tr(),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: Icon(
                      Icons.group_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
              Gap.h(32),
              // Create Tournament Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!viewModel.settingDetailValidator()) return;
                    _createTournament(
                      viewModel,
                      context,
                      _dialogueHelper,
                      viewModel.timeZoneName,
                    );
                  },
                  icon: const Icon(
                    Icons.sports_esports_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: CustomText(
                    title: LocaleKeys.createTournament.tr(),
                    size: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              Gap.h(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownButton<T>({
    required IconData icon,
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>>? items,
    required Function(T?) onChanged,
  }) {
    return Container(
      color: AppColor.screenBG,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.primaryColor,
            size: 24,
          ),
          Gap.w(12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                dropdownColor: AppColor.screenBG,
                value: value,
                hint: CustomText(
                    title: hint,
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black),
                items: items,
                onChanged: onChanged,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColor.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryColor
                : AppColor.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: CustomText(
            title: title,
            size: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColor.black,
          ),
        ),
      ),
    );
  }
}
