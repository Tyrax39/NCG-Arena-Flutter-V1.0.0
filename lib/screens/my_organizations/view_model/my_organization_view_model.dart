import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';
import '../../../backend/server_response.dart';

class MyOrganizationViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  bool isLoading = false;
  List<OrganizationsModel> organizationData = [];

  getMyOrganization(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
          await sharedWebService.getMyOrganization(context: context);
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
}
