class SiteSetting {
  String? appName;
  String? appEmail;
  String? appContactNo;
  String? appLocation;
  String? appCopyright;
  String? appFrontendUrl;
  String? appDefaultCurrency;
  String? appDefaultLanguage;
  String? appLogo;
  String? pwaLogo;
  String? appFavIcon;
  String? adminMainLogoFooterLogo;
  String? watermarkImage;
  String? registerationApproval;
  String? facebookUrl;
  String? instagramUrl;
  String? linkedinUrl;
  String? twitterUrl;
  String? pinterestUrl;
  String? tiktokUrl;
  String? appUrl;
  String? storageDriver;
  String? awsAccessKeyId;
  String? awsSecretAccessKey;
  String? awsDefaultRegion;
  String? awsBucket;
  String? googleLoginStatus;
  String? googleClientId;
  String? googleClientSecret;
  String? facebookLoginStatus;
  String? facebookClientId;
  String? facebookClientSecret;
  String? appMailStatus;
  String? mailMailer;
  String? mailHost;
  String? mailPort;
  String? mailUsername;
  String? mailPassword;
  String? mailEncryption;
  String? mailFromAddress;
  String? mailFromName;
  String? coinValue;
  String? minimumWithdrawLimit;
  String? stripeCharges;
  String? stripePrivateKey;
  String? stripePublicKey;
  String? onesignalAppId;
  String? onesignalAppKey;
  String? minimumWithdrawAmount;
  String? basicUserWithdrawFee;
  String? checkTournament;
  String? isWalletEnable;
  String? isGoogleLogin;
  String? isFacebookLogin;
  String? isDiscordLogin;
  String? isAppleLogin;
  String? paypalClientId;
  String? paypalSecretId;

  SiteSetting({
    this.paypalClientId,
    this.paypalSecretId,
    this.isGoogleLogin,
    this.isAppleLogin,
    this.isFacebookLogin,
    this.appName,
    this.appEmail,
    this.appContactNo,
    this.appLocation,
    this.appCopyright,
    this.appFrontendUrl,
    this.appDefaultCurrency,
    this.appDefaultLanguage,
    this.appLogo,
    this.pwaLogo,
    this.appFavIcon,
    this.adminMainLogoFooterLogo,
    this.watermarkImage,
    this.registerationApproval,
    this.facebookUrl,
    this.instagramUrl,
    this.linkedinUrl,
    this.twitterUrl,
    this.pinterestUrl,
    this.tiktokUrl,
    this.appUrl,
    this.storageDriver,
    this.awsAccessKeyId,
    this.awsSecretAccessKey,
    this.awsDefaultRegion,
    this.awsBucket,
    this.googleLoginStatus,
    this.googleClientId,
    this.googleClientSecret,
    this.facebookLoginStatus,
    this.facebookClientId,
    this.facebookClientSecret,
    this.appMailStatus,
    this.mailMailer,
    this.mailHost,
    this.mailPort,
    this.mailUsername,
    this.mailPassword,
    this.mailEncryption,
    this.mailFromAddress,
    this.mailFromName,
    this.coinValue,
    this.minimumWithdrawLimit,
    this.stripeCharges,
    this.stripePrivateKey,
    this.stripePublicKey,
    this.onesignalAppId,
    this.onesignalAppKey,
    this.minimumWithdrawAmount,
    this.basicUserWithdrawFee,
    this.checkTournament,
    this.isWalletEnable,
    this.isDiscordLogin,
  });

