import 'dart:convert';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/wallet/view/component/withdraw_bottomsheet.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  DialogHelper get _dialogueHelper => DialogHelper.instance();
  SnackbarHelper get _snackBarHelper => SnackbarHelper.instance();

  @override
  void initState() {
    context.read<WalletViewModel>().getUserFromSharedPref();
    context.read<WalletViewModel>().getbalance();
    context.read<WalletViewModel>().getTransactions();
    context.read<WalletViewModel>().siteSettingData();
    super.initState();
  }

  bool _isStripeAvailable(WalletViewModel walletVm) {
    return walletVm.settingData != null &&
           Stripe.publishableKey.isNotEmpty &&
           walletVm.settingData!.stripePrivateKey != null &&
           walletVm.settingData!.stripePrivateKey!.isNotEmpty;
  }

  void _showStripeNotConfiguredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.payment,
                color: Colors.orange.shade600,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Unavailable',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment system is not configured yet.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The admin needs to set up Stripe payment configuration in the admin panel before you can add money to your wallet.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Please contact support or try again later.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addBalance(WalletViewModel provider, BuildContext context,
      DialogHelper dialogHelper, transactionId, methodId) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await provider.addBalance(transactionId, methodId);
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        _snackBarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
        return;
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100.0,
                    ),
                    SizedBox(height: 10.0),
                    Text("Payment Successful!"),
                  ],
                ),
              ));
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => _addBalance(
              provider, context, dialogHelper, transactionId, methodId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.wallet.tr()),
      body: Consumer<WalletViewModel>(
        builder: (context, walletVm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                walletVm.getbalance(),
                walletVm.getTransactions(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card with glass effect
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.primaryColor,
                            AppColor.secondaryColor,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Decorative elements
                          Positioned(
                            right: -30,
                            top: -30,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            bottom: -20,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title: LocaleKeys.availableBalance.tr(),
                                      size: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      child: const Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      title: '\$',
                                      size: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(width: 2),
                                    CustomText(
                                      title: '${walletVm.userBalance}',
                                      size: 36,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (walletVm.userData != null)
                                  Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      CustomText(
                                        title:
                                            '${walletVm.userData!.firstName} ${walletVm.userData!.lastName}',
                                        size: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColor.offwhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            icon: CustomAssets.topUp,
                            title: LocaleKeys.topUp.tr(),
                            color: _isStripeAvailable(walletVm) 
                                ? const Color(0xff2c81ff) 
                                : Colors.grey.shade400,
                            onTap: _isStripeAvailable(walletVm) ? () {
                              _dialogueHelper
                                ..injectContext(context)
                                ..showAddAmountDialog((amount) {
                                  makePayment(
                                      context,
                                      amount,
                                      walletVm,
                                      _dialogueHelper,
                                      _snackBarHelper,
                                      walletVm.settingData!.stripePrivateKey);
                                });
                            } : () {
                              _showStripeNotConfiguredDialog(context);
                            },
                          ),
                          _buildActionButton(
                            icon: CustomAssets.transfer,
                            title: LocaleKeys.transfer.tr(),
                            color: const Color(0xff3fc884),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.transferMoney);
                            },
                          ),
                          _buildActionButton(
                            icon: CustomAssets.request,
                            title: LocaleKeys.request.tr(),
                            color: const Color(0xffffca4e),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.withdrawHistoryView);
                            },
                          ),
                          _buildActionButton(
                            icon: CustomAssets.withdraw,
                            title: LocaleKeys.withdraw.tr(),
                            color: const Color(0xfff26558),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return const WithdrawRequestBottomSheet();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Transactions header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: LocaleKeys.transactions.tr(),
                          size: 18,
                          color: AppColor.black,
                          fontWeight: FontWeight.w700,
                        ),
                        if (walletVm.transactionData.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              // Navigate to all transactions
                              Navigator.pushNamed(
                                  context, MyRoutes.moneyTransfer);
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Transactions list
                    _buildTransactionsList(walletVm),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color.withOpacity(0.1),
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 24,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomText(
            title: title,
            size: 12,
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(WalletViewModel walletVm) {
    if (walletVm.isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (walletVm.transactionData.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.offwhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            CustomText(
              title: LocaleKeys.noTransactionsYet.tr(),
              size: 16,
              color: AppColor.black,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomText(
                softWrap: true,
                alignment: TextAlign.center,
                title: LocaleKeys.stayTuned.tr(),
                size: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.offwhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: walletVm.transactionData.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade200,
          height: 1,
        ),
        itemBuilder: (context, index) {
          var transaction = walletVm.transactionData[index];
          bool isWithdraw = transaction.description == 'Withdraw';

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  isWithdraw ? CustomAssets.receive : CustomAssets.send,
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
      ),
    );
  }

  ////////// STRIPE PAYMENT //////////
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(
    context,
    amount,
    provider,
    dialogHelper,
    snackBarHelper,
    String? stripePrivateKey,
  ) async {
    try {
      // Check if Stripe is properly initialized
      if (Stripe.publishableKey.isEmpty) {
        _showStripeNotConfiguredDialog(context);
        return;
      }

      if (amount <= 0) {
        _snackBarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: const SnackbarMessage.smallMessageError(
                  content: 'Invalid amount'));
        return;
      }

      if (stripePrivateKey == null || stripePrivateKey.isEmpty) {
        _showStripeNotConfiguredDialog(context);
        return;
      }

      print('Creating payment intent for amount: $amount');
      paymentIntent =
          await createPaymentIntent('$amount', 'USD', stripePrivateKey);
      
      if (paymentIntent == null) {
        _snackBarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: const SnackbarMessage.smallMessageError(
                  content: 'Unable to create payment. Please try again.'));
        return;
      }

      print('Payment intent created: ${paymentIntent!['id']}');
      
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
              merchantDisplayName: 'Neoncave Arena'))
          .then((value) {
        print('Payment sheet initialized successfully');
        displayPaymentSheet(
          context: context,
          transactionId: paymentIntent!['id'],
          amount: amount,
          provider: provider,
          dialogHelper: dialogHelper,
          snackBarHelper: snackBarHelper,
        );
      }).catchError((error) {
        print('Error initializing payment sheet: $error');
        _snackBarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage.smallMessageError(
                  content: 'Payment initialization failed: ${error.toString()}'));
      });
    } catch (err) {
      print('Error in makePayment: $err');
      _snackBarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessageError(
                content: 'Payment failed: ${err.toString()}'));
    }
  }

  displayPaymentSheet(
      {context,
      required String transactionId,
      amount,
      provider,
      dialogHelper,
      snackBarHelper}) async {
    try {
      print('Presenting payment sheet for transaction: $transactionId');
      await Stripe.instance
          .presentPaymentSheet(options: const PaymentSheetPresentOptions())
          .then((value) {
        print('Payment completed successfully');
        _addBalance(provider, context, dialogHelper, transactionId, '2');
        paymentIntent = null;
      }).catchError((error) {
        print('Payment sheet error: $error');
        _snackBarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage.smallMessageError(
                  content: 'Payment failed: ${error.toString()}'));
      });
    } on StripeException catch (e) {
      print('Stripe exception: $e');
      _snackBarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessageError(
                content: 'Payment failed: ${e.toString()}'));
    } catch (e) {
      print('Error during present payment sheet: $e');
      _snackBarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: const SnackbarMessage.smallMessageError(
                content: 'An unexpected error occurred'));
    }
  }

  createPaymentIntent(
      String amount, String currency, String? stripePrivateKey) async {
    try {
      final calculatedAmount = calculateAmount(amount);
      print('Creating payment intent with amount: $calculatedAmount cents');
      
      Map<String, dynamic> body = {
        'amount': calculatedAmount,
        'currency': currency,
      };
      
      print('Request body: $body');
      print('Using Stripe private key: ${stripePrivateKey?.substring(0, 10)}...');
      
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripePrivateKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      
      print('Stripe API response status: ${response.statusCode}');
      print('Stripe API response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Stripe API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (err) {
      print('Error creating payment intent: $err');
      return null;
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).toInt();
    return calculatedAmount.toString();
  }
}
