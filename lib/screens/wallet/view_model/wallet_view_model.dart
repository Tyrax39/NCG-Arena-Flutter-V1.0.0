import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/backend/site_setting_model.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class WalletViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  TextEditingController paypalEmail = TextEditingController();
  TextEditingController amount = TextEditingController();

  TextEditingController fullName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController iban = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController swiftCode = TextEditingController();

  String? paypalEmailError;
  String? amountError;
  String? nameError;
  String? addressError;
  String? bankNameError;
  String? accountNumberError;
  String? ibanError;
  String? countryError;
  String? swiftCodeError;

  bool paypalValidator() {
    bool isValid = true;

    if (paypalEmail.text.isEmpty) {
      paypalEmailError = LocaleKeys.emailIsRequired.tr();
      isValid = false;
    } else {
      paypalEmailError = '';
    }

    if (amount.text.isEmpty) {
      amountError = LocaleKeys.amountIsRequired.tr();
      isValid = false;
    } else {
      amountError = '';
    }

    notifyListeners();
    return isValid;
  }

  bool bankValidator() {
    bool isValid = true;

    if (amount.text.isEmpty) {
      amountError = LocaleKeys.amountIsRequired.tr();
      isValid = false;
    } else {
      amountError = '';
    }

    if (fullName.text.isEmpty) {
      nameError = LocaleKeys.nameIsRequired.tr();
      isValid = false;
    } else {
      nameError = '';
    }

    if (address.text.isEmpty) {
      addressError = LocaleKeys.addressIsRequired.tr();
      isValid = false;
    } else {
      addressError = '';
    }

    if (bankName.text.isEmpty) {
      bankNameError = LocaleKeys.bankNameIsRequired.tr();
      isValid = false;
    } else {
      bankNameError = '';
    }

    if (accountNumber.text.isEmpty) {
      accountNumberError = LocaleKeys.accountNumberIsRequired.tr();
      isValid = false;
    } else {
      accountNumberError = '';
    }

    if (iban.text.isEmpty) {
      ibanError = LocaleKeys.ibanIsRequired.tr();
      isValid = false;
    } else {
      ibanError = '';
    }

    if (country.text.isEmpty) {
      countryError = LocaleKeys.countryIsRequired.tr();
      isValid = false;
    } else {
      countryError = '';
    }

    if (swiftCode.text.isEmpty) {
      swiftCodeError = LocaleKeys.swiftCodeIsRequired.tr();
      isValid = false;
    } else {
      swiftCodeError = '';
    }

    notifyListeners();
    return isValid;
  }

  void emptyPaypalEmailErrors() {
    paypalEmailError = '';
    notifyListeners();
  }

  void emptyAmountErrors() {
    amountError = '';
    notifyListeners();
  }

  void emptyNameErrors() {
    nameError = '';
    notifyListeners();
  }

  void emptyAddressErrors() {
    addressError = '';
    notifyListeners();
  }

  void emptyBankNameErrors() {
    bankNameError = '';
    notifyListeners();
  }

  void emptyAccountNumberErrors() {
    accountNumberError = '';
    notifyListeners();
  }

  void emptyIbanErrors() {
    ibanError = '';
    notifyListeners();
  }

  void emptyCountryErrors() {
    countryError = '';
    notifyListeners();
  }

  void emptySwiftCodeErrors() {
    swiftCodeError = '';
    notifyListeners();
  }

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    userData = user;
    notifyListeners();
  }

  int userBalance = 0;
  Future<void> getbalance() async {
    try {
      final response = await sharedWebService.getbalance();
      if (response.status == 200 && response.balance != null) {
        userBalance = response.balance!;
        notifyListeners();
      } else {
        userBalance = 0;
        notifyListeners();
      }
    } catch (error) {
      userBalance = 0;
      notifyListeners();
    }
  }

  Future<IBaseResponse> addBalance(transactionId, methodId) async {
    try {
      final response = await sharedWebService.addBalance(
          transactionId: transactionId, methodId: methodId);
      debugPrint(response.toString());
      if (response.status == 200 && response.message.isNotEmpty) {
        getbalance();
        getDepositHistory();
        notifyListeners();
      }
      return response;
    } catch (error) {
      debugPrint("Error in add balance $error");
      return StatusMessageResponse(status: 400, message: "Invalid Data");
    }
  }

  bool isLoading = false;
  List<TransactionHistory> transactionData = [];

  Future<void> getTransactions() async {
    isLoading = true;
    try {
      final response = await sharedWebService.getTransactions();
      if (response.status == 200 && response.transactionData != null) {
        transactionData = response.transactionData!;

        debugPrint('transactionData----${transactionData}');
        notifyListeners();
      }
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  SiteSetting? settingData;
  Future<void> siteSettingData() async {
    isLoading = true;
    try {
      final response = await sharedWebService.siteSettingData();
      if (response.status == 200 && response.setting != null) {
        settingData = response.setting!;
        print('settingData----${settingData!.stripePrivateKey}');
        notifyListeners();
      }
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<WithdrawHistory> withdrawHistoryData = [];

  Future<void> getWithdrawHistory() async {
    isLoading = true;
    notifyListeners();
    try {
      final response =
          await sharedWebService.getWithdrawHistory(userid: userData!.id!);
      if (response.status == 200 && response.withdrawData != null) {
        withdrawHistoryData = response.withdrawData!;
        print('user id ----------${userData!.id!}');
        debugPrint('withdrawHistoryData----${withdrawHistoryData.length}');
        notifyListeners();
      }
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<DepositHistory> depositHistoryData = [];

  Future<void> getDepositHistory() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await sharedWebService.getDepositHistory();
      if (response.status == 200 && response.depositData != null) {
        depositHistoryData = response.depositData!;
        debugPrint('withdrawHistoryData----${depositHistoryData}');
        notifyListeners();
      }
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<IBaseResponse> withdrawRequest(String type) async {
    try {
      final response = await sharedWebService.withdrawRequest(
        type: type,
        paypalEmail: paypalEmail.text,
        amount: amount.text,
        fullName: fullName.text,
        address: address.text,
        bankName: bankName.text,
        account: accountNumber.text,
        iban: iban.text,
        country: country.text,
        swiftcode: swiftCode.text,
      );
      print('response in api-------------${response.toString()}');
      return response;
    } catch (error) {
      print("error--------------${error.toString()}");
      return StatusMessageResponse(
        status: 400,
        message: "Invalid Data",
      );
    }
  }

  bool hasSearched = false;
  List<UserDataModel> searchUsers = [];

  void clearSearchUsers() {
    searchUsers.clear();
    notifyListeners();
  }

  UserDataModel? selectedUser;

  updateSelectedUser(UserDataModel? user) {
    selectedUser = user;
    notifyListeners();
  }

  Future<void> searchAPI(BuildContext context, String searchQuery) async {
    if (searchQuery.length <= 3) return;
    isLoading = true;
    notifyListeners();
    try {
      final searchText = searchQuery.trim();
      if (searchText.isEmpty) return;
      hasSearched = true;
      notifyListeners();

      final response =
          await sharedWebService.getSearchResults(searchText, 'user');
      if (response.status == 200) {
        searchUsers = response.users ?? [];
        notifyListeners();
      }
    } catch (e) {
      print('Search API Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<IBaseResponse> transferCoins(
      {String? amount, String? userId, String? password}) async {
    try {
      final response = await sharedWebService.transferBalance(
        amount: amount,
        toUserId: userId,
        password: password,
      );
      if (response.status == 200) {
        getbalance();
        getTransactions();
        notifyListeners();
      }
      return response;
    } catch (error) {
      print("Error in transfer coins: $error");
      return StatusMessageResponse(
        status: 400,
        message: "Transfer failed. Please try again.",
      );
    }
  }
}
