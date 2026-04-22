import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class TransferMoneyView extends StatefulWidget {
  const TransferMoneyView({super.key});

  @override
  State<TransferMoneyView> createState() => _TransferMoneyViewState();
}

class _TransferMoneyViewState extends State<TransferMoneyView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _searchController = TextEditingController();

  DialogHelper get _dialogueHelper => DialogHelper.instance();
  SnackbarHelper get _snackBarHelper => SnackbarHelper.instance();

  @override
  void dispose() {
    _amountController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<WalletViewModel>().updateSelectedUser(null);
    context.read<WalletViewModel>().clearSearchUsers();
    _amountController.clear();
    _passwordController.clear();
    _searchController.clear();
  }

  Future<void> _transferMoney(WalletViewModel walletVm) async {
    if (_formKey.currentState!.validate() && walletVm.selectedUser != null) {
      final amount = _amountController.text;
      final password = _passwordController.text;
      final userId = walletVm.selectedUser!.id;

      setState(() {
        walletVm.isLoading = true;
      });

      _dialogueHelper
        ..injectContext(context)
        ..showProgressDialog(LocaleKeys.loading.tr());

      try {
        // Call the API to transfer money
        final response = await context.read<WalletViewModel>().transferCoins(
              amount: amount,
              userId: userId.toString(),
              password: password,
            );

        _dialogueHelper.dismissProgress();

        if (response.status == 200) {
          _showSuccessDialog(walletVm);
          context.read<WalletViewModel>().getbalance();
          context.read<WalletViewModel>().getTransactions();
        } else {
          _snackBarHelper
            ..injectContext(context)
            ..showSnackbar(
              snackbarMessage: SnackbarMessage.smallMessageError(
                content: response.message,
              ),
            );
        }
      } catch (e) {
        _dialogueHelper.dismissProgress();
      } finally {}
    }
  }

  void _showSuccessDialog(WalletViewModel walletVm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            const SizedBox(height: 16.0),
            CustomText(
              title: LocaleKeys.transferSuccessful.tr(),
              size: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
            const SizedBox(height: 8.0),
            CustomText(
              title:
                  "\$${_amountController.text} ${LocaleKeys.transferTo.tr()} ${walletVm.selectedUser!.firstName} ${walletVm.selectedUser!.lastName}",
              size: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              alignment: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _amountController.clear();
                _passwordController.clear();
                walletVm.updateSelectedUser(null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: CustomText(
                title: LocaleKeys.done.tr(),
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletViewModel>(
      builder: (context, walletVm, child) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(title: LocaleKeys.transferMoney.tr()),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.primaryColor,
                            AppColor.secondaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: LocaleKeys.availableBalance.tr(),
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                title: '\$',
                                size: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(width: 2),
                              CustomText(
                                title: '${walletVm.userBalance}',
                                size: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomText(
                      title: LocaleKeys.searchUser.tr(),
                      size: 16,
                      color: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10),
                    if (walletVm.selectedUser == null)
                      Column(
                        children: [
                          PrimaryTextField(
                            keyBoardType: TextInputType.text,
                            isPass: false,
                            onChange: (value) {
                              if (value.length > 2) {
                                context
                                    .read<WalletViewModel>()
                                    .searchAPI(context, value);
                              } else if (value.isEmpty) {
                                walletVm.clearSearchUsers();
                              }
                            },
                            hintText: LocaleKeys.enterUsername.tr(),
                            textStyle: const TextStyle(
                                color: AppColor.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: "inter"),
                            errorText: "",
                            width: 0,
                            prefixIcon: 'assets/images/Search.png',
                            controller: _searchController,
                            headingText: "",
                          ),
                          const SizedBox(height: 10),
                          if (walletVm.isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (walletVm.searchUsers.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: walletVm.searchUsers.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (context, index) {
                                  // Mock user data
                                  final mockUsers = walletVm.searchUsers;

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          mockUsers[index].profileImage ?? ''),
                                    ),
                                    title: CustomText(
                                      title:
                                          '${mockUsers[index].firstName} ${mockUsers[index].lastName}',
                                      size: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    subtitle: CustomText(
                                      title: '@${mockUsers[index].username}',
                                      size: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    onTap: () {
                                      walletVm
                                          .updateSelectedUser(mockUsers[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      )
                    else
                      // Selected user card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                  walletVm.selectedUser!.profileImage ?? ''),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title:
                                        '${walletVm.selectedUser!.firstName} ${walletVm.selectedUser!.lastName}',
                                    size: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    title:
                                        '@${walletVm.selectedUser!.username}',
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                walletVm.updateSelectedUser(null);
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    CustomText(
                      title: LocaleKeys.amount.tr(),
                      size: 16,
                      color: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      keyBoardType: TextInputType.number,
                      isPass: false,
                      onChange: (onChange) {},
                      hintText: "0.00",
                      textStyle: const TextStyle(
                          color: AppColor.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: "inter"),
                      errorText: LocaleKeys.passwordIsRequired.tr(),
                      width: 0,
                      prefixIcon: 'assets/images/dollor_transfer.png',
                      controller: _amountController,
                      headingText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter amount";
                        }
                        try {
                          final amount = double.parse(value);
                          if (amount <= 0) {
                            return "Amount must be greater than zero";
                          }
                          if (amount > walletVm.userBalance) {
                            return "Insufficient balance";
                          }
                        } catch (e) {
                          return "Invalid amount";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomText(
                      title: "Password",
                      size: 16,
                      color: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      keyBoardType: TextInputType.visiblePassword,
                      isPass: true,
                      onChange: (value) {},
                      hintText: LocaleKeys.enterPassword.tr(),
                      textStyle: const TextStyle(
                          color: AppColor.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: "inter"),
                      errorText: LocaleKeys.passwordIsRequired.tr(),
                      width: 0,
                      prefixIcon: 'assets/images/padlock.png',
                      controller: _passwordController,
                      headingText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.enterPassword.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PrimaryBTN(
                        color: AppColor.primaryColor,
                        callback: () {
                          if (_formKey.currentState!.validate()) {
                            _transferMoney(walletVm);
                          }
                        },
                        title: LocaleKeys.transfer.tr(),
                        width: AppConfig(context).width - 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
