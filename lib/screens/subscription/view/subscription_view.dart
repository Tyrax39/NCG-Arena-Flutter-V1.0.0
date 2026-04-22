// ignore_for_file: use_build_context_synchronously

import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/subscription/view_model/subscription_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});
  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin {
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  DialogHelper dialogHelper = DialogHelper.instance();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionViewModel>().getProPakages();
      context.read<SubscriptionViewModel>().getUserData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.subscription.tr()),
      body: Container(
        height: AppConfig(context).height,
        width: AppConfig(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.screenBG, AppColor.screenBG.withOpacity(0.9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: CustomText(
                  title: "Choose your plan",
                  size: 20,
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Consumer<SubscriptionViewModel>(
                  builder: (context, subscriptionVm, child) {
                    if (subscriptionVm.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(
                              color: AppColor.primaryColor,
                              radius: 20,
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              title: "Loading plans...",
                              color: AppColor.black.withOpacity(0.7),
                            ),
                          ],
                        ),
                      );
                    }
                    if (subscriptionVm.packagesData == null ||
                        subscriptionVm.userdata == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 40,
                              color: AppColor.primaryColor.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              title: LocaleKeys.noProPackagesAvailable.tr(),
                              color: AppColor.black,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: subscriptionVm.packagesData!.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final package = subscriptionVm.packagesData![index];
                        bool isSubscribed = package.isSubscribed == 1;

                        return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(
                                    0.1 * index,
                                    0.1 * index + 0.8,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(
                                      0.1 * index,
                                      0.1 * index + 0.8,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSubscribed
                                          ? AppColor.green
                                          : AppColor.primaryColor,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppColor.offwhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSubscribed
                                            ? AppColor.green.withOpacity(0.15)
                                            : AppColor.primaryColor
                                                .withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: isSubscribed
                                            ? AppColor.green.withOpacity(0.1)
                                            : AppColor.primaryColor
                                                .withOpacity(0.1),
                                        highlightColor: isSubscribed
                                            ? AppColor.green.withOpacity(0.05)
                                            : AppColor.primaryColor
                                                .withOpacity(0.05),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header section with ribbon for current plan
                                            if (isSubscribed)
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: AppColor.green
                                                      .withOpacity(0.1),
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppColor.green
                                                          .withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: AppColor.green,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    CustomText(
                                                      title: "Current Plan",
                                                      color: AppColor.green,
                                                      size: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomText(
                                                          title: package
                                                              .packageName
                                                              .toString(),
                                                          size: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: isSubscribed
                                                              ? AppColor.green
                                                              : AppColor
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isSubscribed
                                                              ? AppColor.green
                                                                  .withOpacity(
                                                                      0.1)
                                                              : AppColor
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            CustomText(
                                                              title:
                                                                  '\$${package.packagePrice!.toInt()}',
                                                              size: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: isSubscribed
                                                                  ? AppColor
                                                                      .green
                                                                  : AppColor
                                                                      .primaryColor,
                                                            ),
                                                            const SizedBox(
                                                                width: 2),
                                                            CustomText(
                                                              title:
                                                                  '/${package.time}',
                                                              size: 12,
                                                              color: isSubscribed
                                                                  ? AppColor
                                                                      .green
                                                                  : AppColor
                                                                      .primaryColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  const Divider(height: 1),
                                                  const SizedBox(height: 6),
                                                  // Features section
                                                  CustomText(
                                                    title: "Features:",
                                                    size: 16,
                                                    color: AppColor.black,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  FeatureRow(
                                                    title: 'Duration',
                                                    value: package.time!,
                                                    isHighlighted: true,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  FeatureRow(
                                                    title: 'Portfolio Media',
                                                    value:
                                                        '${package.portfolioMedia}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  FeatureRow(
                                                    title: 'Tournament Limit',
                                                    value:
                                                        '${package.tournamentLimit}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  FeatureRow(
                                                    title: 'Live Stream',
                                                    value:
                                                        '${package.liveStream}',
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Buttons section
                                                  if (package.id == 1) ...[
                                                    package.isSubscribed == 1
                                                        ? SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: PrimaryBTN(
                                                              callback: () {},
                                                              color: AppColor
                                                                  .green,
                                                              borderRadius: 12,
                                                              title:
                                                                  'Current Subscription',
                                                              width: AppConfig(
                                                                      context)
                                                                  .width,
                                                            ))
                                                        : SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: PrimaryBTN(
                                                              callback:
                                                                  () async {
                                                                if (subscriptionVm
                                                                    .isSubscribing)
                                                                  return;

                                                                dialogHelper
                                                                  ..injectContext(
                                                                      context)
                                                                  ..showProgressDialog(
                                                                      'Processing subscription...');

                                                                try {
                                                                  final response =
                                                                      await subscriptionVm
                                                                          .subscribeToPlan(
                                                                    package.id!,
                                                                    context,
                                                                  );
                                                                  dialogHelper
                                                                      .dismissProgress();

                                                                  if (response
                                                                          .status ==
                                                                      200) {
                                                                    snackbarHelper
                                                                      ..injectContext(
                                                                          context)
                                                                      ..showSnackbar(
                                                                        snackbarMessage:
                                                                            SnackbarMessage(
                                                                          content:
                                                                              response.message ?? 'Successfully subscribed to plan!',
                                                                          isLongMessage:
                                                                              false,
                                                                          isForError:
                                                                              false,
                                                                        ),
                                                                      );
                                                                  } else {
                                                                    snackbarHelper
                                                                      ..injectContext(
                                                                          context)
                                                                      ..showSnackbar(
                                                                        snackbarMessage:
                                                                            SnackbarMessage(
                                                                          content:
                                                                              response.message ?? 'Failed to subscribe. Please try again.',
                                                                          isLongMessage:
                                                                              false,
                                                                          isForError:
                                                                              true,
                                                                        ),
                                                                      );
                                                                  }
                                                                } catch (error) {
                                                                  dialogHelper
                                                                      .dismissProgress();
                                                                  snackbarHelper
                                                                    ..injectContext(
                                                                        context)
                                                                    ..showSnackbar(
                                                                      snackbarMessage:
                                                                          const SnackbarMessage(
                                                                        content:
                                                                            'Network error. Please check your connection and try again.',
                                                                        isLongMessage:
                                                                            false,
                                                                        isForError:
                                                                            true,
                                                                      ),
                                                                    );
                                                                }
                                                              },
                                                              color: AppColor
                                                                  .primaryColor,
                                                              title: subscriptionVm
                                                                      .isSubscribing
                                                                  ? 'Processing...'
                                                                  : 'Subscribe',
                                                              borderRadius: 12,
                                                              width: AppConfig(
                                                                      context)
                                                                  .width,
                                                            )),
                                                  ] else ...[
                                                    package.isSubscribed == 1
                                                        ? Column(
                                                            children: [
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    PrimaryBTN(
                                                                  callback:
                                                                      () {},
                                                                  borderRadius:
                                                                      12,
                                                                  color: AppColor
                                                                      .green,
                                                                  title:
                                                                      'Current Subscription',
                                                                  width: AppConfig(
                                                                          context)
                                                                      .width,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                            ],
                                                          )
                                                        : SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: PrimaryBTN(
                                                              callback:
                                                                  () async {
                                                                if (subscriptionVm
                                                                    .isSubscribing)
                                                                  return;

                                                                dialogHelper
                                                                  ..injectContext(
                                                                      context)
                                                                  ..showProgressDialog(
                                                                      'Processing subscription...');

                                                                try {
                                                                  final response =
                                                                      await subscriptionVm
                                                                          .subscribeToPlan(
                                                                    package.id!,
                                                                    context,
                                                                  );
                                                                  dialogHelper
                                                                      .dismissProgress();

                                                                  if (response
                                                                          .status ==
                                                                      200) {
                                                                    snackbarHelper
                                                                      ..injectContext(
                                                                          context)
                                                                      ..showSnackbar(
                                                                        snackbarMessage:
                                                                            SnackbarMessage(
                                                                          content:
                                                                              response.message ?? 'Successfully subscribed to plan!',
                                                                          isLongMessage:
                                                                              false,
                                                                          isForError:
                                                                              false,
                                                                        ),
                                                                      );
                                                                  } else {
                                                                    snackbarHelper
                                                                      ..injectContext(
                                                                          context)
                                                                      ..showSnackbar(
                                                                        snackbarMessage:
                                                                            SnackbarMessage(
                                                                          content:
                                                                              response.message ?? 'Failed to subscribe. Please try again.',
                                                                          isLongMessage:
                                                                              false,
                                                                          isForError:
                                                                              true,
                                                                        ),
                                                                      );
                                                                  }
                                                                } catch (error) {
                                                                  dialogHelper
                                                                      .dismissProgress();
                                                                  snackbarHelper
                                                                    ..injectContext(
                                                                        context)
                                                                    ..showSnackbar(
                                                                      snackbarMessage:
                                                                          const SnackbarMessage(
                                                                        content:
                                                                            'Network error. Please check your connection and try again.',
                                                                        isLongMessage:
                                                                            false,
                                                                        isForError:
                                                                            true,
                                                                      ),
                                                                    );
                                                                }
                                                              },
                                                              color: AppColor
                                                                  .primaryColor,
                                                              title: subscriptionVm
                                                                      .isSubscribing
                                                                  ? 'Processing...'
                                                                  : 'Subscribe',
                                                              width: AppConfig(
                                                                      context)
                                                                  .width,
                                                            ),
                                                          ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isHighlighted;

  const FeatureRow({
    super.key,
    required this.title,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColor.primaryColor.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: AppColor.primaryColor,
          ),
          const SizedBox(width: 10),
          CustomText(
            title: title,
            color: AppColor.black,
          ),
          const Spacer(),
          CustomText(
            title: value,
            color: AppColor.black,
          ),
        ],
      ),
    );
  }
}
