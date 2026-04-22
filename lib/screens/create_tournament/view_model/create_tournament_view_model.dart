import 'dart:developer';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:timezone/timezone.dart' as tz;

class TournamentCreateViewmodel extends ChangeNotifier {
  void disposeValues() {
    selectedIndex = 0;
    tournamentName.text = '';
    timeZoneController.text = '';
    startTime.text = '';
    participentsLimit.text = '';
    selectedgameregion.text = '';
    selectedgameregionid.text = '';
    firstPrizeController.text = '';
    firstPrizeController.text = '';
    secondPrizeController.text = '';
    linkController.text = '';
    selectedRegistrationRegionController.text = '';
    selectedRegistrationRegionIdController.text = '';
    selectedRegionName = '';
    selectedRegionId = 0;
    selectedRegistrationRegionName = '';
    selectedRegistrationRegionId = 0;
    _headerImagePath = '';
  }

  int selectedRegisterRegionsIndex = 0;
  updateRegisterRegionIndex(int index) {
    selectedRegisterRegionsIndex = index;
    registrationRegionError = null;
    notifyListeners();
  }

  List<dynamic> selectedRegisterRegions = [];
  updateSelectedRegions(value) {
    selectedRegisterRegions = value;
    registrationRegionError = null;
    notifyListeners();
  }

  TournamentCreateViewmodel() {
    getRegions();
    getbalance();
  }

  final SharedWebService sharedWebService = SharedWebService.instance();
  TextEditingController tournamentName = TextEditingController();
  QuillController controller = QuillController.basic();

  final TextEditingController timeZoneController = TextEditingController();

  TextEditingController startTime = TextEditingController();
  QuillController rulesController = QuillController.basic();
  QuillController scheduleController = QuillController.basic();
  TextEditingController participentsLimit = TextEditingController();

  final PageController pageSliderController = PageController();
  final TextEditingController selectedgameregion = TextEditingController();

  final TextEditingController selectedgameregionid = TextEditingController();

  final TextEditingController firstPrizeController = TextEditingController();
  final TextEditingController secondPrizeController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final MultiSelectController multiSelectController = MultiSelectController();
  final TextEditingController selectedRegistrationRegionController =
      TextEditingController();

  final TextEditingController selectedRegistrationRegionIdController =
      TextEditingController();

  String? selectedRegionName;
  int? selectedRegionId;

  String? selectedRegistrationRegionName;
  int? selectedRegistrationRegionId;

  String? headerImageError;
  String? tournamentNameError;
  String? startDateError;
  String? finishDateError;
  String? startTimeError;
  String? timeZoneError;
  String? aboutError;
  String? contactError;
  String? rulesError;
  String? scheduleError;

  String? gameRegionError;
  String? tournamentFormatError;
  String? bracketFormatError;
  String? tournamentSeedingError;
  String? registrationRegionError;
  String? checkInTimeError;
  String? participantLimitError;
  bool firstPrizeValidate = false;
  bool secondPrizeValidate = false;
  String errorText = '';

  String? contactValueError;

  bool basicInfoValidator() {
    bool isValid = true;

    if (_headerImagePath.isEmpty) {
      headerImageError = LocaleKeys.headerImageIsRequired.tr();
      isValid = false;
    } else {
      headerImageError = null;
    }

    if (tournamentName.text.isEmpty) {
      tournamentNameError = LocaleKeys.nameIsRequired.tr();
      isValid = false;
    } else {
      tournamentNameError = null;
    }

    // Validate Start Date
    if (selectedStartDate == null) {
      startDateError = LocaleKeys.startDateIsRequired.tr();
      isValid = false;
    } else {
      startDateError = null;
    }

    // Validate Finish Date
    if (selectedFinishDate == null) {
      finishDateError = LocaleKeys.endDateIsRequired.tr();
      isValid = false;
    } else if (selectedStartDate != null &&
        selectedFinishDate!.isBefore(selectedStartDate!)) {
      finishDateError = LocaleKeys.endDateCannotBeforeStartDate.tr();
      isValid = false;
    } else {
      finishDateError = null;
    }

    // Validate  Start Time
    if (startTime.text.isEmpty) {
      startTimeError = LocaleKeys.startTimeIsRequired.tr();
      isValid = false;
    } else {
      startTimeError = null;
    }

    // Validate Timezone
    if (timeZoneController.text.isEmpty) {
      timeZoneError = LocaleKeys.timezoneIsRequired.tr();
      isValid = false;
    } else {
      timeZoneError = null;
    }

    // Validate About
    if (controller.document.isEmpty()) {
      aboutError = LocaleKeys.aboutIsRequired.tr();
      isValid = false;
    } else {
      aboutError = null;
    }

    notifyListeners();
    return isValid;
  }

