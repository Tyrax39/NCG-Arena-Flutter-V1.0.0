import 'dart:io';
import 'package:neoncave_arena/screens/account/view/notification_prefrences.dart';
import 'package:neoncave_arena/screens/account/view_model/notification_prefrences_view_model.dart';
import 'package:neoncave_arena/screens/auth/change_password/change_password_provider.dart';
import 'package:neoncave_arena/screens/auth/change_password/change_password_screen.dart';
import 'package:neoncave_arena/screens/auth/forgot_pasword/view_model/forgot_password_view_model.dart';
import 'package:neoncave_arena/screens/auth/reset_password/view_model/reset_password_view_model.dart';
import 'package:neoncave_arena/screens/auth/verify_reset_password/view_model/verify_reset_password_view_model.dart';
import 'package:neoncave_arena/screens/channel_detail/view_model/channel_detail_view_model.dart';
import 'package:neoncave_arena/screens/create_potfolio/view/create_portfolio_view.dart';
import 'package:neoncave_arena/screens/create_potfolio/view_model/create_portfolio_view_model.dart';
import 'package:neoncave_arena/screens/discover/all_channels/view/all_channels_view.dart';
import 'package:neoncave_arena/screens/discover/all_channels/view_model/all_channels_view_model.dart';
import 'package:neoncave_arena/screens/discover/all_games/view/all_games_view.dart';
import 'package:neoncave_arena/screens/discover/all_games/view_model/all_games_view_model.dart';
import 'package:neoncave_arena/screens/discover/all_organizations/view_model/all_organization_view_model.dart';
import 'package:neoncave_arena/screens/discover/all_organizations/view/all_organizations_view.dart';
import 'package:neoncave_arena/screens/game_detail/view/game_detail_view.dart';
import 'package:neoncave_arena/screens/game_detail/view_model/game_detail_view_model.dart';
import 'package:neoncave_arena/screens/notifications/view_model/notification_view_model.dart';
import 'package:neoncave_arena/screens/subscription/view_model/subscription_view_model.dart';
import 'package:neoncave_arena/screens/all_tournaments/view/all_tournament_view.dart';
import 'package:neoncave_arena/screens/all_tournaments/view_model/all_tournament_view_model.dart';
import 'package:neoncave_arena/screens/auth/login/view/login_view.dart';
import 'package:neoncave_arena/screens/auth/login/view_model/login_view_model.dart';
import 'package:neoncave_arena/screens/auth/selection_view/view_model/selection_view_model.dart';
import 'package:neoncave_arena/screens/auth/signup/view/sign_up.dart';
import 'package:neoncave_arena/screens/auth/signup/view_model/signup_view_model.dart';
import 'package:neoncave_arena/screens/contact_us/view/contact_us_view.dart';
import 'package:neoncave_arena/screens/contact_us/view_model/contact_us_view_model.dart';
import 'package:neoncave_arena/screens/create_channel/view/create_channel_view.dart';
import 'package:neoncave_arena/screens/create_channel/view_model/create_channel_view_model.dart';
import 'package:neoncave_arena/screens/create_live_stream_form/view/create_live_stream_form_view.dart';
import 'package:neoncave_arena/screens/create_live_stream_form/view_model/create_live_stream_form_view_model.dart';
import 'package:neoncave_arena/screens/create_organization/view/add_link_detail_view.dart';
import 'package:neoncave_arena/screens/create_organization/view/create_organization_view.dart';
import 'package:neoncave_arena/screens/create_organization/view_model/create_organization_view_model.dart';
import 'package:neoncave_arena/screens/create_profile/view/create_profile_view.dart';
import 'package:neoncave_arena/screens/create_profile/view_model/create_profile_view_model.dart';
import 'package:neoncave_arena/screens/create_team/view/create_team_view.dart';
import 'package:neoncave_arena/screens/create_team/view_model/create_team_view_model.dart';
import 'package:neoncave_arena/screens/create_tournament/view/create_tournament_view.dart';
import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/screens/edit_profile/view/edit_profile_view.dart';
import 'package:neoncave_arena/screens/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:neoncave_arena/screens/live_stream/view/live_stream_view.dart';
import 'package:neoncave_arena/screens/live_stream/view_model/live_stream_view_model.dart';
import 'package:neoncave_arena/screens/my_organizations/view/my_organization_view.dart';
import 'package:neoncave_arena/screens/my_organizations/view_model/my_organization_view_model.dart';
import 'package:neoncave_arena/screens/my_tournament/view_model/my_tournament_view_model.dart';
import 'package:neoncave_arena/screens/my_tournament/view/my_tournaments_view.dart';
import 'package:neoncave_arena/screens/onboarding/view_model/onboarding_view_model.dart';
import 'package:neoncave_arena/screens/profile/view/image_detail_view.dart';
import 'package:neoncave_arena/screens/profile/view/video_detail_view.dart';
import 'package:neoncave_arena/screens/search/view_model/search_view_model.dart';
import 'package:neoncave_arena/screens/add_player_team/view/add_team_view.dart';
import 'package:neoncave_arena/screens/auth/select_channel/view_model/select_channel_view_model.dart';
import 'package:neoncave_arena/screens/auth/select_organization/view_model/select_organization_view_model.dart';
import 'package:neoncave_arena/screens/auth/select_organization/view/select_organization_view.dart';
import 'package:neoncave_arena/screens/auth/signup_verify/view/signup_verify_view.dart';
import 'package:neoncave_arena/screens/auth/signup_verify/view_model/signup_verify_view_model.dart';
import 'package:neoncave_arena/screens/channel_detail/view/channel_detail_view.dart';
import 'package:neoncave_arena/screens/followed_channels/view_model/followed_channels_view_model.dart';
import 'package:neoncave_arena/screens/followed_organizations/view_model/followed_organization_view_model.dart';
import 'package:neoncave_arena/screens/organization_detail/view/organization_detail_view.dart';
import 'package:neoncave_arena/screens/profile/view_model/profile_view_model.dart';
import 'package:neoncave_arena/screens/team/view_model/team_view_model.dart';
import 'package:neoncave_arena/screens/add_player_team/view_model/team_create_view_model.dart';
import 'package:neoncave_arena/screens/team_detail/view_model/team_detail_view_model.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/matchDetails/view/match_details_view.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/matchDetails/view_model/match_details_view_model.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_chat/view/tournament_chat_view.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_chat/view_model/tournament_chat_view_model.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_detail_view.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/updateScores/view/update_score_view.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/updateScores/view_model/update_score_view_model.dart';
import 'package:neoncave_arena/screens/tournament_history/view_model/tournament_history_view_model.dart';
import 'package:neoncave_arena/screens/tournament_history/view/tournament_history_view.dart';
import 'package:neoncave_arena/screens/wallet/view/bank_withdraw_view.dart';
import 'package:neoncave_arena/screens/wallet/view/withdraw_history_view.dart';
import 'package:neoncave_arena/screens/search/view/search_view.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/screens/team_detail/view/team_detail_view.dart';
import 'package:neoncave_arena/screens/team/view/team_view.dart';
import 'package:neoncave_arena/common/custom_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/account/view/aboutUs.dart';
import 'package:neoncave_arena/screens/language/view/language_view.dart';
import 'package:neoncave_arena/screens/account/view/preferences.dart';
import 'package:neoncave_arena/screens/profile/view/profile_view.dart';
import 'package:neoncave_arena/screens/auth/forgot_pasword/view/forgot_password_view.dart';
import 'package:neoncave_arena/screens/auth/reset_password/view/reset_password_view.dart';
import 'package:neoncave_arena/screens/auth/verify_reset_password/view/verify_reset_pasword_view.dart';
import 'package:neoncave_arena/screens/auth/select_channel/view/select_channel_view.dart';
import 'package:neoncave_arena/screens/auth/selection_view/view/selection_view.dart';
import 'package:neoncave_arena/screens/main/view/main_screen_view.dart';
import 'package:neoncave_arena/screens/followed_channels/view/followed_channels_view.dart';
import 'package:neoncave_arena/screens/followed_organizations/view/followed_organization_view.dart';
import 'package:neoncave_arena/screens/notifications/view/notification_view.dart';
import 'package:neoncave_arena/screens/onboarding/view/onbaording.dart';
import 'package:neoncave_arena/screens/subscription/view/subscription_view.dart';
import 'package:neoncave_arena/screens/wallet/view/deposit_history_view.dart';
import 'package:neoncave_arena/screens/wallet/view/wallet_view.dart';
import 'package:neoncave_arena/screens/wallet/view/paypal_withdraw_view.dart';
import 'package:neoncave_arena/screens/splash/splash_view.dart';
import 'package:provider/provider.dart';
import 'package:neoncave_arena/screens/wallet/view/component/transfer_money_view.dart';

