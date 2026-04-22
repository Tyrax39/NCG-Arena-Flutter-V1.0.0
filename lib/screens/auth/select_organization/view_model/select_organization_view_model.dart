// ignore_for_file: use_build_context_synchronously
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';

class SelectOrganizationViewModel extends ChangeNotifier {
  DialogHelper dialogHelper = DialogHelper.instance();
  SharedWebService sharedWebService = SharedWebService.instance();
  final SnackbarHelper _snackbarHelper = SnackbarHelper.instance();

  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  bool isLoading = false;
  List<OrganizationsModel> organizationData = [];

  getOrganization() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await sharedWebService.getAllOrganization();
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        organizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> followOrganization(
      int organizationId, BuildContext context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Loading....');

    try {
      final response =
          await sharedWebService.followOrganization(id: organizationId);
      dialogHelper.dismissProgress();

      if (response.status == 200 && response.message.isNotEmpty) {
        debugPrint('status---------${response.status}');

        getOrganization();

        notifyListeners();

        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage(
              content: response.message,
              isLongMessage: false,
              isForError: false,
            ),
          );
      } else {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: const SnackbarMessage(
              content: 'An error occurred. Please try again.',
              isLongMessage: false,
              isForError: true,
            ),
          );
      }
    } catch (error) {
      dialogHelper.dismissProgress();
      debugPrint(error.toString());
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: const SnackbarMessage(
            content: 'Failed to follow/unfollow the user. Please try again.',
            isLongMessage: false,
            isForError: true,
          ),
        );
    }
  }
}
