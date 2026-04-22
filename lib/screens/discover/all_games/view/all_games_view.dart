import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/discover/all_games/view_model/all_games_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:neoncave_arena/routes/app_routes.dart';

class AllGames extends StatefulWidget {
  const AllGames({super.key});

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AllGamesViewModel>(context, listen: false);
      viewModel.getGames(isLoadMore: true, viewModel.postsOffset);
    });
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final viewModel = Provider.of<AllGamesViewModel>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!viewModel.isLoadingMore) {
        viewModel.getGames(isLoadMore: true, viewModel.postsOffset);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllGamesViewModel>(
      builder: (context, gameVm, child) {
        if (gameVm.gameData.isEmpty && !gameVm.isInitialLoading) {
          return Scaffold(
            backgroundColor: AppColor.screenBG,
            appBar: CommonAppBar(title: LocaleKeys.liveChannelsYouMayLike.tr()),
            body: Center(
              child: Text(
                LocaleKeys.noChannelsAvailable.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.black,
                ),
              ),
            ),
          );
        } else if (gameVm.isInitialLoading) {
          return Scaffold(
            backgroundColor: AppColor.screenBG,
            body: Center(
              child: CupertinoActivityIndicator(
                color: AppColor.primaryColor,
                radius: 20,
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColor.screenBG,
            appBar: CommonAppBar(title: LocaleKeys.popularGames.tr()),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Consumer<AllGamesViewModel>(
                  builder: (context, discoverVm, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: List.generate(
                          discoverVm.gameData.length,
                          (index) {
                            final gameData = discoverVm.gameData[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.gameDetailView,
                                    arguments: gameData);
                              },
                              child: Container(
                                width: AppConfig(context).width * .45,
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
                                    SizedBox(
                                      width: double.infinity,
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: gameData.gameImage ?? "",
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            CustomAssets.placeholder,
                                          ),
                                          placeholder: (context, url) => Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColor.primaryColor,
                                              radius: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap.h(10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CustomText(
                                        title: gameData.gameName.toString(),
                                        maxLines: 2,
                                        color: AppColor.black,
                                        size: 14,
                                        fontWeight: FontWeight.w600,
                                        txtOverFlow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Gap.h(10),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
