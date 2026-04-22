import 'package:flutter/foundation.dart';

class AppEnvironment {
  AppEnvironment._();

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'NEONCAVE_API_BASE_URL',
    defaultValue: String.fromEnvironment('BRACTIX_API_BASE_URL'),
  );
  static const String _webBaseUrlOverride = String.fromEnvironment(
    'NEONCAVE_WEB_BASE_URL',
    defaultValue: String.fromEnvironment('BRACTIX_WEB_BASE_URL'),
  );
  static const String _localPublicPath = 'neoncave-v1.2/public';

  static String get webBaseUrl {
    if (_webBaseUrlOverride.isNotEmpty) {
      return _normalizeBaseUrl(_webBaseUrlOverride);
    }

    if (_apiBaseUrlOverride.isNotEmpty) {
      return _stripApiPath(_apiBaseUrlOverride);
    }

    if (kIsWeb) {
      return 'http://127.0.0.1/$_localPublicPath';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2/$_localPublicPath';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://127.0.0.1/$_localPublicPath';
      default:
        return 'http://127.0.0.1/$_localPublicPath';
    }
  }

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _normalizeBaseUrl(_apiBaseUrlOverride);
    }

    return '$webBaseUrl/api/v1';
  }

  static String _normalizeBaseUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }

    return url;
  }

  static String _stripApiPath(String url) {
    final normalized = _normalizeBaseUrl(url);
    const apiPath = '/api/v1';

    if (normalized.endsWith(apiPath)) {
      return normalized.substring(0, normalized.length - apiPath.length);
    }

    return normalized;
  }
}