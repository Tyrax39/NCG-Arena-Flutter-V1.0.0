// ignore_for_file: use_build_context_synchronously

import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_chat/view_model/tournament_chat_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TournamentChat extends StatefulWidget {
  const TournamentChat({
    super.key,
    required this.userId,
    required this.tournamentId,
    required this.matchId,
    required this.tournamentName,
    required this.tournamentAdmin,
  });

  final String userId;
  final String tournamentId;
  final String matchId;
  final String tournamentName;
  final String tournamentAdmin;

  @override
  TournamentChatState createState() => TournamentChatState();
}

class TournamentChatState extends State<TournamentChat> {
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  final channelMessageController = TextEditingController();

  String orderNumbers(String num1Str, String num2Str) {
    int num1 = int.parse(num1Str);
    int num2 = int.parse(num2Str);
    if (num1 < num2) {
      return '$num1$num2';
    } else {
      return '$num2$num1';
    }
  }

  void _sendChannelMessage(tournamentId) async {
    String text = channelMessageController.text;
    try {
      context.read<TournamentChatViewModel>().sendMessage(
          id: tournamentId.toString(),
          context: context,
          message: text,
          matchid: widget.matchId.toString());
      channelMessageController.clear();
    } catch (errorCode) {
      debugPrint('Send channel message error: $errorCode');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TournamentChatViewModel>();
      provider.startPolling(widget.matchId, widget.tournamentId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.95) {
        final provider = context.read<TournamentChatViewModel>();
        if (!provider.isLoadingMore && provider.hasMoreMessages) {
          provider.getAllMessages(
            widget.matchId,
            widget.tournamentId,
            provider.postsOffset,
            isLoadMore: true,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    final provider = context.read<TournamentChatViewModel>();
    provider.stopPolling();
    _scrollController.dispose();
    channelMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TournamentChatViewModel>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(title: widget.tournamentName),
          body: Consumer<TournamentChatViewModel>(
              builder: (context, chatVm, child) {
            if (chatVm.isInitialLoading) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.primaryColor,
                ),
              );
            }
            final chatData = chatVm.chatData;
            if (chatData.isEmpty) {
              return _buildEmptyState();
            }
            return _buildChatView(chatData, bloc);
          })),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.chat_bubble_2,
                size: 90,
                color: AppColor.primaryColor,
              ),
              const SizedBox(height: 20),
              CustomText(
                title: 'No messages yet!',
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
                size: 16,
              ),
              const SizedBox(height: 10),
              CustomText(
                title: 'Start the conversation by sending a message.',
                color: AppColor.black.withOpacity(0.6),
                size: 14,
              ),
            ],
          )),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatView(
      List<ChatMessage> chatData, TournamentChatViewModel chatVm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  reverse: true,
                  itemCount: chatData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: chatData[index].myMessage == "1"
                              ? SenderRowView(
                                  admin: chatData[index].user!.id.toString() ==
                                      widget.tournamentAdmin.toString(),
                                  name: chatData[index].user!.username!,
                                  time: chatData[index].createdAt!,
                                  senderMessage: chatData[index].message ?? "",
                                  media: chatData[index].media ?? "")
                              : ReceiverRowView(
                                  admin: chatData[index].user!.id.toString() ==
                                      widget.tournamentAdmin.toString(),
                                  name: chatData[index].user!.username!,
                                  time: chatData[index].createdAt!,
                                  receiverMessage:
                                      chatData[index].message ?? "",
                                  media: chatData[index].media ?? ""),
                        ),
                        if (chatVm.isLoadingMore && chatVm.hasMoreMessages)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    );
                    // : const SizedBox();
                  }),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.screenBG,
            AppColor.screenBG,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(0)),
      ),
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            _buildImagePickerButton(),
            Expanded(
              child: PrimaryTextField(
                controller: channelMessageController,
                isPass: false,
                onChange: (String value) {},
                hintText: 'Write something here',
                textStyle: const TextStyle(),
                errorText: '',
                width: AppConfig(context).width,
                headingText: '',
              ),
            ),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          final image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image == null) return;
          context.read<TournamentChatViewModel>().handleImageSelection(
              image, context, widget.tournamentId, widget.matchId);
        },
        child: Container(
            height: 40,
            width: 42,
            decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(40)),
            child: const Center(
                child: Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 22,
            ))),
      ),
    );
  }

  Widget _buildSendButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          if (channelMessageController.text.isNotEmpty) {
            _sendChannelMessage(widget.tournamentId);
          }
        },
        child: Container(
            height: 40,
            width: 42,
            decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(40)),
            child: const Center(
                child: Icon(
              Icons.send,
              color: Colors.white,
              size: 22,
            ))),
      ),
    );
  }

  static TextStyle textStyle =
      const TextStyle(fontSize: 18, color: Colors.blue);
}

class SenderRowView extends StatelessWidget {
  const SenderRowView({
    Key? key,
    required this.senderMessage,
    required this.name,
    required this.media,
    required this.time,
    required this.admin,
  }) : super(key: key);

  final String senderMessage;
  final String name;
  final String media;
  final bool admin;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Flexible(
        flex: 15,
        fit: FlexFit.tight,
        child: Container(
          width: 50.0,
        ),
      ),
      Flexible(
        flex: 72,
        fit: FlexFit.tight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 5.0, top: 8.0, bottom: 2.0),
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 9.0, bottom: 9.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppColor.lightgrey,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          admin == true
                              ? Image.asset(
                                  'assets/images/admin.png',
                                  width: 12,
                                  height: 12,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            title: name,
                            color: admin == true
                                ? const Color(0xffFFD100)
                                : AppColor.primaryColor,
                            size: 11,
                            alignment: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      senderMessage.isNotEmpty && senderMessage != "null"
                          ? CustomText(
                              title: senderMessage,
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              size: 14,
                              alignment: TextAlign.left,
                            )
                          : const SizedBox(),
                      media.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: media.toString(),
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(
                                color: AppColor.primaryColor,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 10.0, bottom: 8.0),
              child: CustomText(
                title: DateFormat('h:mm a, EEEE').format(time),
                color: AppColor.black,
                size: 11.0,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class ReceiverRowView extends StatelessWidget {
  const ReceiverRowView({
    super.key,
    required this.receiverMessage,
    required this.name,
    required this.media,
    required this.time,
    required this.admin,
  });

  final String receiverMessage;
  final String name;
  final DateTime time;
  final String media;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 8.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 9.0, bottom: 9.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: AppColor.lightgrey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            admin == true
                                ? Image.asset(
                                    'assets/images/admin.png',
                                    width: 12,
                                    height: 12,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              title: name,
                              color: admin == true
                                  ? const Color(0xffFFD100)
                                  : AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              size: 11,
                              alignment: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        receiverMessage.isNotEmpty && receiverMessage != "null"
                            ? CustomText(
                                title: receiverMessage,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold,
                                size: 14,
                                alignment: TextAlign.left,
                              )
                            : const SizedBox(),
                        media.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: media.toString(),
                                placeholder: (context, url) =>
                                    CupertinoActivityIndicator(
                                  color: AppColor.primaryColor,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                child: CustomText(
                  title: DateFormat('h:mm a, EEEE').format(time),
                  color: AppColor.black,
                  size: 11.0,
                ),
              ),
            ],
          ),
          //
        ),
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
      ],
    );
  }
}
