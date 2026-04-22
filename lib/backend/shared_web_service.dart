// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_environment.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SharedWebService {
  static String get _BASE_URL => AppEnvironment.apiBaseUrl;

  final Duration _timeoutDuration = const Duration(seconds: 40);
  static SharedWebService? _instance;
  final _sharedPrefHelper = SharedPreferenceHelper.instance();

  SharedWebService._();

  static SharedWebService instance() {
    _instance ??= SharedWebService._();
    return _instance!;
  }

  void handleTokenExpiration(BuildContext context, int statusCode) {
    if (statusCode == 401 || statusCode == 409) {
      // Clear stored token
      _sharedPrefHelper.clear();
      // Navigate to selection screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes.selectionView,
        (route) => false,
      );
    }
  }

  Future<Map<String, String>> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final accessToken = await _sharedPrefHelper.getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<http.Response> _handleResponse(
    http.Response response,
    BuildContext? context,
  ) async {
    if (context != null) {
      log('response.statusCode: ${response.statusCode}');
      handleTokenExpiration(context, response.statusCode);
    }
    return response;
  }

  Map<String, dynamic> _decodeJsonMap(
    http.Response response, {
    String? endpoint,
  }) {
    final responseBody = response.body.trimLeft();

    if (responseBody.isEmpty) {
      throw const FormatException('Empty response body');
    }

    if (!responseBody.startsWith('{') && !responseBody.startsWith('[')) {
      final compactBody = response.body.replaceAll(RegExp(r'\s+'), ' ').trim();
      final preview = compactBody.length > 140
          ? compactBody.substring(0, 140)
          : compactBody;
      final requestTarget =
          response.request?.url.toString() ?? endpoint ?? 'API';

      throw FormatException(
        'Expected JSON from $requestTarget but received: $preview',
      );
    }

    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('Expected a JSON object response');
  }

  Future<LoginAuthenticationResponse> signup(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final headers = await _getHeaders();
    final body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
    };

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/sign-up'),
          headers: headers,
          body: json.encode(body),
        )
        .timeout(_timeoutDuration);

    debugPrint(' response $response');
    final responseBody = response.body;
    debugPrint(' response Body $responseBody');
    final jsonResponse = json.decode(responseBody);
    debugPrint('json respons $jsonResponse');
    final statusMessageResponse = StatusMessageResponse.fromJson(jsonResponse);
    debugPrint('status Message Response $statusMessageResponse');
    final userJson = _findUserJson(jsonResponse);
    debugPrint('user json ----- $userJson');
    if (userJson != null) {
      await SharedPreferenceHelper.instance().saveAccessToken(
        userJson['token'],
      );
      return LoginAuthenticationResponse.fromJson(jsonResponse);
    } else {
      // Handle case where "user" object is not found in the response
      return LoginAuthenticationResponse(
        null,
        statusMessageResponse.status,
        statusMessageResponse.message,
      );
    }
  }

  static Map<String, dynamic>? _findUserJson(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      final data = json['data'];
      if (data is Map<String, dynamic> && data.containsKey('token')) {
        return data;
      }
    }
    return null;
  }

  /// Login method
  Future<LoginAuthenticationResponse> login({
    email,
    password,
    deviceType,
    deviceId,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders();
    final requestData = {
      'email': email,
      if (password != null) 'password': password,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceType != null) 'device_model': deviceType,
    };

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/sign-in'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final jsonResponse = _decodeJsonMap(
      response,
      endpoint: '$_BASE_URL/sign-in',
    );
    final loginResponse = LoginAuthenticationResponse.fromJson(jsonResponse);
    final loginData = _findUserJson(jsonResponse);

    if (loginResponse.status == 200 && loginData != null) {
      await SharedPreferenceHelper.instance().saveAccessToken(
        loginData['token'],
      );
    }

    log(jsonResponse.toString());
    return loginResponse;
  }

  /// Login method
  Future<StatusMessageResponse> otpVerify({email, otp}) async {
    final requestData = {'email': email, 'otp': otp};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    debugPrint('body---------$requestData');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/submit-otp'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('response in api --- ${response.toString()}');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    final jsonResponse = json.decode(responseBody);
    debugPrint('jsonResponse in api --- ${jsonResponse.toString()}');
    await SharedPreferenceHelper.instance().saveAccessToken(
      jsonResponse['token'],
    );
    return StatusMessageResponse.fromJson(jsonResponse);
  }

  ///  Social Login method
  Future<LoginAuthenticationResponse> socialLogin({token, provider}) async {
    final requestData = {'access_token': token, 'provider': provider};
    final headers = await _getHeaders();
    debugPrint('object${requestData}');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/social_login'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);
    final jsonResponse = _decodeJsonMap(
      response,
      endpoint: '$_BASE_URL/social_login',
    );
    debugPrint("json response${jsonResponse.toString()}");
    await SharedPreferenceHelper.instance().saveAccessToken(
      jsonResponse['data']['token'],
    );
    return LoginAuthenticationResponse.fromJson(jsonResponse);
  }

  ///  Social Login method
  Future<LoginAuthenticationResponse> appleLogin({email, name}) async {
    debugPrint(email);
    debugPrint(name);
    final requestData = {'email': email, 'name': name};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/apple-login'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final jsonResponse = _decodeJsonMap(
      response,
      endpoint: '$_BASE_URL/apple-login',
    );
    debugPrint(jsonResponse.toString());
    await SharedPreferenceHelper.instance().saveAccessToken(
      jsonResponse['data']['token'],
    );

    return LoginAuthenticationResponse.fromJson(jsonResponse);
  }

  Future<LoginAuthenticationResponse> firebaseLogin({
    required String email,
    required String firebaseUid,
    String? idToken,
    String? name,
    String? deviceId,
    String? deviceType,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders();
    final requestData = {
      'email': email,
      'firebase_uid': firebaseUid,
      if (idToken != null && idToken.isNotEmpty) 'id_token': idToken,
      if (name != null && name.isNotEmpty) 'name': name,
      if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
      if (deviceType != null && deviceType.isNotEmpty)
        'device_model': deviceType,
    };

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/firebase-login'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final jsonResponse = _decodeJsonMap(
      response,
      endpoint: '$_BASE_URL/firebase-login',
    );
    final userJson = _findUserJson(jsonResponse);
    if (userJson != null && userJson['token'] != null) {
      await SharedPreferenceHelper.instance().saveAccessToken(
        userJson['token'],
      );
    }

    return LoginAuthenticationResponse.fromJson(jsonResponse);
  }

  Future<StatusMessageResponse> forgotPassword({required String email}) async {
    final requestData = {'email': email};
    final headers = await _getHeaders();

    debugPrint('request data -0----------------$requestData');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/reset-password'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('response in api --- ${response.toString()}');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    final jsonResponse = json.decode(responseBody);
    debugPrint('jsonResponse in api --- ${jsonResponse.toString()}');
    return StatusMessageResponse.fromJson(jsonResponse);
  }

  Future<StatusMessageResponse> resetOtpVerify({email, otp}) async {
    final requestData = {'email': email, 'reset_code': otp};
    final headers = await _getHeaders();

    debugPrint('requedt data ----------${requestData}');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/reset-password-verified'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('response in api --- ${response.toString()}');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    final jsonResponse = json.decode(responseBody);
    debugPrint('jsonResponse in api --- ${jsonResponse.toString()}');
    return StatusMessageResponse.fromJson(jsonResponse);
  }

  Future<StatusMessageResponse> resendOtp({required String email}) async {
    final requestData = {'email': email};
    final headers = await _getHeaders();

    debugPrint('request data -0----------------$requestData');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/resend-otp'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('response in api --- ${response.toString()}');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    final jsonResponse = json.decode(responseBody);
    debugPrint('jsonResponse in api --- ${jsonResponse.toString()}');
    return StatusMessageResponse.fromJson(jsonResponse);
  }

  Future<StatusMessageResponse> createNewPassword({
    email,
    newPassword,
    confirmPassword,
  }) async {
    final requestData = {
      'email': email,
      'password': newPassword,
      'password_confirmation': confirmPassword,
    };
    final headers = await _getHeaders();

    debugPrint('requedt data ----------${requestData}');
    final response = await http
        .post(
          Uri.parse('$_BASE_URL/change-password'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('response in api --- ${response.toString()}');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    final jsonResponse = json.decode(responseBody);
    debugPrint('jsonResponse in api --- ${jsonResponse.toString()}');
    return StatusMessageResponse.fromJson(jsonResponse);
  }

  /// Login method
  Future<IBaseResponse> addBalance({transactionId, methodId}) async {
    final requestData = {
      'transaction_id': transactionId,
      'withdraw_method_id': methodId,
    };

    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/deposit-amount'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  // Create Comment

  /// Login method
  Future<IBaseResponse> createComment({text, id}) async {
    final requestData = {'comment': text, if (id != null) 'post_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/add-post-comment'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> resetPassword({email}) async {
    final requestData = {'email': email};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/reset-password'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  /////social  update

  /// Edit Profile

  Future<UpdateProfileResponse> socialUpdateProfile(
    String id,
    String username,
    String mobile,
    String dateOfBirth,
    String country,
    String userType,
    String deviceType,
    String signalid,
    String gender,
    String image,
    String timezone,
    String about,
  ) async {
    final accessToken = await _sharedPrefHelper.getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      'id': id,
      if (username.isNotEmpty) "username": username,
      if (mobile.isNotEmpty) "mobile": mobile,
      if (dateOfBirth.isNotEmpty) "date_of_birth": dateOfBirth,
      if (country.isNotEmpty) "region_id": country,
      if (userType.isNotEmpty) "user_type": userType,
      if (signalid.isNotEmpty) 'signal_id': signalid,
      if (deviceType.isNotEmpty) 'device_model': deviceType,
      if (gender.isNotEmpty) 'gender': gender,
      if (about.isNotEmpty) 'about': about,
      if (timezone.isNotEmpty) 'timezone': timezone,
    };
    final uri = Uri.parse('$_BASE_URL/update-profile');
    final request = http.MultipartRequest('POST', uri);
    if (image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath(
        'profile_image',
        image,
      );
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    final finalResponse = UpdateProfileResponse.fromJson(
      json.decode(responseData),
    );
    return finalResponse;
  }

  /// Edit Profile

  Future<UpdateProfileResponse> updateProfile({
    String id = '',
    String firstName = '',
    String lastName = '',
    String email = '',
    String image = '',
    String cover = '',
    String facebook = '',
    String twitch = '',
    String youtube = '',
    String discord = '',
    String gender = '',
    String about = '',
    String userType = '',
    String username = '',
    String dob = '',
    String phone = '',
    String notify_join_tournament = '',
    String notify_follow_channel = '',
    String notify_follow_organization = '',
    String notify_follow_user = '',
    BuildContext? context,
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      if (firstName.isNotEmpty) 'first_name': firstName,
      if (lastName.isNotEmpty) 'last_name': lastName,
      if (email.isNotEmpty) 'email': email,
      if (gender.isNotEmpty) 'gender': gender,
      if (about.isNotEmpty) 'about': about,
      if (facebook.isNotEmpty) 'facebook': facebook,
      if (discord.isNotEmpty) 'discord': discord,
      if (youtube.isNotEmpty) 'youtube': youtube,
      if (twitch.isNotEmpty) 'twitch': twitch,
      if (userType.isNotEmpty) 'user_type': userType,
      if (username.isNotEmpty) "username": username,
      if (dob.isNotEmpty) "dob": dob,
      "is_profile_complete": "1",
      if (notify_join_tournament.isNotEmpty)
        "notify_join_tournament": notify_join_tournament,
      if (notify_follow_channel.isNotEmpty)
        "notify_follow_channel": notify_follow_channel,
      if (notify_follow_organization.isNotEmpty)
        "notify_follow_organization": notify_follow_organization,
      if (notify_follow_user.isNotEmpty)
        "notify_follow_user": notify_follow_user,
    };

    final uri = Uri.parse('$_BASE_URL/update-profile');
    final request = http.MultipartRequest('POST', uri);
    if (image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('image', image);
      request.files.add(imageFile);
    }
    if (cover.isNotEmpty) {
      final coverfile = await http.MultipartFile.fromPath('cover', cover);
      request.files.add(coverfile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    // Handle token expiration for MultipartRequest
    final jsonResponse = json.decode(responseData);
    if (context != null &&
        (jsonResponse['status'] == 409 || jsonResponse['status'] == 401)) {
      handleTokenExpiration(context, jsonResponse['status']);
    }

    return UpdateProfileResponse.fromJson(jsonResponse);
  }

  /// Change Password
  Future<StatusMessageResponse> changePassword({
    password,
    newConfirmPassword,
    oldPassword,
  }) async {
    final headers = await _getHeaders();
    final requestData = {
      'password': password,
      'c_password': newConfirmPassword,
      'old_password': oldPassword,
    };

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/change-user-password'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  /// Change Password

  Future<StatusMessageResponse> transferBalance({
    password,
    toUserId,
    amount,
  }) async {
    final headers = await _getHeaders();
    final requestData = {
      'to_userId': toUserId,
      'password': password,
      'amount': amount,
    };

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/transfer-amount'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  // Create Post
  Future<CreatePostResponse> createPortfolio({
    String title = '',
    String description = '',
    String image = '',
    String postVideo = '',
    String thumbnail = '',
  }) async {
    // Retrieve the access token from SharedPreferences
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();

    // Check if the access token is available
    if (accessToken == null) {
      // Handle the case where the access token is not available
      throw Exception("Access token not available");
    }

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    };
    debugPrint('title---$title');
    debugPrint('description---$description');
    debugPrint('image---$image');
    debugPrint('video---$postVideo');
    final body = {'title': title, 'description': description};
    if (image.isNotEmpty) {
      body['media_type'] = '1';
    }
    if (postVideo.isNotEmpty) {
      body['media_type'] = '2';
    }

    final uri = Uri.parse('$_BASE_URL/create-portfolio');
    final request = http.MultipartRequest('POST', uri);

    if (image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('media', image);
      request.files.add(imageFile);
    }
    if (postVideo.isNotEmpty) {
      final videoFile = await http.MultipartFile.fromPath('media', postVideo);
      request.files.add(videoFile);
    }

    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('responseData-------$responseData');
    final finalResponse = CreatePostResponse.fromJson(
      json.decode(responseData),
    );
    return finalResponse;
  }

  // get all posts

  Future<AllPostFeedModel> getAllPosts({
    int offset = 0,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/all-posts?limit=10&offset=$offset');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;

    return AllPostFeedModel.fromJson(json.decode(responseBody));
  }

  // userall posts

  Future<AllPostFeedModel> getuserposts({
    int offset = 0,
    int userid = 0,
  }) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-userposts?user_id=$userid&limit=10&offset=$offset',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return AllPostFeedModel.fromJson(json.decode(responseBody));
  }

  ////////////  Get COMMENTS DATA //////////////////
  Future<GetAllCommentsData> getCommentData({postId}) async {
    final uri = Uri.parse('$_BASE_URL/get-comments?post_id=$postId');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetAllCommentsData.fromJson(json.decode(responseBody));
  }

  // AddFavouriteBusinessById
  Future<IBaseResponse> likeDislikePost(postid) async {
    final requestData = {'post_id': postid};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/like-unlike-post'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  // ///// contact us api
  Future<IBaseResponse> contactUsApi(
    String id,
    String fullname,
    String message,
    String email,
  ) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    final body = {'name': fullname, 'message': message, 'email': email};

    final uri = Uri.parse('$_BASE_URL/contact-us');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    final finalResponse = StatusMessageResponse.fromJson(
      json.decode(responseData),
    );

    return finalResponse;
  }

  //  get country
  Future<CountryApiResponse> getRegion() async {
    final uri = Uri.parse('$_BASE_URL/region-list?offset=0&limit=12');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return CountryApiResponse.fromJson(json.decode(responseBody));
  }

  // get notification

  // ///////Get Fav Bussiness By ID
  Future<NotificationApiResponse> getnotifications({
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-notifications?offset=0&limit=30');
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;

    return NotificationApiResponse.fromJson(json.decode(responseBody));
  }

  /////////////////  create Organization   ////////////////////

  Future<CreateOrganizationResponse> createOrganization({
    String name = '',
    String description = '',
    String logo = '',
    String type = '',
    String facebook = '',
    String instagram = '',
    String youtube = '',
    String header_image = '',
    String twitch_username = '',
    String discord_invite_link = '',
    String website = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    debugPrint('token ---- $accessToken');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {
      if (name.isNotEmpty) 'name': name,
      if (type.isNotEmpty) 'type': type,
      if (description.isNotEmpty) 'description': description,
      if (facebook.isNotEmpty) 'facebook': facebook,
      if (instagram.isNotEmpty) 'instagram': instagram,
      if (youtube.isNotEmpty) 'youtube': youtube,
      if (twitch_username.isNotEmpty) 'twitch_username': twitch_username,
      if (discord_invite_link.isNotEmpty)
        'discord_invite_link': discord_invite_link,
      if (website.isNotEmpty) 'website': website,
    };
    debugPrint('body ---- ${body.toString()}');
    final uri = Uri.parse('$_BASE_URL/create-organization');
    final request = http.MultipartRequest('POST', uri);

    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('logo', logo);
      request.files.add(imageFile);
    }
    if (header_image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath(
        'header_image',
        header_image,
      );
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return CreateOrganizationResponse.fromJson(json.decode(responseData));
  }

  Future<CreateOrganizationResponse> createChannel({
    String name = '',
    String description = '',
    String logo = '',
    String header_image = '',
    String org_id = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    debugPrint('token ---- $accessToken');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {
      if (name.isNotEmpty) 'name': name,
      if (description.isNotEmpty) 'description': description,
      if (org_id.isNotEmpty) 'org_id': org_id,
    };
    debugPrint('body ---- ${body.toString()}');
    final uri = Uri.parse('$_BASE_URL/create-channel');
    final request = http.MultipartRequest('POST', uri);

    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('logo', logo);
      request.files.add(imageFile);
    }
    if (header_image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath(
        'header',
        header_image,
      );
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return CreateOrganizationResponse.fromJson(json.decode(responseData));
  }

  Future<StatusMessageResponse> updateChannel({
    required String channel_id,
    String name = '',
    String description = '',
    String logo = '',
    String header_image = '',
    String org_id = '',
  }) async {
    final accessToken = await _sharedPrefHelper.getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      'channel_id': channel_id,
      if (name.isNotEmpty) 'name': name,
      if (description.isNotEmpty) 'description': description,
      if (org_id.isNotEmpty) 'org_id': org_id,
    };

    final uri = Uri.parse('$_BASE_URL/update-channel');
    final request = http.MultipartRequest('POST', uri);

    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('logo', logo);
      request.files.add(imageFile);
    }
    if (header_image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath(
        'header',
        header_image,
      );
      request.files.add(imageFile);
    }

    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  ///////////////  Add Staff  //////////////////

  Future<IBaseResponse> addStaff({
    String userId = '',
    String or_id = '',
    String roleiD = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {'user_id': userId, 'role': roleiD, 'org_id': or_id};

    final uri = Uri.parse('$_BASE_URL/add-staff');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  /// Change Password
  Future<GetSearchData> searchData({querry, source}) async {
    final headers = await _getHeaders();
    final requestData = {'search_string': querry, 'source': source};

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/search'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetSearchData.fromJson(json.decode(responseBody));
  }

  /// GET GAMES
  Future<GetGamesResponse> getGames({offset = 0, BuildContext? context}) async {
    final headers = await _getHeaders();

    final response = await http
        .get(
          Uri.parse('$_BASE_URL/get-games?offset=$offset&limit=25'),
          headers: headers,
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetGamesResponse.fromJson(json.decode(responseBody));
  }

  Future<GetChannelsResponse> getChannels({
    offset = 0,
    limit = 10,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders();

    final response = await http
        .get(
          Uri.parse('$_BASE_URL/get-channels?offset=$offset&limit=$limit'),
          headers: headers,
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetChannelsResponse.fromJson(json.decode(responseBody));
  }

  Future<GetChannelData> getChannelsByChannelId(
    String channelId, {
    offset = 0,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders();

    final response = await http
        .get(
          Uri.parse('$_BASE_URL/channel-detail?channel_id=$channelId'),
          headers: headers,
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetChannelData.fromJson(json.decode(responseBody));
  }

  Future<GetLiveStreamsResponse> getLiveStreamsByChannelId(
    String channelId, {
    offset = 0,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(
          Uri.parse('$_BASE_URL/livestream-list?channel_id=$channelId'),
          headers: headers,
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetLiveStreamsResponse.fromJson(json.decode(responseBody));
  }

  Future<GetLiveStreamToken> createLiveStream(
    String channelName,
    String channelId,
    String title,
    String thumbnail,
  ) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      'channel_name': channelName,
      'channel_id': channelId,
      'title': title,
    };
    final uri = Uri.parse('$_BASE_URL/generate-agora-token');
    final request = http.MultipartRequest('POST', uri);

    if (thumbnail.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath(
        'thumbnail',
        thumbnail,
      );
      request.files.add(imageFile);
    }

    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('response   $responseData');
    return GetLiveStreamToken.fromJson(json.decode(responseData));
  }

  Future<GetChannelsResponse> getChannelsByOrganizationId(
    String orgId, {
    offset = 0,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders();

    final response = await http
        .get(
          Uri.parse(
            '$_BASE_URL/get-channels-by-org?offset=$offset&limit=25&org_id=$orgId',
          ),
          headers: headers,
        )
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetChannelsResponse.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> getMyOrganization({
    userid,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final uri = Uri.parse('$_BASE_URL/get-user-organizations');
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;

    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> getAllOrganization({offset = 0}) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-all-organizations?offset=$offset&limit=25',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('response   $responseBody');
    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> getTournamentCreateOrganizations() async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final uri = Uri.parse('$_BASE_URL/get-user-organizations');
    final response = await http
        .post(uri, headers: headers, body: json.encode({}))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<GetMyTournament> getMyTournamentApi({userid}) async {
    final uri = Uri.parse(
      '$_BASE_URL/joined-tournaments-by-user-id?user_id=$userid',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetProPackagesResponse> getProPakagesApi({
    BuildContext? context,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final uri = Uri.parse('$_BASE_URL/get-all-packages');
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetProPackagesResponse.fromJson(json.decode(responseBody));
  }

  Future<GetSearchUserResponse> getSearchUserwithType(type) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-user-by-type?type=$type&limit=10&offset=0',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetSearchUserResponse.fromJson(json.decode(responseBody));
  }

  Future<GetUserDataWithId> getUserDataWithId({
    int id = 0,
    BuildContext? context,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final uri = Uri.parse('$_BASE_URL/get-user-by-id?user_id=$id');
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetUserDataWithId.fromJson(json.decode(responseBody));
  }

  ///////////// create tournament /////////

  Future<CreateTournamentResponse> createTournament({
    String name = '',
    String about = '',
    String gameId = '',
    String banner = '',
    String start_time = '',
    String rules = '',
    String region_id = '',
    String registration_participant_limit = '',
    String registration_region = '',
    String registration_regions = '',
    String org_id = '',
    String bracket_format = '',
    String tournament_format = '',
    String schedule = '',
    String contact_option = '',
    String check_in_time = '',
    String dateInitial = '',
    String dateFinal = '',
    String timeZone = '',
    String contact_value = '',
    String first_prize = '',
    String second_prize = '',
    String is_reward = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      if (gameId.isNotEmpty) 'game_id': gameId,
      if (start_time.isNotEmpty) 'start_time': start_time,
      if (name.isNotEmpty) 'name': name,
      if (about.isNotEmpty) 'description': about,
      if (rules.isNotEmpty) 'rules': rules,
      if (region_id.isNotEmpty) 'region_id': region_id,
      if (registration_participant_limit.isNotEmpty)
        'registration_participant_limit': registration_participant_limit,
      if (registration_region.isNotEmpty)
        'registration_regions': registration_region,
      if (registration_regions.isNotEmpty)
        'selected_regions': registration_regions,
      if (org_id.isNotEmpty) 'org_id': org_id,
      if (bracket_format.isNotEmpty) 'bracket_format': bracket_format,
      if (tournament_format.isNotEmpty) 'format': tournament_format,
      if (schedule.isNotEmpty) 'schedule': schedule,
      if (contact_option.isNotEmpty) 'contact_option': contact_option,
      if (check_in_time.isNotEmpty) 'check_in_time': check_in_time,
      if (dateInitial.isNotEmpty) 'dateIni': dateInitial,
      if (dateFinal.isNotEmpty) 'dateFin': dateFinal,
      'seeding_type': '1',
      if (timeZone.isNotEmpty) 'timezone': timeZone,
      if (contact_value.isNotEmpty) 'contact_value': contact_value,
      if (first_prize.isNotEmpty) 'first_prize': first_prize,
      if (second_prize.isNotEmpty) 'second_prize': second_prize,
      if (is_reward.isNotEmpty) 'is_reward': is_reward,
    };
    debugPrint('body------$body');
    final uri = Uri.parse('$_BASE_URL/add-tournament');
    final request = http.MultipartRequest('POST', uri);
    debugPrint('uri------$uri');
    if (banner.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('banner', banner);
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('responseData Create Tournament------ $responseData');
    return CreateTournamentResponse.fromJson(json.decode(responseData));
  }

  Future<GetMyTournament> homeTournamentApi({
    offset = 0,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-tournaments');
    final headers = await _getHeaders();
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint("DDDDDDDDDDDDDD $responseBody");
    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetMyTeam> getTeamApi({offset = 0}) async {
    final uri = Uri.parse('$_BASE_URL/get-my-teams');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint("DDDDDDDDDDDDDD $responseBody");
    return GetMyTeam.fromJson(json.decode(responseBody));
  }

  Future<GetTeamMembers> getTeamMembersApi({
    offset = 0,
    required teamId,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-team-member?team_id=$teamId');
    final headers = await _getHeaders();

    debugPrint("uri------------- $uri");
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint("DDDDDDDDDDDDDD $responseBody");
    return GetTeamMembers.fromJson(json.decode(responseBody));
  }

  Future<GetFollowedChannels> followedChannelsApi({
    offset = 0,
    limit = 10,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-subscribed-channels');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint("DDDDDDDDDDDDDD $responseBody");
    return GetFollowedChannels.fromJson(json.decode(responseBody));
  }

  Future<GetMyTournament> tournamentHistory(id) async {
    final uri = Uri.parse('$_BASE_URL/tournament-history?user_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint("Tournament History $responseBody");
    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> followedOrganizationApi({
    offset = 0,
    limit = 10,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-followed-organizations');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;

    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> popularOrganizationApi({
    offset = 0,
    limit = 10,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/get-popular-organizations');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;

    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<BannersApiResponse> getBanners() async {
    final uri = Uri.parse('$_BASE_URL/get-banners');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    debugPrint('response in api --- $response');
    final responseBody = response.body;
    debugPrint('responseBody in api --- ${responseBody.toString()}');
    return BannersApiResponse.fromJson(json.decode(responseBody));
  }

  ////////////follow user //////////
  Future<IBaseResponse> followUser({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/follow-user');
    final body = {'following_id': id};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> subscribeChannel({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/subscribe-channel');
    debugPrint('url-----------$uri');
    final body = {'channel_id': id};
    debugPrint('body-----------$body');
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseBody-----------$responseBody');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<AllPostFeedModel> getPortfolio({int offset = 0}) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-my-portfolio?limit=10&offset=$offset',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint("PORTFOLIOOOOOOOOOOO$responseBody");
    return AllPostFeedModel.fromJson(json.decode(responseBody));
  }

  ////////////  sendMessage  //////////
  Future<AllChatApiResponse> sendMessage({
    String tournamentId = '0',
    message,
    String matchId = '0',
    media,
  }) async {
    final uri = Uri.parse('$_BASE_URL/send-message');
    final body = {
      'tournament_id': tournamentId.toString(),
      'match_id': matchId.toString(),
      'message': message.toString(),
      'type': "2",
      'media_type': '1',
    };
    final request = http.MultipartRequest('POST', uri);
    if (media.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('media', media);
      request.files.add(imageFile);
    }
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('responseData------------$responseData');
    return AllChatApiResponse.fromJson(json.decode(responseData));
  }

  Future<AllChatApiResponse> getAllMessage({
    int offset = 0,
    tournamentId,
    matchId,
    BuildContext? context,
  }) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-tournament-messages?limit=10&offset=$offset&tournament_id=$tournamentId&match_id=$matchId',
    );
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('responseBody------------$responseBody');
    return AllChatApiResponse.fromJson(json.decode(responseBody));
  }

  //////////// Join Tournamnet //////////
  Future<IBaseResponse> joinTournament({id = ''}) async {
    debugPrint('id---🤣🤣🤣🤣🤣${id.toString()}');
    try {
      final uri = Uri.parse('$_BASE_URL/join-tournament');
      final body = {'tournament_id': id.toString()};
      final headers = await _getHeaders();
      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeoutDuration);

      final responseBody = response.body;
      debugPrint('rsesposee----------$responseBody');
      if (responseBody.isEmpty) {
        throw Exception('Empty response body');
      }

      // Parse the response body and return it as a StatusMessageResponse
      return StatusMessageResponse.fromJson(json.decode(responseBody));
    } catch (e) {
      // Handle the error and return a suitable response
      return StatusMessageResponse(
        status: 400,
        message: 'Failed to join tournament: $e',
      );
    }
  }

  Future<GetMyTournament> joinTournamentApi() async {
    final uri = Uri.parse('$_BASE_URL/joined-tournaments');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetMyTournament> myTournamentApi({
    offset = 0,
    BuildContext? context,
  }) async {
    final uri = Uri.parse('$_BASE_URL/my-tournaments?offset=$offset&limit=10');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganizationData> getOrganizationById({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/get-organization-details?org_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetMyOrganizationData.fromJson(json.decode(responseBody));
  }

  ////////////follow user //////////

  Future<IBaseResponse> followOrganization({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/follow-organization');
    final body = {'org_id': id};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'application/json'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    log('responseBody Organization ------ $responseBody');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<GetMyTournament> organizationTournaments(String id) async {
    final uri = Uri.parse('$_BASE_URL/get-tournament-by-org?org_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseBody Organization ------ $responseBody');
    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<GetMyOrganization> getFollowedOrganization() async {
    final uri = Uri.parse('$_BASE_URL/get-followed-organizations');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetMyOrganization.fromJson(json.decode(responseBody));
  }

  Future<GetTournamentData> getTournamentById({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/tournament-details?tournament_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetTournamentData.fromJson(json.decode(responseBody));
  }

  Future<PrivacyData> getTermsandCondition() async {
    final uri = Uri.parse('$_BASE_URL/term-conditions');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return PrivacyData.fromJson(json.decode(responseBody));
  }

  Future<PrivacyData> getPrivacyPolicy() async {
    final uri = Uri.parse('$_BASE_URL/privacy-policy');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return PrivacyData.fromJson(json.decode(responseBody));
  }

  Future<AllPostFeedModel> getUserPortfolio({
    int offset = 0,
    int userid = 0,
    BuildContext? context,
  }) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-portfolio-by-userid?limit=10&offset=$offset&user_id=$userid',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return AllPostFeedModel.fromJson(json.decode(responseBody));
  }

  Future<AllPostFeedModel> getMyPortfolio({
    int offset = 0,
    BuildContext? context,
  }) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-my-portfolio?limit=10&offset=$offset',
    );
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return AllPostFeedModel.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> upgradePro({int id = 0, subId}) async {
    final uri = Uri.parse('$_BASE_URL/upgrade-to-pro');
    final body = {'package_id': id, 'stripe_subscription_id': subId};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<GetSearchUserResponse> getparticipants({int id = 0}) async {
    final uri = Uri.parse(
      '$_BASE_URL/tournament-participants?tournament_id=$id',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody);
    return GetSearchUserResponse.fromJson(json.decode(responseBody));
  }

  Future<DepositHistoryParse> getDepositHistory({
    int offset = 0,
    int userid = 0,
  }) async {
    final uri = Uri.parse('$_BASE_URL/deposit/history');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('response $response');
    debugPrint('responseBody $responseBody');
    return DepositHistoryParse.fromJson(json.decode(responseBody));
  }

  Future<WithdrawHistoryParse> getWithdrawHistory({
    int offset = 0,
    int userid = 0,
  }) async {
    final uri = Uri.parse('$_BASE_URL/withdraw-history?limit=15&offset=0');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    debugPrint('response------------------$response');
    final responseBody = response.body;
    debugPrint('responseBody------------------$responseBody');
    return WithdrawHistoryParse.fromJson(json.decode(responseBody));
  }

  Future<GetBalance> getbalance({int offset = 0, int userid = 0}) async {
    final uri = Uri.parse('$_BASE_URL/get-user-wallet');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetBalance.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> withdrawRequest({
    amount,
    type,
    paypalEmail,
    iban,
    country,
    address,
    swiftcode,
    fullName,
    account,
    bankName,
  }) async {
    final requestData = {
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (paypalEmail != null) 'paypal_email': paypalEmail,
      if (iban != null) 'iban': iban,
      if (address != null) 'address': address,
      if (country != null) 'country': country,
      if (swiftcode != null) 'swift_code': swiftcode,
      if (fullName != null) 'full_name': fullName,
      if (account != null) 'bank_account_no': account,
      if (bankName != null) 'bank_name': bankName,
    };
    debugPrint('requestData------------$requestData');
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/withdraw-request'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('response------------$response');
    debugPrint('response body------------$responseBody');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<TransactionParse> getTransactions({
    int offset = 0,
    int userid = 0,
  }) async {
    final uri = Uri.parse('$_BASE_URL/transaction-history?limit=10&offset=0');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('response----$response');
    debugPrint('responseBody----$responseBody');
    return TransactionParse.fromJson(json.decode(responseBody));
  }

  Future<MatchDataParse> getMatchData({int offset = 0, int id = 0}) async {
    final requestData = {'match_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/match-detail?match_id=$id'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    debugPrint('uri--------$response');
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return MatchDataParse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> updateMatchScore({
    int id = 0,
    String compitator1 = "",
    String compitator2 = "",
  }) async {
    final uri = Uri.parse('$_BASE_URL/update-match-score');
    final body = {
      'match_id': id,
      'competitor1_score': compitator1,
      'competitor2_score': compitator2,
    };
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseBody------------$responseBody');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> startTournament({int id = 0}) async {
    try {
      final uri = Uri.parse('$_BASE_URL/start-tournament');
      final body = {'tournament_id': id};
      final headers = await _getHeaders();
      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeoutDuration);

      final responseBody = response.body;

      debugPrint('responseBody ------------$responseBody');

      if (responseBody.isEmpty) {
        throw Exception('Empty response body');
      }

      // Parse the response body and return it as a StatusMessageResponse
      return StatusMessageResponse.fromJson(json.decode(responseBody));
    } catch (e) {
      // Handle the error and return a suitable response
      return StatusMessageResponse(
        status: 400,
        message: 'Failed to start tournament: $e',
      );
    }
  }

  Future<PlanData> getcurrentplan() async {
    final uri = Uri.parse('$_BASE_URL/get-current-plan');

    try {
      final headers = await _getHeaders();

      final response = await http
          .get(uri, headers: headers)
          .timeout(_timeoutDuration);

      // Check if the response status is successful (status code 200)
      // if (response.statusCode == 200) {
      final responseBody = response.body;
      debugPrint("PLANNNNNNNNNN: $responseBody");
      return PlanData.fromJson(json.decode(responseBody));
      // }
      // else {
      //   return PlanData([], 200, "Failed to retrieve plan. Status code: ${response.statusCode}");
      // }
    } catch (e) {
      // Handle any exceptions that occur during the request
      debugPrint("Error: Failed to retrieve plan due to an exception: $e");
      // Return a PlanData object with an error status and message
      return PlanData(
        null,
        500,
        "Failed to retrieve subscription details from Stripe: $e",
      );
    }
  }

  Future<IBaseResponse> cancelcurrentplan() async {
    final uri = Uri.parse('$_BASE_URL/cancel-current-plan');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> deleteOrganization({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/delete-organization');
    final body = {'org_id': id};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> deleteTournament({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/delete-tournament');
    final body = {'tournament_id': id};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> deletePortfolio({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/delete-portfolio');
    final body = {'portfolio_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseBody ------------$responseBody');
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> markcheckIn({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/check-in-match');
    final body = {'match_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> checkUsernameEmail({email, username}) async {
    final uri = Uri.parse('$_BASE_URL/check-username');

    final body = {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
    };
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<GetMyTournament> gamesTournamentApi(id, BuildContext context) async {
    final uri = Uri.parse('$_BASE_URL/get-game-tournaments?game_id=$id');
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetMyTournament.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> createTeam({
    String name = '',
    String logo = '',
    String gameId = '',
    String about = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      'logo': logo,
      'name': name,
      'game_id': gameId,
      'about': about,
    };

    final uri = Uri.parse('$_BASE_URL/add-team');
    final request = http.MultipartRequest('POST', uri);

    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('logo', logo);
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('response body ----------${responseData}');
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  Future<IBaseResponse> changePlayerLevel({
    int tId = 0,
    userId = 0,
    level = 0,
  }) async {
    try {
      final uri = Uri.parse('$_BASE_URL/change-player-level');
      final body = {'tournament_id': tId, 'user_id': userId, 'level': level};
      final headers = await _getHeaders();

      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeoutDuration);

      final responseBody = response.body;

      if (responseBody.isEmpty) {
        throw Exception('Empty response body');
      }
      return StatusMessageResponse.fromJson(json.decode(responseBody));
    } catch (e) {
      return StatusMessageResponse(
        status: 400,
        message: 'Failed to update level: $e',
      );
    }
  }

  Future<GetTeamsResponse> getmyTeams() async {
    final uri = Uri.parse('$_BASE_URL/get-my-teams');
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode({}))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return GetTeamsResponse.fromJson(json.decode(responseBody));
  }

  Future<GetTeamDetailResponse> getTeamDetails(id) async {
    final uri = Uri.parse('$_BASE_URL/team-details');
    final body = {'team_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetTeamDetailResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> addPlayer({
    String userId = '',
    String teamId = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {'user_id': userId, 'team_id': teamId};
    final uri = Uri.parse('$_BASE_URL/add-team-member');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('response body -------------------$responseData');
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  Future<StatusMessageResponse> acceptRejectTeam(id, status) async {
    final uri = Uri.parse('$_BASE_URL/team-invitation-action');
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final body = {'team_id': id, 'status': status};
    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<GetTeamDetailResponse> getTeamByGame(id) async {
    final uri = Uri.parse('$_BASE_URL/get-team-by-game?game_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return GetTeamDetailResponse.fromJson(json.decode(responseBody));
  }

  Future<GetTeamsResponse> getTournamnetTeams(id) async {
    final uri = Uri.parse('$_BASE_URL/get-tournament-teams?tournament_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetTeamsResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> leaveTeam({String teamId = ''}) async {
    //
    final body = {'team_id': teamId};
    final headers = await _getHeaders();
    final uri = Uri.parse('$_BASE_URL/leave-team');

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> deleteTeamPlayer({
    String teamId = '',
    String userId = '',
  }) async {
    final body = {'team_id': teamId, 'user_id': userId};
    final headers = await _getHeaders();
    final uri = Uri.parse('$_BASE_URL/delete-team-member');

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> deleteTeam({String teamId = ''}) async {
    final body = {'team_id': teamId};
    final headers = await _getHeaders();
    final uri = Uri.parse('$_BASE_URL/delete-team');

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;

    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<GetBlogList> homeBlogDataApi() async {
    final uri = Uri.parse('$_BASE_URL/all-blogs');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return GetBlogList.fromJson(json.decode(responseBody));
  }

  Future<BlogDetailResponse> blogDetailApi({int id = 0}) async {
    final uri = Uri.parse('$_BASE_URL/blog-details?blog_id=$id');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return BlogDetailResponse.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> transferCoins({amount, id}) async {
    final requestData = {
      if (id != null) 'to_userId': id,
      if (amount != null) 'amount': amount,
    };
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/transfer-amount'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<ReviewResponse> getReviewList({id}) async {
    final requestData = {'user_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/get-reviews'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return ReviewResponse.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> addExperience({
    String organizationName = '',
    String startTime = '',
    String endTime = '',
    String role = '',
    String description = '',
    String logo = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final body = {
      if (role.isNotEmpty) 'role': role,
      if (startTime.isNotEmpty) 'start': startTime,
      if (endTime.isNotEmpty) 'end': endTime,
      if (description.isNotEmpty) 'description': description,
      if (organizationName.isNotEmpty) 'org_name': organizationName,
      'present': "0",
    };

    final uri = Uri.parse('$_BASE_URL/add-experience');
    final request = http.MultipartRequest('POST', uri);

    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('org_logo', logo);
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint(responseData);
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  Future<GetExperienceList> experienceList({id}) async {
    final requestData = {if (id != null) 'user_id': id};
    final headers = await _getHeaders();

    final response = await http
        .post(
          Uri.parse('$_BASE_URL/get-experiences'),
          headers: headers,
          body: json.encode(requestData),
        )
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetExperienceList.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> addReview({int id = 0, rating, review}) async {
    final uri = Uri.parse('$_BASE_URL/add-review');
    final body = {'to_user_id': id, 'rating': rating, 'review': review};
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<SettingResponse> siteSettingData() async {
    final uri = Uri.parse('$_BASE_URL/get-site-setting');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return SettingResponse.fromJson(json.decode(responseBody));
  }

  ///////////   Get Magazines //////////

  Future<GetMagazines> magazinesList() async {
    final body = {'limit': 5, 'offset': 0};
    final headers = await _getHeaders();

    final uri = Uri.parse('$_BASE_URL/magazine-list');
    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return GetMagazines.fromJson(json.decode(responseBody));
  }

  Future<IBaseResponse> removeParticipentFromTournament({
    tournamentTd,
    teamTd,
    userId,
  }) async {
    final uri = Uri.parse('$_BASE_URL/delete-tournament-participent');
    final body = {
      'tournament_id': tournamentTd,
      if (userId != 0) 'user_id': userId,
      if (teamTd != 0) 'team_id': teamTd,
    };
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }
  //////MARK ALL NOTIFICATION AS READ

  Future<IBaseResponse> markAllAsRead() async {
    debugPrint("MARKKKKKKKK");

    final uri = Uri.parse('$_BASE_URL/mark-all-as-read');
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode({}))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint("MARKKKKKKKK$responseBody");
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<LoginAuthenticationResponse> connectSocial(token, provider) async {
    final data = {'access_token': token, 'provider': provider};
    final uri = Uri.parse('$_BASE_URL/connect-account');
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode(data))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  ////////////////////   Complete tournament  ///////////////

  Future<IBaseResponse> completeTournamnet({int id = 0}) async {
    try {
      final uri = Uri.parse('$_BASE_URL/complete-tournament');
      final body = {'tournament_id': id};
      final headers = await _getHeaders();

      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeoutDuration);

      final responseBody = response.body;
      if (responseBody.isEmpty) {
        throw Exception('Empty response body');
      }
      return StatusMessageResponse.fromJson(json.decode(responseBody));
    } catch (e) {
      return StatusMessageResponse(
        status: 400,
        message: 'Failed to join tournament: $e',
      );
    }
  }

  Future<IBaseResponse> changePosition({
    int id = 0,
    int userID = 0,
    int position = 0,
  }) async {
    try {
      final uri = Uri.parse('$_BASE_URL/change-position');
      final body = {
        'tournament_id': id,
        "user_id": userID,
        "position": position,
      };
      final headers = await _getHeaders();

      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeoutDuration);

      final responseBody = response.body;
      if (responseBody.isEmpty) {
        throw Exception('Empty response body');
      }
      return StatusMessageResponse.fromJson(json.decode(responseBody));
    } catch (e) {
      return StatusMessageResponse(
        status: 400,
        message: 'Failed to join tournament: $e',
      );
    }
  }

  /////////////////  create Organization   ////////////////////

  Future<CreateOrganizationResponse> createPoll({
    String question = '',
    String options = '',
    String date = '',
    String time = '',
    String orgId = '',
  }) async {
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {
      if (question.isNotEmpty) 'title': question,
      if (time.isNotEmpty) 'org_id': orgId,
      if (date.isNotEmpty) 'date': date,
      if (time.isNotEmpty) 'time': time,
      if (options.isNotEmpty) 'poll_option': options,
    };
    final uri = Uri.parse('$_BASE_URL/create-poll');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return CreateOrganizationResponse.fromJson(json.decode(responseData));
  }

  Future<GetMyPolls> organizationPolls({int id = 0}) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );
    final requestData = {'org_id': id};
    final uri = Uri.parse('$_BASE_URL/get-polls');

    final response = await http
        .post(uri, headers: headers, body: json.encode(requestData))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return GetMyPolls.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> pollVote({
    int pollID = 0,
    int optionID = 0,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    debugPrint(pollID.toString());
    debugPrint(optionID.toString());

    final requestData = {'poll_id': pollID, 'option_id': optionID};

    final uri = Uri.parse('$_BASE_URL/vote-poll');

    final response = await http
        .post(uri, headers: headers, body: json.encode(requestData))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> removeStaff({
    int userid = 0,
    int orgID = 0,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );
    final requestData = {'user_id': userid, 'org_id': orgID};
    final uri = Uri.parse('$_BASE_URL/remove-staff');

    final response = await http
        .post(uri, headers: headers, body: json.encode(requestData))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint(responseBody.toString());
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  /// Edit Profile
  Future<CreateOrganizationResponse> updateOrganization({
    required String id,
    String name = '',
    String type = '',
    String description = '',
    String logo = '',
    String header_image = '',
    String facebook = '',
    String instagram = '',
    String youtube = '',
    String twitch_username = '',
    String discord_invite_link = '',
    String website = '',
  }) async {
    final accessToken = await _sharedPrefHelper.getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final body = {
      'org_id': id,
      if (name.isNotEmpty) 'name': name,
      if (type.isNotEmpty) 'type': type,
      if (description.isNotEmpty) 'description': description,
      if (facebook.isNotEmpty) 'facebook': facebook,
      if (instagram.isNotEmpty) 'instagram': instagram,
      if (youtube.isNotEmpty) 'youtube': youtube,
      if (twitch_username.isNotEmpty) 'twitch_username': twitch_username,
      if (discord_invite_link.isNotEmpty)
        'discord_invite_link': discord_invite_link,
      if (website.isNotEmpty) 'website': website,
    };
    final uri = Uri.parse('$_BASE_URL/update-organization');
    final request = http.MultipartRequest('POST', uri);
    if (logo.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('logo', logo);
      request.files.add(imageFile);
    }
    if (header_image.isNotEmpty) {
      final coverfile = await http.MultipartFile.fromPath(
        'header_image',
        header_image,
      );
      request.files.add(coverfile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    final finalResponse = CreateOrganizationResponse.fromJson(
      json.decode(responseData),
    );
    debugPrint(responseData.toString());
    return finalResponse;
  }

  Future<GetSearchData> getSearchResults(
    String searchText,
    String source,
  ) async {
    final uri = Uri.parse(
      '$_BASE_URL/search?source=$source&search_string=$searchText',
    );
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    return GetSearchData.fromJson(json.decode(responseBody));
  }

  ////////////  sendMessage  //////////
  Future<AllCommentsApiResponse> sendComment({
    String liveStreamId = '0',
    comment,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );
    final body = {
      'livestream_id': liveStreamId.toString(),
      'comment': comment.toString(),
    };
    final uri = Uri.parse('$_BASE_URL/add-comment');
    final response = await http
        .post(uri, headers: headers, body: json.encode(body))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('send comments response ------------$responseBody');
    return AllCommentsApiResponse.fromJson(json.decode(responseBody));
  }

  Future<AllCommentsApiResponse> getAllCommentsByChannelId({
    liveStreamId,
    BuildContext? context,
  }) async {
    final uri = Uri.parse(
      '$_BASE_URL/get-comments?livestream_id=$liveStreamId',
    );
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('responseBody------------$responseBody');
    return AllCommentsApiResponse.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> endStream({String liveStreamId = '0'}) async {
    final uri = Uri.parse('$_BASE_URL/end-livestream');
    final body = {'livestream_id': liveStreamId.toString()};
    final request = http.MultipartRequest('POST', uri);
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    // Add Authorization header only if access token is available
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('responseData------------$responseData');
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  Future<JoinLiveStreamResponse> joinStream({String liveStreamId = '0'}) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );
    final requestData = {'livestream_id': liveStreamId.toString()};
    final uri = Uri.parse('$_BASE_URL/join-livestream');
    final response = await http
        .post(uri, headers: headers, body: json.encode(requestData))
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('responseData join live streamm------------$responseBody');
    return JoinLiveStreamResponse.fromJson(json.decode(responseBody));
  }

  Future<JoinLiveStreamResponse> fetchUserCount({
    String liveStreamId = '0',
    BuildContext? context,
  }) async {
    final headers = await _getHeaders(
      additionalHeaders: {'Content-Type': 'multipart/form-data'},
    );

    final uri = Uri.parse(
      '$_BASE_URL/get-livestream-viewer-count?livestream_id=$liveStreamId',
    );
    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    debugPrint('fetchUserCount live streamm------------$responseBody');
    return JoinLiveStreamResponse.fromJson(json.decode(responseBody));
  }

  Future<StatusMessageResponse> leaveStream({String liveStreamId = '0'}) async {
    final uri = Uri.parse('$_BASE_URL/leave-livestream');
    final body = {'livestream_id': liveStreamId.toString()};
    final request = http.MultipartRequest('POST', uri);
    final accessToken = await SharedPreferenceHelper.instance()
        .getAccessToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    debugPrint('leave live stream ------------$responseData');
    return StatusMessageResponse.fromJson(json.decode(responseData));
  }

  Future<StatusMessageResponse> logout({BuildContext? context}) async {
    final uri = Uri.parse('$_BASE_URL/sign-out');
    final headers = await _getHeaders();

    final response = await http
        .post(uri, headers: headers, body: json.encode({}))
        .timeout(_timeoutDuration);

    await _handleResponse(response, context);
    final responseBody = response.body;
    final jsonResponse = json.decode(responseBody);

    if (jsonResponse['status'] == 200) {
      await SharedPreferenceHelper.instance().clear();
    }

    return StatusMessageResponse.fromJson(jsonResponse);
  }

  Future<LeaderboardResponse> leaderboardApi() async {
    final uri = Uri.parse('$_BASE_URL/leader-board');
    final headers = await _getHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(_timeoutDuration);

    final responseBody = response.body;
    debugPrint('Leaderboard API Response: $responseBody');

    return LeaderboardResponse.fromJson(json.decode(responseBody));
  }
}
