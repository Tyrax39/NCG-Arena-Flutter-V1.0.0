import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/organization_detail/view/components/organization_contact_view.dart';
import 'package:neoncave_arena/screens/organization_detail/view_model/organization_detail_view_model.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

class OrganizationDetail extends StatefulWidget {
  final OrganizationsModel organizationData;
  const OrganizationDetail({super.key, required this.organizationData});

  @override
  State<OrganizationDetail> createState() => _OrganizationDetailState();
}

class _OrganizationDetailState extends State<OrganizationDetail> {
  late final OrganizationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OrganizationViewModel();
    // Initialize with organization data and load first tab (tournaments) data
    _viewModel.initializeData(widget.organizationData);
  }

  @override
  void dispose() {
    _viewModel.resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColor.screenBG,
        body: Consumer<OrganizationViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.organizationData == null) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.primaryColor,
                  radius: 20,
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderImage(viewModel),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.h(10),
                        _buildOrganizationInfo(viewModel),
                        Gap.h(15),
                        if (viewModel.organizationData!.description != null)
                          _buildDescription(viewModel),
                        Gap.h(15),
                        _buildTabBar(viewModel),
                        _buildTabContent(viewModel),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderImage(OrganizationViewModel viewModel) {
    return Stack(
      children: [
        SizedBox(
          height: AppConfig(context).height * 0.25,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: viewModel.organizationData!.headerImage ?? '',
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: AppColor.primaryColor.withOpacity(0.3),
              child: Image.asset(
                CustomAssets.placeholder,
                fit: BoxFit.cover,
              ),
            ),
            placeholder: (context, url) => Container(
              color: AppColor.primaryColor.withOpacity(0.3),
              child: Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: 50,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.grey.withOpacity(0.7),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationInfo(OrganizationViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Organization basic info
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: viewModel.organizationData!.logo != null
                    ? CachedNetworkImage(
                        imageUrl: viewModel.organizationData!.logo!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Image.asset(CustomAssets.placeholder),
                        placeholder: (context, url) => Center(
                          child: CupertinoActivityIndicator(
                            color: AppColor.primaryColor,
                            radius: 12,
                          ),
                        ),
                      )
                    : Container(color: Colors.grey[200]),
              ),
            ),
            Gap.w(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: viewModel.organizationData?.name ?? 'Unknown Organization',
                    color: AppColor.black,
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap.h(8),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: AppColor.primaryColor,
                      ),
                      Gap.w(5),
                      CustomText(
                        title:
                            "${viewModel.organizationData!.followersCount} ${LocaleKeys.followers.tr()}",
                        color: AppColor.grey,
                        size: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Gap.h(5),
                  if (viewModel.organizationData!.userdata?.username != null)
                    Row(
                      children: [
                        Icon(
                          Icons.alternate_email,
                          size: 16,
                          color: AppColor.primaryColor,
                        ),
                        Gap.w(5),
                        Expanded(
                          child: CustomText(
                            title:
                                '@${viewModel.organizationData!.userdata!.username!}',
                            color: AppColor.grey,
                            size: 12,
                            alignment: TextAlign.start,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        Gap.h(15),
        _buildActionSection(viewModel),
      ],
    );
  }

  Widget _buildActionSection(OrganizationViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.primaryColor.withOpacity(0.05),
        border: Border.all(
          color: AppColor.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: _getActionTitle(viewModel),
                  color: AppColor.black,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
                Gap.h(2),
                CustomText(
                  title: _getActionSubtitle(viewModel),
                  color: AppColor.grey,
                  size: 12,
                  alignment: TextAlign.start,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Gap.w(10),
          _buildActionButton(viewModel),
        ],
      ),
    );
  }

  String _getActionTitle(OrganizationViewModel viewModel) {
    if (viewModel.userData?.id == viewModel.organizationData!.userdata!.id) {
      return LocaleKeys.createChannel.tr();
    } else if (viewModel.organizationData!.isFollowing == 1) {
      return LocaleKeys.followed.tr();
    } else {
      return LocaleKeys.follow.tr();
    }
  }

  String _getActionSubtitle(OrganizationViewModel viewModel) {
    if (viewModel.userData?.id == viewModel.organizationData!.userdata!.id) {
      return "Start broadcasting live streams";
    } else if (viewModel.organizationData!.isFollowing == 1) {
      return "You are following this organization";
    } else {
      return "Get updates from this organization";
    }
  }

  Widget _buildDescription(OrganizationViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: LocaleKeys.description.tr(),
          color: AppColor.black,
          size: 16,
          fontWeight: FontWeight.w600,
        ),
        Gap.h(5),
        HtmlWidget(
          '<p style="text-align: justify;">${viewModel.organizationData!.description!}</p>',
          renderMode: RenderMode.column,
          textStyle: TextStyle(
            fontSize: 13,
            color: AppColor.black,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(OrganizationViewModel viewModel) {
    final List<String> tabTitles = [
      LocaleKeys.tournaments.tr(),
      LocaleKeys.channels.tr(),
      LocaleKeys.contacts.tr(),
    ];

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabTitles.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => viewModel.setSelectedTabIndex(index),
            child: SizedBox(
              width: AppConfig(context).width * .3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    title: tabTitles[index],
                    size: 14,
                    color: viewModel.selectedTabIndex == index
                        ? AppColor.primaryColor
                        : AppColor.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap.h(2),
                  viewModel.selectedTabIndex == index
                      ? Container(
                          height: 2,
                          width: index == 0 ? 90 : 70,
                          color: AppColor.primaryColor)
                      : const SizedBox(height: 2, width: 60)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(OrganizationViewModel viewModel) {
    if (viewModel.organizationData?.id == null) return const SizedBox();

    switch (viewModel.selectedTabIndex) {
      case 0:
        return _buildTournamentTab(viewModel);
      case 1:
        return _buildChannelsTab(viewModel);
      case 2:
        return OrganizationContact(
          organization: viewModel.organizationData!,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTournamentTab(OrganizationViewModel viewModel) {
    if (viewModel.isTournamentLoading) {
      return _buildLoadingState(LocaleKeys.loading.tr());
    }

    if (viewModel.tournamentData.isEmpty && viewModel.hasLoadedTournaments) {
      return _buildEmptyState(
        Icons.emoji_events_outlined,
        "No Tournaments Found",
        "This organization hasn't created any tournaments yet.",
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.tournamentData.length,
      itemBuilder: (context, index) {
        var tournamentData = viewModel.tournamentData[index];
        return _buildTournamentCard(tournamentData);
      },
    );
  }

  Widget _buildChannelsTab(OrganizationViewModel viewModel) {
    if (viewModel.isChannelLoading) {
      return _buildLoadingState(LocaleKeys.loading.tr());
    }

    if (viewModel.channelData.isEmpty && viewModel.hasLoadedChannels) {
      return _buildEmptyState(
        Icons.live_tv_outlined,
        "No Channels Found",
        "This organization hasn't created any live channels yet.",
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.channelData.length,
      itemBuilder: (context, index) {
        var channelData = viewModel.channelData[index];
        return _buildChannelCard(channelData);
      },
    );
  }

  Widget _buildLoadingState(String message) {
    return Container(
      height: AppConfig(context).height * 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ),
            Gap.h(12),
            CustomText(
              title: message,
              color: AppColor.grey,
              size: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      height: AppConfig(context).height * 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColor.grey.withOpacity(0.5),
              size: 60,
            ),
            Gap.h(12),
            CustomText(
              title: title,
              color: AppColor.black,
              size: 16,
              fontWeight: FontWeight.w600,
            ),
            Gap.h(5),
            CustomText(
              title: subtitle,
              color: AppColor.grey,
              size: 12,
              alignment: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentCard(dynamic tournamentData) {
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(
          context,
          MyRoutes.tournamentDetailScreen,
          arguments: tournamentData,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColor.offwhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppConfig(context).height * .15,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: tournamentData.banner ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset(CustomAssets.placeholder),
                  placeholder: (context, url) => Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.primaryColor,
                      radius: 12,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h(10),
                  CustomText(
                    title: tournamentData.gameName ?? '',
                    color: AppColor.primaryColor,
                    size: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    title: tournamentData.name?.toString() ?? '',
                    color: AppColor.black,
                    size: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap.h(5),
                  CustomText(
                    title: 'Hosted By:',
                    color: AppColor.black,
                    size: 9,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomText(
                    title: tournamentData.organization?.name ?? '',
                    color: AppColor.primaryColor,
                    size: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColor.primaryColor,
                        size: 9,
                      ),
                      Gap.w(5),
                      CustomText(
                        title: tournamentData.dateIni != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(tournamentData.dateIni!)
                            : '',
                        color: AppColor.black,
                        size: 9,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.emoji_events,
                        color: AppColor.primaryColor,
                        size: 10,
                      ),
                      Gap.w(5),
                      CustomText(
                        title: tournamentData.isReward == 0
                            ? 'No Prize'
                            : tournamentData.isReward?.toString() ?? 'No Prize',
                        color: AppColor.black,
                        size: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap.h(10),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelCard(dynamic channelData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.offwhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                MyRoutes.channelDetailScreen,
                arguments: channelData,
              );
            },
            child: SizedBox(
              height: 160,
              width: AppConfig(context).width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: channelData.header ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset(CustomAssets.placeholder),
                  placeholder: (context, url) => Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.primaryColor,
                      radius: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: channelData.logo ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Image.asset(CustomAssets.placeholder),
                      placeholder: (context, url) => Center(
                        child: CupertinoActivityIndicator(
                          color: AppColor.primaryColor,
                          radius: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap.w(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: channelData.name?.toString() ?? '',
                      color: AppColor.black,
                      size: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    Gap.h(3),
                    Row(
                      children: [
                        Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.red,
                          ),
                        ),
                        Gap.w(4),
                        CustomText(
                          title: channelData.followerCount == 1 ||
                                  channelData.followerCount == 0
                              ? "${channelData.followerCount?.toString() ?? '0'} ${LocaleKeys.subscriber.tr()}"
                              : "${channelData.followerCount?.toString() ?? '0'} ${LocaleKeys.subscribers.tr()}",
                          color: AppColor.black,
                          size: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(OrganizationViewModel viewModel) {
    if (viewModel.userData?.id == viewModel.organizationData!.userdata!.id) {
      return _buildButton(
        LocaleKeys.createChannel.tr(),
        () {
          Navigator.pushNamed(
            context,
            MyRoutes.createChannel,
            arguments: [viewModel.organizationData!.id.toString()],
          );
        },
      );
    } else if (viewModel.organizationData!.isFollowing == 1) {
      return _buildButton(
        viewModel.isFollowLoading ? LocaleKeys.loading.tr() : LocaleKeys.followed.tr(), 
        viewModel.isFollowLoading ? () {} : () {
          viewModel.followOrganization(
            viewModel.organizationData?.id ?? 0,
            context,
          );
        },
        isLoading: viewModel.isFollowLoading,
      );
    } else {
      return _buildButton(
        viewModel.isFollowLoading ? LocaleKeys.loading.tr() : LocaleKeys.follow.tr(), 
        viewModel.isFollowLoading ? () {} : () {
          viewModel.followOrganization(
            viewModel.organizationData?.id ?? 0,
            context,
          );
        },
        isLoading: viewModel.isFollowLoading,
      );
    }
  }

  Widget _buildButton(String text, VoidCallback onTap, {bool isLoading = false}) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isLoading ? AppColor.primaryColor.withOpacity(0.7) : AppColor.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 10,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      title: text,
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                )
              : CustomText(
                  title: text,
                  color: Colors.white,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ),
    );
  }
}
