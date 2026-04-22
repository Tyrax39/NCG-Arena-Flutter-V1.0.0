import 'dart:convert';
import 'package:neoncave_arena/backend/site_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/server_response.dart';

SharedPreferences? _sharedPreferences;

@immutable
class SharedPreferenceHelper {
  static const String _USER = 'SharedPreferenceHelper.user';
  static const String _CACHED_USERS = 'SharedPreferenceHelper.cachedUsers';
  static const String _CACHED_ORGANIZATIONS =
      'SharedPreferenceHelper.cachedOrganizations';
  static const String _CACHED_TOURNAMENTS =
      'SharedPreferenceHelper.cachedTournaments';
  static const String _IS_SIGN_UP_PROFILE_COMPLETE =
      'SharedPreferenceHelper.is_sign_up_profile_complete';
  static const String _ACCESS_TOKEN = 'SharedPreferenceHelper.accessToken';

  static const String _CACHED_SEARCH_USERS =
      'SharedPreferenceHelper.cachedSearchUsers';

  static const String _BANNER_VALUE = 'SharedPreferenceHelper.bannerValue';

  static const String _CACHED_SITE_SETTINGS =
      'SharedPreferenceHelper.cachedSiteSettings';

  static SharedPreferenceHelper? _instance;

  const SharedPreferenceHelper._();

  static SharedPreferenceHelper instance() {
    _instance ??= const SharedPreferenceHelper._();
    return _instance!;
  }

  static Future<void> initializeSharedPreferences() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  bool get isUserLoggedIn => _sharedPreferences?.containsKey(_USER) ?? false;

  Future<void> saveBannerValue(int value) async {
    _sharedPreferences?.setInt(_BANNER_VALUE, value);
  }

  Future<int?> getBannerValue() async {
    return _sharedPreferences?.getInt(_BANNER_VALUE);
  }

  Future<UserDataModel?> get user async {
    final userSerialization = _sharedPreferences?.getString(_USER);
    if (userSerialization == null) return null;
    try {
      return UserDataModel.fromJson(json.decode(userSerialization));
    } catch (_) {
      return null;
    }
  }

  Future<void> insertUser(UserDataModel user) async {
    final userSerialization = json.encode(user);
    _sharedPreferences?.setString(_USER, userSerialization);
  }

  set isSignupComplete(bool value) =>
      _sharedPreferences?.setBool(_IS_SIGN_UP_PROFILE_COMPLETE, value);

  bool get isSignupComplete =>
      _sharedPreferences?.getBool(_IS_SIGN_UP_PROFILE_COMPLETE) ?? false;

  // Methods for caching and retrieving users
  Future<List<UserDataModel>?> getCachedUsers() async {
    final jsonString = _sharedPreferences?.getString(_CACHED_USERS);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => UserDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveCachedUsers(List<UserDataModel> users) async {
    final jsonString = json.encode(users);

    _sharedPreferences?.setString(_CACHED_USERS, jsonString);
  }

  // Methods for caching and retrieving organizations
  Future<List<OrganizationsModel>?> getCachedOrganizations() async {
    final jsonString = _sharedPreferences?.getString(_CACHED_ORGANIZATIONS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => OrganizationsModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveCachedOrganizations(
      List<OrganizationsModel> organizations) async {
    final jsonString = json.encode(organizations);
    _sharedPreferences?.setString(_CACHED_ORGANIZATIONS, jsonString);
  }

  // Methods for caching and retrieving tournaments
  Future<List<AllTournaments>?> getCachedTournaments() async {
    final jsonString = _sharedPreferences?.getString(_CACHED_TOURNAMENTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => AllTournaments.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveCachedTournaments(List<AllTournaments> tournaments) async {
    final jsonString = json.encode(tournaments);
    _sharedPreferences?.setString(_CACHED_TOURNAMENTS, jsonString);
  }

  // New method for caching and retrieving search users
  Future<List<SearchUsers>?> getCachedSearchUsers() async {
    final jsonString = _sharedPreferences?.getString(_CACHED_SEARCH_USERS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => SearchUsers.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveCachedSearchUsers(List<SearchUsers> users) async {
    final jsonString = json.encode(users);
    _sharedPreferences?.setString(_CACHED_SEARCH_USERS, jsonString);
  }

  Future<void> saveAccessToken(String accessToken) async {
    _sharedPreferences?.setString(_ACCESS_TOKEN, accessToken);
  }

  Future<String?> getAccessToken() async {
    return _sharedPreferences?.getString(_ACCESS_TOKEN);
  }

  Future<void> saveSiteSettings(SiteSetting settings) async {
    final settingsJson = json.encode(settings.toJson());
    _sharedPreferences?.setString(_CACHED_SITE_SETTINGS, settingsJson);
  }

// Method to retrieve site settings from SharedPreferences
  Future<SiteSetting?> getSiteSettings() async {
    final settingsJson = _sharedPreferences?.getString(_CACHED_SITE_SETTINGS);
    if (settingsJson != null) {
      return SiteSetting.fromJson(json.decode(settingsJson));
    }
    return null;
  }

  Future<void> clear() async => _sharedPreferences?.clear();
}