  factory SiteSetting.fromJson(Map<String, dynamic> json) {
    return SiteSetting(
      paypalClientId: json['paypal_client_id'],
      paypalSecretId: json['paypal_client_secret'],
      isGoogleLogin: json['check-google-login'],
      isAppleLogin: json['check-apple-login'],
      isFacebookLogin: json['check-facebook-login'],
      isDiscordLogin: json['check-discord-login'],
      appName: json['app_name'],
      appEmail: json['app_email'],
      appContactNo: json['app_contact_no'],
      appLocation: json['app_location'],
      appCopyright: json['app_copyright'],
      appFrontendUrl: json['app_frontend_url'],
      appDefaultCurrency: json['app_default_currency'],
      appDefaultLanguage: json['app_default_language'],
      appLogo: json['app_logo'],
      pwaLogo: json['pwa_logo'],
      appFavIcon: json['app_fav_icon'],
      adminMainLogoFooterLogo: json['admin_main_logo_footer_logo'],
      watermarkImage: json['watermark_image'],
      registerationApproval: json['registeration_approval'],
      facebookUrl: json['facebook_url'],
      instagramUrl: json['instagram_url'],
      linkedinUrl: json['linkedin_url'],
      twitterUrl: json['twitter_url'],
      pinterestUrl: json['pinterest_url'],
      tiktokUrl: json['tiktok_url'],
      appUrl: json['app_url'],
      storageDriver: json['storage_driver'],
      awsAccessKeyId: json['aws_access_key_id'],
      awsSecretAccessKey: json['aws_secret_access_key'],
      awsDefaultRegion: json['aws_default_region'],
      awsBucket: json['aws_bucket'],
      googleLoginStatus: json['google_login_status'],
      googleClientId: json['google_client_id'],
      googleClientSecret: json['google_client_secret'],
      facebookLoginStatus: json['facebook_login_status'],
      facebookClientId: json['facebook_client_id'],
      facebookClientSecret: json['facebook_client_secret'],
      appMailStatus: json['app_mail_status'],
      mailMailer: json['mail_mailer'],
      mailHost: json['mail_host'],
      mailPort: json['mail_port'],
      mailUsername: json['mail_username'],
      mailPassword: json['mail_password'],
      mailEncryption: json['mail_encryption'],
      mailFromAddress: json['mail_from_address'],
      mailFromName: json['mail_from_name'],
      coinValue: json['coin_value'],
      minimumWithdrawLimit: json['minimum_withdraw_limit'],
      stripeCharges: json['stripe_charges'],
      stripePrivateKey: json['stripe_secret_key'],
      stripePublicKey: json['stripe_public_key'],
      onesignalAppId: json['onesignal_app_id'],
      onesignalAppKey: json['onesignal_app_key'],
      minimumWithdrawAmount: json['minimum_withdraw_amount'],
      basicUserWithdrawFee: json['basic_user_withdraw_fee'],
      checkTournament: json['check-tournament'],
      isWalletEnable: json['is_wallet_enable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_client_id': paypalClientId,
      'paypal_client_secret': paypalSecretId,
      'check-discord-login': isDiscordLogin,
      'check-apple-login': isAppleLogin,
      'check-google-login': isGoogleLogin,
      'check-facebook-login': isFacebookLogin,
      'app_name': appName,
      'app_email': appEmail,
      'app_contact_no': appContactNo,
      'app_location': appLocation,
      'app_copyright': appCopyright,
      'app_frontend_url': appFrontendUrl,
      'app_default_currency': appDefaultCurrency,
      'app_default_language': appDefaultLanguage,
      'app_logo': appLogo,
      'pwa_logo': pwaLogo,
      'app_fav_icon': appFavIcon,
      'admin_main_logo_footer_logo': adminMainLogoFooterLogo,
      'watermark_image': watermarkImage,
      'registeration_approval': registerationApproval,
      'facebook_url': facebookUrl,
      'instagram_url': instagramUrl,
      'linkedin_url': linkedinUrl,
      'twitter_url': twitterUrl,
      'pinterest_url': pinterestUrl,
      'tiktok_url': tiktokUrl,
      'app_url': appUrl,
      'storage_driver': storageDriver,
      'aws_access_key_id': awsAccessKeyId,
      'aws_secret_access_key': awsSecretAccessKey,
      'aws_default_region': awsDefaultRegion,
      'aws_bucket': awsBucket,
      'google_login_status': googleLoginStatus,
      'google_client_id': googleClientId,
      'google_client_secret': googleClientSecret,
      'facebook_login_status': facebookLoginStatus,
      'facebook_client_id': facebookClientId,
      'facebook_client_secret': facebookClientSecret,
      'app_mail_status': appMailStatus,
      'mail_mailer': mailMailer,
      'mail_host': mailHost,
      'mail_port': mailPort,
      'mail_username': mailUsername,
      'mail_password': mailPassword,
      'mail_encryption': mailEncryption,
      'mail_from_address': mailFromAddress,
      'mail_from_name': mailFromName,
      'coin_value': coinValue,
      'minimum_withdraw_limit': minimumWithdrawLimit,
      'stripe_charges': stripeCharges,
      'stripe_secret_key': stripePrivateKey,
      'stripe_public_key': stripePublicKey,
      'onesignal_app_id': onesignalAppId,
      'onesignal_app_key': onesignalAppKey,
      'minimum_withdraw_amount': minimumWithdrawAmount,
      'basic_user_withdraw_fee': basicUserWithdrawFee,
      'check-tournament': checkTournament,
      'is_wallet_enable': isWalletEnable,
    };
  }
}
