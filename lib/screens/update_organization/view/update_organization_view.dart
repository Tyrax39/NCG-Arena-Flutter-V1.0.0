import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/screens/update_organization/view/add_link_detail_view.dart';
import 'package:neoncave_arena/screens/update_organization/view/basic_form_view.dart';
import 'package:neoncave_arena/screens/update_organization/view_model/update_organization_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateOrganization extends StatefulWidget {
  final int id;
  const UpdateOrganization({super.key, required this.id});

  @override
  State<UpdateOrganization> createState() => _UpdateOrganizationState();
}

class _UpdateOrganizationState extends State<UpdateOrganization> {
  late final UpdateOrganizationViewModel _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<UpdateOrganizationViewModel>();
    _provider.getOrganizationData(widget.id);
  }

  @override
  void dispose() {
    _provider.disposeFunction();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final organizationVm =
        Provider.of<UpdateOrganizationViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.updateOrganization.tr()),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: LinearProgressIndicator(
                value: (organizationVm.pagerIndex + 1) / 2,
                backgroundColor: Colors.grey[200],
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepIndicator(1, LocaleKeys.basicInfo.tr(),
                      organizationVm.pagerIndex >= 0),
                  _buildStepDivider(),
                  _buildStepIndicator(2, LocaleKeys.socialLinks.tr(),
                      organizationVm.pagerIndex >= 1),
                ],
              ),
            ),
            // Page content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.screenBG,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: PageView.builder(
                  controller: organizationVm.pageSliderController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    organizationVm.updatePagerIndex(index);
                  },
                  itemBuilder: (context, index) {
                    return Consumer<UpdateOrganizationViewModel>(
                      builder: (context, value, child) {
                        return value.pagerIndex == 0
                            ? const UpdateOrganizationBasicForm()
                            : value.pagerIndex == 1
                                ?  UpdateOrganizationSocialLinks(orgId: widget.id,)
                                : const SizedBox();
                      },
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColor.primaryColor : Colors.grey[300],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColor.primaryColor : Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 1,
        color: Colors.grey[300],
        margin: const EdgeInsets.symmetric(horizontal: 25),
      ),
    );
  }
}