  bool infoDetailValidator() {
    bool isValid = true;

    if (selectedSocialLinkId == null) {
      contactError = LocaleKeys.contactIsRequired.tr();
      isValid = false;
    } else {
      contactError = null;
    }

    if (linkController.text.isEmpty) {
      contactValueError = LocaleKeys.contactValueIsRequired.tr();
      isValid = false;
    } else {
      contactValueError = null;
    }

    if (rulesController.document.isEmpty()) {
      rulesError = LocaleKeys.ruleIsRequired.tr();
      isValid = false;
    } else {
      rulesError = null;
    }

    if (scheduleController.document.isEmpty()) {
      scheduleError = LocaleKeys.scheduleIsRequired.tr();
      isValid = false;
    } else {
      scheduleError = null;
    }

    notifyListeners();
    return isValid;
  }

  bool settingDetailValidator() {
    bool isValid = true;

    // Validate Game Region
    if (selectedRegionName == null) {
      gameRegionError = LocaleKeys.gameRegionIsRequired.tr();
      isValid = false;
    } else {
      gameRegionError = null;
    }

    // Validate Tournament Format
    if (tournamentFormatId == null) {
      tournamentFormatError = LocaleKeys.tournamentFormatIsRequired.tr();
      isValid = false;
    } else {
      tournamentFormatError = null;
    }

    // Validate Bracket Format
    if (bracketFormatId == null) {
      bracketFormatError = LocaleKeys.bracketFormatIsRequired.tr();
      isValid = false;
    } else {
      bracketFormatError = null;
    }

    // Validate Check-In Time
    if (checkTimeId == null) {
      checkInTimeError = LocaleKeys.checkInTimeIsRequired.tr();
      isValid = false;
    } else {
      checkInTimeError = null;
    }

    // Validate Participant Limit
    if (participentsLimit.text.isEmpty ||
        int.tryParse(participentsLimit.text) == null) {
      participantLimitError =
          LocaleKeys.participantLimitIsRequired.tr();
      isValid = false;
    } else {
      participantLimitError = null;
    }

    notifyListeners();
    return isValid;
  }
  //

  void updateFirstPrizeValidation(bool value, String message) {
    firstPrizeValidate = value;
    errorText = message;
    print('value 1------ ${value}');
    print('errorText 1------ ${errorText}');
    notifyListeners();
  }

  void updateSecondPrizeValidation(bool value, String message) {
    secondPrizeValidate = value;
    errorText = message;
    print('value 2------ ${value}');
    notifyListeners();
  }

  void clearNameError() {
    tournamentNameError = '';

    notifyListeners();
  }

  int pagerIndex = 0;

  void updatePagerIndex(int index) {
    print(index);
    pagerIndex = index;
    notifyListeners();
  }

  String _headerImagePath = "";
  String get imageHeaderPath => _headerImagePath;
  set imageHeaderPathSet(String value) {
    _headerImagePath = value;
  }

  void newImageHeaderPath(String pickedImagePath) {
    imageHeaderPathSet = pickedImagePath;
    headerImageError = null;
    notifyListeners();
  }

  int selectedIndex = -1;
  int selectedOrganizationId = 0;
  int selectedGameIndex = -1;
  int selectedGameId = 0;
  DateTime? selectedStartDate;
  DateTime? selectedFinishDate;

  void selectIndex(int index, int id) {
    selectedIndex = index;
    selectedOrganizationId = id;
    notifyListeners();
  }

  void selectGameIndex(int index, int id) {
    selectedGameIndex = index;
    selectedGameId = id;
    notifyListeners();
  }

  void selectStartDate(DateTime date) {
    selectedStartDate = date;
    startDateError = null;
    notifyListeners();
  }

  void selectFinishDate(DateTime date) {
    selectedFinishDate = date;
    finishDateError = null;
    notifyListeners();
  }

  void handleTimeSelection(TimeOfDay selectedTime, context) {
    startTime.text = selectedTime.format(context);
    startTimeError = null;
    notifyListeners();
  }

  void handleTimeZoneSelection(value) {
    timeZoneController.text = value;
    timeZoneError = null;
    notifyListeners();
  }

  String timeZoneName = '';

  Future<void> initializeTimeZone() async {
    final location = tz.getLocation('Asia/Karachi');
    timeZoneName = location.name;
    notifyListeners();
  }

  Map<String, int> socialLinkName = {
    'Discord': 1,
    'Facebook': 2,
    'Youtube': 3,
    'Twitch': 4,
    'Instagram': 5,
    'LinkedIn': 6,
  };

  int? selectedSocialLinkId;

  void setSelectedSocialLink(String link) {
    selectedSocialLinkId = socialLinkName[link];
    contactError = null;
    notifyListeners();
  }

  void handleContactValueChange(String value) {
    linkController.text = value;
    contactValueError = null;
    notifyListeners();
  }

  Map<String, int> bracketFormatName = {
    "Single Elimination": 1,
    "Double Elimination": 2,
  };

  int? bracketFormatId;

  void setSelectedBracketFormat(String region) {
    bracketFormatId = bracketFormatName[region];
    bracketFormatError = null;
    notifyListeners();
  }

  Map<String, int> tournamentSeedingName = {
    "Random Seeding": 1,
    "Custom Seeding": 2,
  };

