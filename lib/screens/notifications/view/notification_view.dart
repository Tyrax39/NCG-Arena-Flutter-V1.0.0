import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/notifications/view_model/notification_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationVm =
          Provider.of<NotificationViewModel>(context, listen: false);
      notificationVm.getNotifications(context);
      notificationVm.getUserFromSharedPref();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(
        title: LocaleKeys.notifications.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Consumer<NotificationViewModel>(
          builder: (context, notificationVm, child) {
            if (notificationVm.isLoading) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.primaryColor,
                  radius: 20,
                ),
              );
            } else if (notificationVm.notificationsData.isEmpty) {
              return _buildEmptyNotifications();
            } else {
              return ListView.builder(
                itemCount: notificationVm.notificationsData.length,
                itemBuilder: (context, index) {
                  return EnhancedNotificationItem(
                    notification: notificationVm.notificationsData[index],
                    notificationVm: notificationVm,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.screenBG,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primaryColor, width: 1.5),
            ),
            child: Icon(
              Icons.notifications_off,
              size: 50,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.noNotificationsYet.tr(),
            style: TextStyle(
              color: AppColor.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: "inter",
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              LocaleKeys.stayTuned.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: "inter",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedNotificationItem extends StatelessWidget {
  final NotificationModel? notification;
  final NotificationViewModel? notificationVm;
  EnhancedNotificationItem(
      {required this.notification, required this.notificationVm});
  IconData _getNotificationIcon() {
    switch (notification!.notificationType) {
      case "follow_organization":
        return Icons.group;
      case "join_tournament":
        return Icons.emoji_events;
      case "follow_user":
        return Icons.person_add;
      case "invitation":
        return Icons.mail;
      case "Withdrawal Approved":
      case "Withdrawal Rejected":
        return Icons.account_balance_wallet;
      case "checkin_match":
        return Icons.sports_esports;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: AppColor.offwhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.primaryColor.withOpacity(0.3),
            width: 0.5,
          )),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: notification!.notificationType == "follow_organization"
            ? () {
                // Navigator.pushNamed(context, OrganizationDetails.route, arguments: notification!.organizationId!);
              }
            : notification!.notificationType == "join_tournament"
                ? () {
                    // Navigator.pushNamed(context, TournamentDetails.route, arguments: notification!.tournamentId);
                  }
                : notification!.notificationType == "follow_user"
                    ? () {
                        // Navigator.pushNamed(context, UserProfile.route, arguments: notification!.fromUserId);
                      }
                    : notification!.notificationType == "Withdrawal Approved" ||
                            notification!.notificationType ==
                                "Withdrawal Rejected"
                        ? () {
                            // Navigator.pushNamed(context, WithdrawRequests.route);
                          }
                        : notification!.text!.contains("deposite request ")
                            ? () {
                                // Navigator.pushNamed(context, DepositRequests.route);
                              }
                            : notification!.notificationType == "checkin_match"
                                ? () {
                                    // Navigator.pushNamed(context, MatchDetailScreen.route,
                                    //     arguments: {
                                    //       'matchId': int.parse(notification!.matchId!.toString()),
                                    //       'userId': notification!.toUserId!,
                                    //     });
                                  }
                                : () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon on the left
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primaryColor,
                    width: 1,
                  ),
                ),
                child: notification!.notifier == null
                    ? CircleAvatar(
                        radius: 26,
                        backgroundImage: CachedNetworkImageProvider(
                            notificationVm!.userData!.profileImage!.toString()),
                      )
                    : CircleAvatar(
                        radius: 26,
                        backgroundImage: CachedNetworkImageProvider(
                          notification!.notifier!.profileImage!.toString(),
                        ),
                      ),
              ),
              SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification type icon and text
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getNotificationIcon(),
                                size: 12,
                                color: AppColor.primaryColor,
                              ),
                              SizedBox(width: 3),
                              Text(
                                notification!.notificationType ??
                                    'Notification',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // Notification content
                    notification!.notifier == null
                        ? Text(
                            notification!.text ?? '',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 14,
                              fontFamily: "inter",
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: notification!.notifier!.username ?? '',
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "inter",
                                  ),
                                ),
                                TextSpan(
                                  text: '  ${notification!.text ?? ''}',
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 14,
                                    fontFamily: "inter",
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 10),
                    // Invitation actions and timestamp
                    Consumer<NotificationViewModel>(
                      builder: (context, notificationVm, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Invitation actions
                            notification!.notificationType == "invitation"
                                ? Container(
                                    margin: EdgeInsets.only(top: 4, bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: PrimaryBTN(
                                            borderRadius: 6,
                                            color: AppColor.primaryColor,
                                            callback: () {
                                              notificationVm.acceptReject(
                                                  notification!.teamId,
                                                  "1",
                                                  context);
                                            },
                                            title: LocaleKeys.accept.tr(),
                                            width: AppConfig(context).width,
                                            height: 32,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: PrimaryBTN(
                                            borderRadius: 6,
                                            title: LocaleKeys.reject.tr(),
                                            color: AppColor.black,
                                            width: AppConfig(context).width,
                                            height: 32,
                                            callback: () {
                                              notificationVm.acceptReject(
                                                  notification!.teamId,
                                                  "2",
                                                  context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            // Timestamp
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  DateFormat('hh:mm a').format(
                                      DateTime.parse(notification!.createdAt!)),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                    fontFamily: "inter",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
