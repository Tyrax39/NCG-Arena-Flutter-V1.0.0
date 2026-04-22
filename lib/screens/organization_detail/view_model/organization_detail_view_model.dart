import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrganizationViewModel extends ChangeNotifier {
  // Singleton instance
  static final OrganizationViewModel _instance =
      OrganizationViewModel._internal();
  factory OrganizationViewModel() => _instance;
  OrganizationViewModel._internal();

  // Services
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper _sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  final SnackbarHelper _snackbarHelper = SnackbarHelper.instance();
  final DialogHelper _dialogHelper = DialogHelper.instance();

  // State variables
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  bool _isTournamentLoading = false;
  bool _isChannelLoading = false;
  bool _isFollowLoading = false;
  List<ChannelModel> _channelData = [];
  List<AllTournaments> _tournamentData = [];
  OrganizationsModel? _organizationData;
  UserDataModel? _userData;

  // Caching flags
  bool _hasLoadedChannels = false;
  bool _hasLoadedTournaments = false;

  // Getters
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  bool get isTournamentLoading => _isTournamentLoading;
  bool get isChannelLoading => _isChannelLoading;
  bool get isFollowLoading => _isFollowLoading;
  List<ChannelModel> get channelData => _channelData;
  List<AllTournaments> get tournamentData => _tournamentData;
  OrganizationsModel? get organizationData => _organizationData;
  UserDataModel? get userData => _userData;
  bool get hasLoadedChannels => _hasLoadedChannels;
  bool get hasLoadedTournaments => _hasLoadedTournaments;

  // Methods
  void resetState() {
    _selectedTabIndex = 0;
    _isLoading = false;
    _isTournamentLoading = false;
    _isChannelLoading = false;
    _isFollowLoading = false;
    _channelData = [];
    _tournamentData = [];
    _organizationData = null;
    _hasLoadedChannels = false;
    _hasLoadedTournaments = false;
    Future.microtask(() {
      notifyListeners();
    });
  }

  Future<void> initializeData(OrganizationsModel organization) async {
    if (organization.id == null) return;
    _organizationData = organization;
    Future.microtask(() {
      notifyListeners();
    });

    await Future.wait([
      getUserFromSharedPref(),
      getOrganizationData(organization.id!),
    ]);

    // Load first tab data immediately (tournaments)
    await getTournamentByOrganization(organization.id.toString());
  }

  Future<void> getUserFromSharedPref() async {
    final user = await _sharedPreferenceHelper.user;
    if (user != null) {
      _userData = user;
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    Future.microtask(() {
      notifyListeners();
    });

    // Load data for the selected tab if not already loaded
    if (_organizationData?.id != null) {
      switch (index) {
        case 0: // Tournaments
          if (!_hasLoadedTournaments) {
            getTournamentByOrganization(_organizationData!.id.toString());
          }
          break;
        case 1: // Channels
          if (!_hasLoadedChannels) {
            getChannelsByOrganization(_organizationData!.id.toString());
          }
          break;
        case 2: // Contacts - no API call needed
          break;
      }
    }
  }

  Future<void> getChannelsByOrganization(String orgId) async {
    if (_hasLoadedChannels) return; // Return if already loaded

    try {
      _isChannelLoading = true;
      Future.microtask(() {
        notifyListeners();
      });

      final response =
          await _sharedWebService.getChannelsByOrganizationId(orgId);
      if (response.status == 200) {
        _channelData = response.channel ?? [];
        _hasLoadedChannels = true;
      }
    } catch (e) {
      debugPrint('Error getting channels: $e');
    } finally {
      _isChannelLoading = false;
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  Future<void> getTournamentByOrganization(String id) async {
    if (_hasLoadedTournaments) return; // Return if already loaded

    _isTournamentLoading = true;
    Future.microtask(() {
      notifyListeners();
    });

    try {
      final response = await _sharedWebService.organizationTournaments(id);
      if (response.status == 200) {
        _tournamentData = response.tournament ?? [];
        _hasLoadedTournaments = true;
      } else {
        _tournamentData = [];
      }
    } catch (e) {
      debugPrint('Error getting tournaments: $e');
      _tournamentData = [];
    } finally {
      _isTournamentLoading = false;
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  Future<void> getOrganizationData(int id) async {
    try {
      final response = await _sharedWebService.getOrganizationById(id: id);
      if (response.status == 200 && response.organization != null) {
        _organizationData = response.organization;
        Future.microtask(() {
          notifyListeners();
        });
      }
    } catch (error) {
      debugPrint('Error getting organization data: $error');
    }
  }

  Future<void> followOrganization(int id, BuildContext context) async {
    // Prevent multiple simultaneous follow/unfollow requests
    if (_isFollowLoading) return;
    
    _isFollowLoading = true;
    Future.microtask(() {
      notifyListeners();
    });

    _dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());

    try {
      final response = await _sharedWebService.followOrganization(id: id);
      _dialogHelper.dismissProgress();

      debugPrint('Follow organization response: ${response.status} - ${response.message}');

      if (response.status == 200 && response.message.isNotEmpty) {
        if (_organizationData != null) {
          // Check for unfollow message (case insensitive)
          if (response.message.toLowerCase().contains('unfollow') || 
              response.message.toLowerCase().contains('un follow')) {
            _organizationData!.isFollowing = 0;
            _organizationData!.followersCount =
                (_organizationData!.followersCount ?? 0) - 1;
            _snackbarHelper
              ..injectContext(context)
              ..showSnackbar(
                snackbarMessage: SnackbarMessage(
                  content: LocaleKeys.organizationUnfollowedSuccessfully.tr(),
                  isLongMessage: false,
                  isForError: false,
                ),
              );
          } 
          // Check for follow message (case insensitive)
          else if (response.message.toLowerCase().contains('follow') || 
                   response.message.toLowerCase().contains('success')) {
            _organizationData!.isFollowing = 1;
            _organizationData!.followersCount =
                (_organizationData!.followersCount ?? 0) + 1;
            _snackbarHelper
              ..injectContext(context)
              ..showSnackbar(
                snackbarMessage: SnackbarMessage(
                  content: LocaleKeys.organizationFollowedSuccessfully.tr(),
                  isLongMessage: false,
                  isForError: false,
                ),
              );
          }
          // If message doesn't match expected patterns, toggle based on current state
          else {
            if (_organizationData!.isFollowing == 1) {
              _organizationData!.isFollowing = 0;
              _organizationData!.followersCount =
                  (_organizationData!.followersCount ?? 0) - 1;
            } else {
              _organizationData!.isFollowing = 1;
              _organizationData!.followersCount =
                  (_organizationData!.followersCount ?? 0) + 1;
            }
            _snackbarHelper
              ..injectContext(context)
              ..showSnackbar(
                snackbarMessage: SnackbarMessage(
                  content: response.message,
                  isLongMessage: false,
                  isForError: false,
                ),
              );
          }
          
          Future.microtask(() {
            notifyListeners();
          });
        }
      } else {
        // Show error message if API call failed
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage(
              content: response.message.isNotEmpty ? response.message : 'Failed to follow/unfollow organization',
              isLongMessage: false,
              isForError: true,
            ),
          );
      }
    } catch (error) {
      _dialogHelper.dismissProgress();
      debugPrint('Error following organization: $error');
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: SnackbarMessage(
            content: 'Failed to follow/unfollow organization. Please try again.',
            isLongMessage: false,
            isForError: true,
          ),
        );
    } finally {
      _isFollowLoading = false;
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  // Method to force refresh data for specific tab
  Future<void> refreshTabData(int tabIndex) async {
    if (_organizationData?.id == null) return;

    switch (tabIndex) {
      case 0: // Tournaments
        _hasLoadedTournaments = false;
        await getTournamentByOrganization(_organizationData!.id.toString());
        break;
      case 1: // Channels
        _hasLoadedChannels = false;
        await getChannelsByOrganization(_organizationData!.id.toString());
        break;
    }
  }
}
