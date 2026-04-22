import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/add_player_team/view_model/team_create_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddTeamView extends StatefulWidget {
  final String teamId;

  const AddTeamView({
    super.key,
    required this.teamId,
  });

  @override
  State<AddTeamView> createState() => _AddTeamViewState();
}

class _AddTeamViewState extends State<AddTeamView> {
  @override
  initState() {
    context.read<TeamCreateViewModel>().searchController.text = '';
    context.read<TeamCreateViewModel>().users.clear();
    context.read<TeamCreateViewModel>().selectedUserId = '';

    super.initState();
  }

  Widget _buildInitialState(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppConfig(context).height * .2,
        ),
        Center(
          child: SizedBox(
            width: 170,
            child: Lottie.asset('assets/lotties/searching.json'),
          ),
        ),
        Gap.h(20),
        CustomText(
          alignment: TextAlign.center,
          title: 'Search for a user to add to your team',
          color: AppColor.black,
          size: 15,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off_outlined,
            size: 60,
            color: AppColor.black,
          ),
          const SizedBox(height: 16),
          CustomText(
              title: 'No Players Found',
              color: AppColor.black,
              size: 15,
              fontWeight: FontWeight.w500),
          const SizedBox(height: 8),
          CustomText(
              softWrap: true,
              alignment: TextAlign.center,
              title:
                  'It looks like there are no available players to add to the team at the moment.',
              color: AppColor.black,
              size: 11,
              fontWeight: FontWeight.w400),
        ],
      ),
    );
  }

  Widget _buildUserList(TeamCreateViewModel teamVm) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: teamVm.users.length,
      itemBuilder: (context, index) {
        final user = teamVm.users[index];
        final isSelected = teamVm.selectedUserId == user.id.toString();

        return GestureDetector(
          onTap: () => teamVm.selectUser(user.id.toString()),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.screenBG,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    isSelected ? AppColor.primaryColor : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: cacheImageView(
                      image: user.profileImage ?? '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    title: user.username ?? '',
                    color: AppColor.black,
                    size: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: LocaleKeys.invitePlayer.tr()),
      backgroundColor: AppColor.screenBG,
      body: Consumer<TeamCreateViewModel>(
        builder: (context, teamVm, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Gap.h(20),
                    // Search Field
                    PrimaryTextField(
                      isPass: false,
                      readOnly: false,
                      controller: teamVm.searchController,
                      onChange: (text) {
                        if (text.isEmpty) {
                          teamVm.users.clear();
                          teamVm.selectedUserId = '';
                          setState(() {});
                        } else {
                          teamVm.searchWithDebounce(context, text);
                        }
                      },
                      onSubmitted: (text) {
                        if (text.length > 3) {
                          teamVm.setSearchQuery(text);
                          teamVm.searchAPI(context);
                        }
                      },
                      hintText: LocaleKeys.searchUser.tr(),
                      textStyle:
                          const TextStyle(fontSize: 12, color: AppColor.grey),
                      errorText: '',
                      prefixIcon: 'assets/images/Search.png',
                      width: AppConfig(context).width,
                      headingText: '',
                    ),
                    Gap.h(20),

                    // Content based on search state
                    Expanded(
                      child: teamVm.searchController.text.isEmpty
                          ? _buildInitialState(context)
                          : teamVm.users.isEmpty
                              ? _buildEmptySearchResult()
                              : _buildUserList(teamVm),
                    ),
                  ],
                ),
              ),
              if (teamVm.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<TeamCreateViewModel>(
        builder: (context, teamVm, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: teamVm.selectedUserId != ''
                ? PrimaryBTN(
                    callback: () =>
                        teamVm.addPlayerInTeam(context, widget.teamId),
                    color: AppColor.primaryColor,
                    title: LocaleKeys.addPlayer.tr(),
                    width: AppConfig(context).width,
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
