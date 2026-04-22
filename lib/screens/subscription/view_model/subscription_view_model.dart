import 'dart:developer';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/cupertino.dart';

class SubscriptionViewModel extends ChangeNotifier {
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  void selectPlan(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  DialogHelper get dialogHelper => DialogHelper.instance();
  final SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool isLoading = false;
  bool isSubscribing = false;

  // Getter to check if any subscription operation is in progress
  bool get isProcessing => isLoading || isSubscribing;

  Future<IBaseResponse> subscribeToPlan(int packageId, BuildContext context,
      {String? stripeSubscriptionId}) async {
    try {
      isSubscribing = true;
      notifyListeners();

      // Use the existing upgradePro method which handles subscription
      final response = await sharedWebService.upgradePro(
        id: packageId,
        subId: stripeSubscriptionId ?? '', // Use empty string if no stripe ID
      );

      if (response.status == 200) {
        // Refresh user data and packages to show updated subscription status
        await Future.wait([
          getUserData(),
          getProPakages(),
        ]);
      }

      return response;
    } catch (error) {
      log('Subscribe error: $error');
      return StatusMessageResponse(
          status: 400, message: "Something went wrong during subscription");
    } finally {
      isSubscribing = false;
      notifyListeners();
    }
  }

  UserDataModel? userdata;
  Future<void> getUserData() async {
    final user = await sharedPreferenceHelper.user;
    if (user != null) {
      try {
        isLoading = true;
        notifyListeners();
        final response = await sharedWebService.getUserDataWithId(id: user.id!);
        if (response.status == 200 && response.userdata != null) {
          userdata = response.userdata;
        }
      } catch (error) {
        log(error.toString());
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  List<ProPackage>? packagesData;
  Future<void> getProPakages() async {
    final user = await sharedPreferenceHelper.user;
    if (user != null) {
      try {
        isLoading = true;
        notifyListeners();
        final response = await sharedWebService.getProPakagesApi();
        if (response.status == 200 && response.packagesData != null) {
          packagesData = response.packagesData;
        }
      } catch (error) {
        log("PROOOOOOOO ERRORRRR  $error");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