  int? tournamentSeedingId;

  void tournamentSeeding(String seeding) {
    tournamentSeedingId = tournamentSeedingName[seeding];
    notifyListeners();
  }

  Map<String, int> tournamentFormatName = {
    "1v1": 1,
    "Team v Team": 2,
  };

  int? tournamentFormatId;

  void setSelectedTournamentFormat(String region) {
    tournamentFormatId = tournamentFormatName[region];
    tournamentFormatError = null;
    notifyListeners();
  }

  Map<String, int> checkTime = {
    "10 Minutes": 1,
    "15 Minutes": 2,
    "20 Minutes": 3,
    "30 Minutes": 4,
    "40 Minutes": 5,
    "50 Minutes": 6,
    "60 Minutes": 7,
  };

  int? checkTimeId;

  void setSelectedCheckTime(String region) {
    checkTimeId = checkTime[region];
    checkInTimeError = null;
    notifyListeners();
  }

  List<GameModel> gameData = [];

  getGames() async {
    isLoading = true;
    // notifyListeners();

    try {
      final response = await sharedWebService.getGames();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        gameData = response.games!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<OrganizationsModel> organizationData = [];
  bool isLoading = false;

  getMyOrganization() async {
    isLoading = true;
    // notifyListeners();

    try {
      final response = await sharedWebService.getMyOrganization();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        organizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<IBaseResponse> createTournament() async {
    List aboutdeltaJson = controller.document.toDelta().toJson();
    String about = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    List rulesdeltaJson = rulesController.document.toDelta().toJson();
    String rules = DeltaToHTML.encodeJson(rulesdeltaJson).toString();
    List scheduledeltaJson = scheduleController.document.toDelta().toJson();
    String schedule = DeltaToHTML.encodeJson(scheduledeltaJson).toString();
    try {
      final response = await sharedWebService.createTournament(
          org_id: selectedOrganizationId.toString(),
          gameId: selectedGameId.toString(),
          banner: _headerImagePath,
          name: tournamentName.text,
          dateInitial: selectedStartDate.toString(),
          dateFinal: selectedFinishDate.toString(),
          start_time: startTime.text,
          timeZone: timeZoneController.text,
          about: about,
          contact_option: selectedSocialLinkId.toString(),
          rules: rules,
          schedule: schedule,
          region_id: selectedRegionId.toString(),
          tournament_format: tournamentFormatId.toString(),
          bracket_format: bracketFormatId.toString(),
          registration_regions: selectedRegisterRegions.toString(),
          registration_region: selectedRegisterRegionsIndex.toString(),
          check_in_time: checkTimeId.toString(),
          registration_participant_limit: participentsLimit.text,
          contact_value: linkController.text,
          first_prize: firstPrizeController.text,
          second_prize: secondPrizeController.text,
          is_reward: selectedprizeindex.toString());
      print('response in api-------------${response.toString()}');
      return response;
    } catch (error) {
      log(error.toString());
      return StatusMessageResponse(
        status: 400,
        message: "Invalid Data",
      );
    }
  }

  List<Country>? countryData;

  Future<void> getRegions() async {
    try {
      final response = await sharedWebService.getRegion();
      if (response.status == 200 && response.countryData!.isNotEmpty) {
        countryData = response.countryData;
        print('country data ------------ $countryData');
        notifyListeners();
      } else {
        // emit(state.copyWith(countryList: []));
      }
    } catch (error) {}
  }

  Country? selectedCountry;
  // Set Selected Region
  void setSelectedRegion(Country selectedRegion) {
    selectedCountry = selectedRegion;
    selectedRegionName = selectedRegion.name;
    selectedRegionId = selectedRegion.id;
    selectedgameregion.text = selectedRegion.name;
    selectedgameregionid.text = selectedRegion.id.toString();
    gameRegionError = null;
    notifyListeners();
  }

  // Set Selected Region
  void setSelectedRegistrationRegion(Country selectedRegion) {
    selectedRegistrationRegionName = selectedRegion.name;
    selectedRegistrationRegionId = selectedRegion.id;
    selectedRegistrationRegionController.text = selectedRegion.name;
    selectedRegistrationRegionIdController.text = selectedRegion.id.toString();
    notifyListeners();
  }

  int selectedprizeindex = 0;

  updatePrizeIndex(int index) {
    selectedprizeindex = index;
    notifyListeners();
  }

  int userBalance = 0;
  Future<void> getbalance() async {
    try {
      final response = await sharedWebService.getbalance();
      if (response.status == 200 && response.balance != null) {
        userBalance = response.balance!;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  void handleTournamentNameChange(String value) {
    tournamentName.text = value;
    tournamentNameError = null;
    notifyListeners();
  }

  void handleAboutChange() {
    if (!controller.document.isEmpty()) {
      aboutError = null;
      notifyListeners();
    }
  }

  void handleParticipantLimitChange(String value) {
    participentsLimit.text = value;
    participantLimitError = null;
    notifyListeners();
  }
}
