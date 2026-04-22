import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class MoneyTransfer extends StatefulWidget {
  const MoneyTransfer({super.key});

  @override
  State<MoneyTransfer> createState() => _MoneyTransferState();
}

class _MoneyTransferState extends State<MoneyTransfer> {
  @override
  void initState() {
    context.read<WalletViewModel>().getDepositHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.transactions.tr()),
      body: SafeArea(
        child: Consumer<WalletViewModel>(builder: (context, walletVm, child) {
          if (walletVm.transactionData.isEmpty && !walletVm.isLoading) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 60,
                      color: AppColor.black,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      softWrap: true,
                      title: LocaleKeys.noTransactionsFound.tr(),
                      size: 15,
                      color: AppColor.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "inter",
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      softWrap: true,
                      alignment: TextAlign.center,
                      title: LocaleKeys.stayTuned.tr(),
                      size: 11,
                      color: AppColor.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "inter",
                    ),
                  ],
                ),
              ),
            );
          } else if (walletVm.isLoading) {
            // Show loader while data is being fetched
            return Center(
                child: CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ));
          } else {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: walletVm.transactionData.length,
                 itemBuilder: (context, index) {
                    var transaction = walletVm.transactionData[index];
                    bool isWithdraw = transaction.description == 'Withdraw';
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isWithdraw
                              ? const Color(0xfff26558).withOpacity(0.1)
                              : const Color(0xff3fc884).withOpacity(0.1),
                        ),
                        child: Center(
                          child: Image.asset(
                            isWithdraw
                                ? CustomAssets.receive
                                : CustomAssets.send,
                            height: 24,
                            color: isWithdraw
                                ? const Color(0xfff26558)
                                : const Color(0xff3fc884),
                          ),
                        ),
                      ),
                      title: CustomText(
                        alignment: TextAlign.start,
                        title: isWithdraw
                            ? "Withdrawn from wallet"
                            : transaction.description == "Deposit"
                                ? "Added to wallet"
                                : transaction.description == "Transfer"
                                    ? "Transferred funds"
                                    : transaction.description!,
                        size: 14,
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: transaction.createdAt != null
                          ? CustomText(
                              title: DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(transaction.createdAt!),
                              size: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                              alignment: TextAlign.start,
                            )
                          : null,
                      trailing: CustomText(
                        title: "\$${transaction.amount}",
                        size: 16,
                        color: isWithdraw
                            ? const Color(0xfff26558)
                            : const Color(0xff3fc884),
                        fontWeight: FontWeight.w700,
                        alignment: TextAlign.start,
                      ),
                    );
                  },
            
            
                ));
          }
        }),
      ),
    );
  }
}