class AppRoutes {
  PageRoute _getPageRoute(Widget widget) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => widget)
      : MaterialPageRoute(builder: (_) => widget);

  Route? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case MyRoutes.splashView:
        return MaterialPageRoute(builder: ((context) {
          return const SplashView();
        }));

      case MyRoutes.loginView:
        {
          return _getPageRoute(ChangeNotifierProvider<LoginViewModel>(
              create: (context) => LoginViewModel(), child: const LoginView()));
        }

      case MyRoutes.selectionView:
        {
          return _getPageRoute(ChangeNotifierProvider<SelectionViewModel>(
              create: (context) => SelectionViewModel(),
              child: const SelectionView()));
        }

      case MyRoutes.onBoardingPage:
        {
          return _getPageRoute(
            ChangeNotifierProvider<OnBoardingViewModel>(
              create: (context) => OnBoardingViewModel(),
              child: OnBoardingPage(),
            ),
          );
        }
      case MyRoutes.subscription:
        {
          return _getPageRoute(
            ChangeNotifierProvider<SubscriptionViewModel>(
              create: (context) => SubscriptionViewModel(),
              child: const Subscription(),
            ),
          );
        }
      case MyRoutes.selectOrganization:
        {
          return _getPageRoute(
            ChangeNotifierProvider<SelectOrganizationViewModel>(
              create: (context) => SelectOrganizationViewModel(),
              child: const SelectOrganization(),
            ),
          );
        }
      case MyRoutes.signUpView:
        return _getPageRoute(
          ChangeNotifierProvider<SignupViewModel>(
            create: (context) => SignupViewModel(),
            child: const SignUpView(),
          ),
        );
      case MyRoutes.otpView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<SignupVerifyViewModel>(
              create: (context) => SignupVerifyViewModel(),
              child: SignupVerify(
                userEmail: (settings.arguments as List)[0] as String,
              ),
            ),
          );
        }
      case MyRoutes.forgotPassword:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ForgotPasswordViewModel>(
              create: (context) => ForgotPasswordViewModel(),
              child: ForgotPassword(),
            ),
          );
        }

      case MyRoutes.resetPasswordVerification:
        {
          return _getPageRoute(
            ChangeNotifierProvider<VerifyResetPasswordViewModel>(
              create: (context) => VerifyResetPasswordViewModel(),
              child: ResetPasswordVerification(
                email: (settings.arguments as List)[0] as String,
              ),
            ),
          );
        }

      case MyRoutes.resetPassword:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ResetPasswordViewModel>(
              create: (context) => ResetPasswordViewModel(),
              child: ResetPassword(
                email: (settings.arguments as List)[0] as String,
              ),
            ),
          );
        }

      case MyRoutes.profileView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreateProfileViewModel>(
              create: (context) => CreateProfileViewModel(),
              child: const ProfileView(),
            ),
          );
        }
      case MyRoutes.selectChannel:
        {
          return _getPageRoute(
            ChangeNotifierProvider<SelectChannelViewModel>(
              create: (context) => SelectChannelViewModel(),
              child: const SelectChannel(),
            ),
          );
        }
      case MyRoutes.mainScreen:
        return MaterialPageRoute(
          builder: ((context) {
            return const MainScreen();
          }),
        );
      case MyRoutes.followedOrganization:
        {
          return _getPageRoute(
            ChangeNotifierProvider<FollowedOrganizationViewModel>(
              create: (context) => FollowedOrganizationViewModel(),
              child: const FollowedOrganization(),
            ),
          );
        }
      case MyRoutes.followedChannels:
        {
          return _getPageRoute(
            ChangeNotifierProvider<FollowedChannelsViewModel>(
              create: (context) => FollowedChannelsViewModel(),
              child: const FollowedChannels(),
            ),
          );
        }
      case MyRoutes.userProfileScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(),
              child: UserProfileScreen(
                userId: (settings.arguments as List)[0] as int,
              ),
            ),
          );
        }
      case MyRoutes.preferences:
        return MaterialPageRoute(
          builder: ((context) {
            return const Preferences();
          }),
        );
      case MyRoutes.language:
        return MaterialPageRoute(
          builder: ((context) {
            return const Language();
          }),
        );
      case MyRoutes.imageScreen:
        return MaterialPageRoute(
          builder: ((context) {
            return ImageScreen(
              imageUrl: (settings.arguments as List)[0] as String,
              name: (settings.arguments as List)[1] as String,
            );
          }),
        );
      case MyRoutes.videoDetail:
        return MaterialPageRoute(
          builder: ((context) {
            return VideoDetail(
              videoUrl: (settings.arguments as List)[0] as String,
              name: (settings.arguments as List)[1] as String,
            );
          }),
        );
      case MyRoutes.organizationDetail:
        return MaterialPageRoute(
          builder: ((context) {
            OrganizationsModel organizationData =
                settings.arguments as OrganizationsModel;
            return OrganizationDetail(organizationData: organizationData);
          }),
        );
      case MyRoutes.tournamentDetailScreen:
        return MaterialPageRoute(
          builder: ((context) {
            AllTournaments tournamentData =
                settings.arguments as AllTournaments;
            return TournamentDetailScreen(tournamentData: tournamentData);
          }),
        );
      case MyRoutes.teamView:
        {
          return _getPageRoute(ChangeNotifierProvider<TeamViewModel>(
              create: (context) => TeamViewModel(), child: const TeamView()));
        }

      case MyRoutes.addTeamView:
        {
          return _getPageRoute(ChangeNotifierProvider<TeamCreateViewModel>(
              create: (context) => TeamCreateViewModel(),
              child: AddTeamView(
                teamId: (settings.arguments as List)[0] as String,
              )));
        }

      case MyRoutes.createTeam:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreateTeamViewModel>(
              create: (context) => CreateTeamViewModel(),
              child: const CreateTeam(),
            ),
          );
        }
      case MyRoutes.teamDetailScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<TeamDetailViewModel>(
              create: (context) => TeamDetailViewModel(),
              child: TeamDetailScreen(
                teamData: settings.arguments as MyTeamModel,
              ),
            ),
          );
        }

      case MyRoutes.createOrganization:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreateOrganizationViewModel>(
              create: (context) => CreateOrganizationViewModel(),
              child: const CreateOrganization(),
            ),
          );
        }
      case MyRoutes.createTournament:
        {
          return _getPageRoute(
            ChangeNotifierProvider<TournamentCreateViewmodel>(
              create: (context) => TournamentCreateViewmodel(),
              child: const CreateTournament(),
            ),
          );
        }
      case MyRoutes.myOrganizationView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<MyOrganizationViewModel>(
              create: (context) => MyOrganizationViewModel(),
              child: const MyOrganizationView(),
            ),
          );
        }
      case MyRoutes.allChannels:
        {
          return _getPageRoute(
            ChangeNotifierProvider<AllChannelsViewModel>(
              create: (context) => AllChannelsViewModel(),
              child: const AllChannels(),
            ),
          );
        }
      case MyRoutes.allGames:
        {
          return _getPageRoute(ChangeNotifierProvider<AllGamesViewModel>(
            create: (context) => AllGamesViewModel(),
            child: const AllGames(),
          ));
        }
      case MyRoutes.gameDetailView:
        {
          return _getPageRoute(ChangeNotifierProvider<GameDetailViewModel>(
            create: (context) => GameDetailViewModel(),
            child: GameDetailView(
              game: settings.arguments as GameModel,
            ),
          ));
        }

      case MyRoutes.changePassword:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ChangePasswordProvider>(
              create: (context) => ChangePasswordProvider(),
              child: const ChangePasswordScreen(),
            ),
          );
        }

      case MyRoutes.allOrganizations:
        {
          return _getPageRoute(ChangeNotifierProvider<AllOrganizationViewModel>(
            create: (context) => AllOrganizationViewModel(),
            child: const AllOrganizations(),
          ));
        }
      case MyRoutes.myTournaments:
        {
          return _getPageRoute(
            ChangeNotifierProvider<MyTournamentViewModel>(
              create: (context) => MyTournamentViewModel(),
              child: const MyTournaments(),
            ),
          );
        }
      case MyRoutes.tournamentHistory:
        {
          return _getPageRoute(
            ChangeNotifierProvider<TournamentHistoryViewModel>(
              create: (context) => TournamentHistoryViewModel(),
              child: const TournamentHistoryScreen(),
            ),
          );
        }
      case MyRoutes.aboutUs:
        return MaterialPageRoute(
          builder: ((context) {
            return const AboutUsScreen();
          }),
        );
      case MyRoutes.searchScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<SearchViewModel>(
              create: (context) => SearchViewModel(),
              child: const SearchScreen(),
            ),
          );
        }
      case MyRoutes.notificationsView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<NotificationViewModel>(
              create: (context) => NotificationViewModel(),
              child: const NotificationsView(),
            ),
          );
        }
      case MyRoutes.moneyTransfer:
        return MaterialPageRoute(
          builder: ((context) {
            return const MoneyTransfer();
          }),
        );
      case MyRoutes.transferMoney:
        return MaterialPageRoute(
          builder: ((context) {
            return const TransferMoneyView();
          }),
        );
      case MyRoutes.paypalWithdraw:
        return MaterialPageRoute(
          builder: ((context) {
            return const PaypalWithdraw();
          }),
        );
      case MyRoutes.bankWithdraw:
        return MaterialPageRoute(
          builder: ((context) {
            return const BankWithdraw();
          }),
        );
      case MyRoutes.withdrawHistoryView:
        return MaterialPageRoute(
          builder: ((context) {
            return const WithdrawHistoryView();
          }),
        );
      case MyRoutes.wallet:
        return MaterialPageRoute(
          builder: ((context) {
            return const Wallet();
          }),
        );

      case MyRoutes.addSocialLinksDetail:
        return MaterialPageRoute(
          builder: ((context) {
            return const AddSocialLinksDetail();
          }),
        );
      case MyRoutes.createChannel:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreateChannelViewModel>(
              create: (context) => CreateChannelViewModel(),
              child: CreateChannel(
                orgId: (settings.arguments as List)[0] as String,
              ),
            ),
          );
        }
      case MyRoutes.createPortfolio:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreatePortfolioViewModel>(
              create: (context) => CreatePortfolioViewModel(),
              child: const CreatePortfolio(),
            ),
          );
        }
      case MyRoutes.allTournamentView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<AllTournamentViewModel>(
              create: (context) => AllTournamentViewModel(),
              child: const AllTournamentView(),
            ),
          );
        }
      case MyRoutes.channelDetailScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ChannelDetailViewModel>(
              create: (context) => ChannelDetailViewModel(),
              child: ChannelDetailScreen(
                channelData: settings.arguments as ChannelModel,
              ),
            ),
          );
        }
      case MyRoutes.contactUsScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<ContactUsViewModel>(
              create: (context) => ContactUsViewModel(),
              child: const ContactUsScreen(),
            ),
          );
        }
      case MyRoutes.updateScore:
        {
          return _getPageRoute(
            ChangeNotifierProvider<MatchUpdateScoreViewModel>(
              create: (context) => MatchUpdateScoreViewModel(),
              child: UpdateScore(
                id: (settings.arguments as List)[0] as int,
              ),
            ),
          );
        }
      case MyRoutes.matchDetailScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<MatchDetailViewModel>(
              create: (context) => MatchDetailViewModel(),
              child: MatchDetailScreen(
                matchid: (settings.arguments as List)[0] as int,
                currentUserId: (settings.arguments as List)[1] as String,
              ),
            ),
          );
        }
      case MyRoutes.editProfileView:
        {
          return _getPageRoute(
            ChangeNotifierProvider<EditProfileViewModel>(
              create: (context) => EditProfileViewModel(),
              child: const EditProfileView(),
            ),
          );
        }
      case MyRoutes.liveStreamScreen:
        {
          return _getPageRoute(
            ChangeNotifierProvider<LiveStreamViewModel>(
              create: (context) => LiveStreamViewModel(),
              child: LiveStreamScreen(
                liveStreamId: (settings.arguments as List)[0] as int,
                creatorId: (settings.arguments as List)[1] as int,
                isBroadcaster: (settings.arguments as List)[2] as bool,
                token: (settings.arguments as List)[3] as String,
                channelName: (settings.arguments as List)[4] as String,
              ),
            ),
          );
        }
      case MyRoutes.createLiveStreamForm:
        {
          return _getPageRoute(
            ChangeNotifierProvider<CreateLiveStreamFormViewModel>(
              create: (context) => CreateLiveStreamFormViewModel(),
              child: CreateLiveStreamForm(
                channelId: (settings.arguments as List)[0] as String,
                channelName: (settings.arguments as List)[1] as String,
              ),
            ),
          );
        }
      case MyRoutes.webView:
        return MaterialPageRoute(
          builder: ((context) {
            return WebView(
              url: (settings.arguments as List)[0] as String,
            );
          }),
        );
      case MyRoutes.tournamentChat:
        {
          return _getPageRoute(
            ChangeNotifierProvider<TournamentChatViewModel>(
              create: (context) => TournamentChatViewModel(),
              child: TournamentChat(
                userId: (settings.arguments as List)[0] as String, // userId
                tournamentId:
                    (settings.arguments as List)[1] as String, // tournamentId
                matchId: (settings.arguments as List)[2] as String, // matchId
                tournamentName:
                    (settings.arguments as List)[3] as String, // tournamentName
                tournamentAdmin: (settings.arguments as List)[4]
                    as String, // tournamentAdmin, // tournamentAdmin
              ),
            ),
          );
        }
      case MyRoutes.notificationsPreferences:
        {
          return _getPageRoute(
            ChangeNotifierProvider<NotificationsPreferencesViewModel>(
              create: (context) => NotificationsPreferencesViewModel(),
              child: const NotificationsPreferences(),
            ),
          );
        }

      default:
        {
          return null;
        }
    }
  }
}
