import 'package:neoncave_arena/backend/site_setting_model.dart';

abstract class IBaseResponse {
  final int status;
  final String message;
  IBaseResponse(this.status, this.message);
  @override
  String toString() {
    return 'IBaseResponse{status: $status, message: $message}';
  }
}

class StatusMessageResponse extends IBaseResponse {
  StatusMessageResponse({
    required status,
    required String message,
  }) : super(
          status,
          message,
        );
  factory StatusMessageResponse.fromJson(Map<String, dynamic> json) {
    final String statusString =
        json.containsKey('status') ? json['status'].toString() : '404';
    final int status = int.tryParse(statusString) ?? 404;
    final String message = json.containsKey('message') ? json['message'] : '';
    return StatusMessageResponse(status: status, message: message);
  }

  @override
  String toString() {
    return 'StatusMessageResponse: {status: $status, message: $message}';
  }
}

class LoginAuthenticationResponse extends StatusMessageResponse {
  final UserDataModel? user;
  LoginAuthenticationResponse(this.user, status, String message)
      : super(status: status, message: message);
  factory LoginAuthenticationResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson = json.containsKey('data')
        ? json['data']['user'] as Map<String, dynamic>?
        : null;
    return userJson == null
        ? LoginAuthenticationResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : LoginAuthenticationResponse(UserDataModel.fromJson(userJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

class UpdateProfileResponse extends StatusMessageResponse {
  final UserDataModel? user;
  UpdateProfileResponse(this.user, status, String message)
      : super(status: status, message: message);
  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? UpdateProfileResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : UpdateProfileResponse(UserDataModel.fromJson(userJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

class CompanyMembershipModel extends StatusMessageResponse {
  final CompanyMembershipResponse? company;

  CompanyMembershipModel(this.company, status, String message)
      : super(status: status, message: message);

  factory CompanyMembershipModel.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? CompanyMembershipModel(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : CompanyMembershipModel(CompanyMembershipResponse.fromJson(userJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

class BusinessRegisterationModel extends StatusMessageResponse {
  final BusinessRegistrationResponse? business;

  BusinessRegisterationModel(this.business, status, String message)
      : super(status: status, message: message);

  factory BusinessRegisterationModel.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? BusinessRegisterationModel(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : BusinessRegisterationModel(
            BusinessRegistrationResponse.fromJson(userJson),
            statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class AllPostFeedModel extends StatusMessageResponse {
  final List<PortfolioData>? images;
  final List<PortfolioData>? videos;

  AllPostFeedModel({
    this.images,
    this.videos,
    required int super.status,
    required super.message,
  });

  factory AllPostFeedModel.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);

    // Handle new API response structure with data.image and data.videos
    List<PortfolioData> imagesList = [];
    List<PortfolioData> videosList = [];

    if (json['data'] != null) {
      final data = json['data'];
      
      // Parse images array
      if (data['image'] != null && data['image'] is List) {
        for (var item in data['image']) {
          imagesList.add(PortfolioData.fromJson(item));
        }
      }
      
      // Parse videos array
      if (data['videos'] != null && data['videos'] is List) {
        for (var item in data['videos']) {
          videosList.add(PortfolioData.fromJson(item));
        }
      }
    }

    return AllPostFeedModel(
      images: imagesList.isNotEmpty ? imagesList : null,
      videos: videosList.isNotEmpty ? videosList : null,
      status: statusMessageResponse.status,
      message: statusMessageResponse.message,
    );
  }
}

// //

// GETALLCOMMENTSDATAA
class GetAllCommentsData extends StatusMessageResponse {
  final List<CommentsModel>? commentDataList;

  GetAllCommentsData(this.commentDataList, int status, String message)
      : super(status: status, message: message);

  factory GetAllCommentsData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final List<dynamic>? commentsJsonList = json['data'];
    List<CommentsModel>? commentsInfoList;

    if (commentsJsonList != null) {
      commentsInfoList = commentsJsonList
          .map((commentJson) => CommentsModel.fromJson(commentJson))
          .toList();
    }

    return GetAllCommentsData(commentsInfoList, statusMessageResponse.status,
        statusMessageResponse.message);
  }
}
// notification

class NotificationApiResponse extends StatusMessageResponse {
  final List<NotificationModel>? notificationresponse;
  final int? notificationCount;
  NotificationApiResponse(
      this.notificationresponse, this.notificationCount, status, String message)
      : super(status: status, message: message);
  factory NotificationApiResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;

    final count = json.containsKey('notification_count')
        ? json['notification_count'] as int
        : 0;

    List<NotificationModel>? notificationlist;

    if (offerJson != null) {
      notificationlist = (offerJson).map((item) {
        return NotificationModel.fromJson(item);
      }).toList();
    }
    return NotificationApiResponse(notificationlist, count,
        statusMessageResponse.status, statusMessageResponse.message);
  }
}

// //////  REVIEW  LIST ///////////////////

class ReviewResponse extends StatusMessageResponse {
  final RatingResponse? reviewResponse;

  ReviewResponse(this.reviewResponse, status, String message)
      : super(status: status, message: message);

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final reviewJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : null;
    RatingResponse? reviewResponse;

    if (reviewJson != null) {
      reviewResponse = RatingResponse.fromJson(reviewJson);
    }

    return ReviewResponse(
      reviewResponse,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

class CreateOrganizationResponse extends StatusMessageResponse {
  final OrganizationModel? organization;

  CreateOrganizationResponse(this.organization, status, String message)
      : super(status: status, message: message);

  factory CreateOrganizationResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? CreateOrganizationResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : CreateOrganizationResponse(OrganizationModel.fromJson(userJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

class CreateTournamentResponse extends StatusMessageResponse {
  final AllTournaments? tournaments;

  CreateTournamentResponse(this.tournaments, status, String message)
      : super(status: status, message: message);

  factory CreateTournamentResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? CreateTournamentResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : CreateTournamentResponse(AllTournaments.fromJson(userJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

//

class GetMyOrganization extends StatusMessageResponse {
  final List<OrganizationsModel>? organization;

  GetMyOrganization(this.organization, status, String message)
      : super(status: status, message: message);

  factory GetMyOrganization.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;

    List<OrganizationsModel>? organizationList;

    if (organizationJson != null) {
      organizationList = (organizationJson).map((item) {
        return OrganizationsModel.fromJson(item);
      }).toList();
    }
    return organizationJson == null
        ? GetMyOrganization(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetMyOrganization(organizationList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetMyOrganizationData extends StatusMessageResponse {
  final OrganizationsModel? organization;

  GetMyOrganizationData(this.organization, status, String message)
      : super(status: status, message: message);

  factory GetMyOrganizationData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson = json.containsKey('data') ? json['data'] : null;

    // Parse organizationJson directly as a single SearchOrganizations object
    final organization = organizationJson != null
        ? OrganizationsModel.fromJson(organizationJson)
        : null;

    return GetMyOrganizationData(
      organization,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

// ////////////////////////  USER JOINED TOURNAMENTS /////

class GetMyTournament extends StatusMessageResponse {
  final List<AllTournaments>? tournament;
  GetMyTournament(this.tournament, status, String message)
      : super(status: status, message: message);

  factory GetMyTournament.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<AllTournaments>? tournamentList;
    if (organizationJson != null) {
      tournamentList = (organizationJson).map((item) {
        return AllTournaments.fromJson(item);
      }).toList();
    }
    return organizationJson == null
        ? GetMyTournament(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetMyTournament(tournamentList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}


// ////////////////////////  USER JOINED TOURNAMENTS /////

// Leaderboard User Model
class LeaderboardUser {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? userType;
  final String? cover;
  final int? isFollowing;
  final int? followingCount;
  final int? followerCount;
  final int? totalWins;
  final double? totalScore;

  LeaderboardUser({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.image,
    this.userType,
    this.cover,
    this.isFollowing,
    this.followingCount,
    this.followerCount,
    this.totalWins,
    this.totalScore,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      userType: json['user_type'],
      cover: json['cover'],
      isFollowing: json['is_following'],
      followingCount: json['following_count'],
      followerCount: json['follower_count'],
      totalWins: json['total_wins'],
      totalScore: json['total_score']?.toDouble(),
    );
  }
}

// Leaderboard Team Model
class LeaderboardTeam {
  final int? id;
  final String? name;
  final String? logo;
  final int? gameId;
  final int? captain;
  final String? about;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? membersCount;
  final int? totalWins;
  final double? totalScore;

  LeaderboardTeam({
    this.id,
    this.name,
    this.logo,
    this.gameId,
    this.captain,
    this.about,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.membersCount,
    this.totalWins,
    this.totalScore,
  });

  factory LeaderboardTeam.fromJson(Map<String, dynamic> json) {
    return LeaderboardTeam(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      gameId: json['game_id'],
      captain: json['captain'],
      about: json['about'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      membersCount: json['members_count'],
      totalWins: json['total_wins'],
      totalScore: json['total_score']?.toDouble(),
    );
  }
}

// Leaderboard Data Model
class LeaderboardData {
  final List<LeaderboardUser>? users;
  final List<LeaderboardTeam>? teams;

  LeaderboardData({
    this.users,
    this.teams,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    List<LeaderboardUser>? usersList;
    List<LeaderboardTeam>? teamsList;

    if (json['users'] != null) {
      usersList = (json['users'] as List)
          .map((item) => LeaderboardUser.fromJson(item))
          .toList();
    }

    if (json['teams'] != null) {
      teamsList = (json['teams'] as List)
          .map((item) => LeaderboardTeam.fromJson(item))
          .toList();
    }

    return LeaderboardData(
      users: usersList,
      teams: teamsList,
    );
  }
}

// Leaderboard Response Model
class LeaderboardResponse extends StatusMessageResponse {
  final LeaderboardData? data;

  LeaderboardResponse(this.data, status, String message)
      : super(status: status, message: message);

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final dataJson = json.containsKey('data') ? json['data'] : null;
    
    LeaderboardData? leaderboardData;
    if (dataJson != null) {
      leaderboardData = LeaderboardData.fromJson(dataJson);
    }

    return LeaderboardResponse(
      leaderboardData,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

class GetLeaderboard extends StatusMessageResponse {
  final List<AllTournaments>? tournament;
  GetLeaderboard(this.tournament, status, String message)
      : super(status: status, message: message);

  factory GetLeaderboard.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<AllTournaments>? tournamentList;
    if (organizationJson != null) {
      tournamentList = (organizationJson).map((item) {
        return AllTournaments.fromJson(item);
      }).toList();
    }
    return organizationJson == null
          ? GetLeaderboard(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetLeaderboard(tournamentList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}



class GetMyTeam extends StatusMessageResponse {
  final List<MyTeamModel>? team;
  GetMyTeam(this.team, status, String message)
      : super(status: status, message: message);

  factory GetMyTeam.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final teamJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<MyTeamModel>? teamList;
    if (teamJson != null) {
      teamList = (teamJson).map((item) {
        return MyTeamModel.fromJson(item);
      }).toList();
    }
    return teamJson == null
        ? GetMyTeam(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetMyTeam(teamList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetTeamMembers extends StatusMessageResponse {
  final List<Member>? members;
  GetTeamMembers(this.members, status, String message)
      : super(status: status, message: message);

  factory GetTeamMembers.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final teamJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<Member>? members;
    if (teamJson != null) {
      members = (teamJson).map((item) {
        return Member.fromJson(item);
      }).toList();
    }
    return teamJson == null
        ? GetTeamMembers(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetTeamMembers(members, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetFollowedChannels extends StatusMessageResponse {
  final List<ChannelModel>? followedChannels;
  GetFollowedChannels(this.followedChannels, status, String message)
      : super(status: status, message: message);

  factory GetFollowedChannels.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final followedChannelsJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<ChannelModel>? followedChannels;
    if (followedChannelsJson != null) {
      followedChannels = (followedChannelsJson).map((item) {
        return ChannelModel.fromJson(item);
      }).toList();
    }
    return followedChannelsJson == null
        ? GetFollowedChannels(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetFollowedChannels(followedChannels, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetExperienceList extends StatusMessageResponse {
  final List<ExperienceList>? experience;
  GetExperienceList(this.experience, status, String message)
      : super(status: status, message: message);
  factory GetExperienceList.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : [];
    List<ExperienceList>? experiencedata;
    experiencedata = (organizationJson).map((item) {
      return ExperienceList.fromJson(item);
    }).toList();
    return GetExperienceList(experiencedata, statusMessageResponse.status,
        statusMessageResponse.message);
  }
}

// //////////////////////////////////////////
class GetTournamentData extends StatusMessageResponse {
  final AllTournaments? tournament;

  GetTournamentData(this.tournament, status, String message)
      : super(status: status, message: message);

  factory GetTournamentData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final tournamentJson = json.containsKey('data') ? json['data'] : null;

    // Parse tournamentJson directly as a single SearchTournaments object
    final tournament =
        tournamentJson != null ? AllTournaments.fromJson(tournamentJson) : null;

    return GetTournamentData(
      tournament,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

// //////////////////////  get search .//////////////
class GetSearchData extends StatusMessageResponse {
  final List<UserDataModel>? users;
  final List<AllTournaments>? tournaments;
  final List<OrganizationsModel>? organizations;

  GetSearchData(
    this.users,
    this.tournaments,
    this.organizations,
    int status,
    String message,
  ) : super(status: status, message: message);

  factory GetSearchData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);

    final List<dynamic>? usersJsonList = json['data']['users'];
    List<UserDataModel>? usersList;

    if (usersJsonList != null) {
      usersList = usersJsonList
          .map((userJson) => UserDataModel.fromJson(userJson))
          .toList();
    }

    final List<dynamic>? tournamentsJsonList = json['data']['tournaments'];
    List<AllTournaments>? tournamentsList;

    if (tournamentsJsonList != null) {
      tournamentsList = tournamentsJsonList
          .map((tournamentJson) => AllTournaments.fromJson(tournamentJson))
          .toList();
    }

    final List<dynamic>? organizationsJsonList = json['data']['organizations'];
    List<OrganizationsModel>? organizationsList;

    if (organizationsJsonList != null) {
      organizationsList = organizationsJsonList
          .map((organizationJson) =>
              OrganizationsModel.fromJson(organizationJson))
          .toList();
    }

    return GetSearchData(
      usersList,
      tournamentsList,
      organizationsList,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}
////////////////////////////  GET USER DATA /////////////////////

class GetUserDataWithId extends StatusMessageResponse {
  final UserDataModel? userdata;
  GetUserDataWithId(this.userdata, status, String message)
      : super(status: status, message: message);
  factory GetUserDataWithId.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson = json['data'];
    UserDataModel? userdata;
    if (userJson != null) {
      userdata = UserDataModel.fromJson(userJson);
    }
    return GetUserDataWithId(
        userdata, statusMessageResponse.status, statusMessageResponse.message);
  }
}
// ////////////////////////////////////////////

class PrivacyData extends StatusMessageResponse {
  final TermsAndConditions? data;
  PrivacyData(this.data, status, String message)
      : super(status: status, message: message);
  factory PrivacyData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson = json['data'];
    TermsAndConditions? data;
    if (userJson != null) {
      data = TermsAndConditions.fromJson(userJson);
    }
    return PrivacyData(
        data, statusMessageResponse.status, statusMessageResponse.message);
  }
}

// ////////////////////////  create Post ////////////////////////
class CreatePostResponse implements IBaseResponse {
  @override
  final int status;
  @override
  final String message;
  final PortfolioData? data;

  CreatePostResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final dataJson = json['data'] as Map<String, dynamic>?;

    return CreatePostResponse(
      status: statusMessageResponse.status,
      message: statusMessageResponse.message,
      data: dataJson != null ? PortfolioData.fromJson(dataJson) : null,
    );
  }
}

////////////////   GET GAMES ////////////
class GetGamesResponse extends StatusMessageResponse {
  final List<GameModel>? games;
  GetGamesResponse(this.games, status, String message)
      : super(status: status, message: message);
  factory GetGamesResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<GameModel>? gameslist;
    if (organizationJson != null) {
      gameslist = (organizationJson).map((item) {
        return GameModel.fromJson(item);
      }).toList();
    }
    return organizationJson == null
        ? GetGamesResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetGamesResponse(gameslist, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

////////////////   GET CHANNELS ////////////
class GetChannelsResponse extends StatusMessageResponse {
  final List<ChannelModel>? channel;
  GetChannelsResponse(this.channel, status, String message)
      : super(status: status, message: message);
  factory GetChannelsResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final channelJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<ChannelModel>? channelList;
    if (channelJson != null) {
      channelList = (channelJson).map((item) {
        return ChannelModel.fromJson(item);
      }).toList();
    }
    return channelJson == null
        ? GetChannelsResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetChannelsResponse(channelList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetChannelData extends StatusMessageResponse {
  final ChannelModel? channel;

  GetChannelData(this.channel, status, String message)
      : super(status: status, message: message);

  factory GetChannelData.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final channelJson = json.containsKey('data') ? json['data'] : null;

    // Parse organizationJson directly as a single SearchOrganizations object
    final channel =
        channelJson != null ? ChannelModel.fromJson(channelJson) : null;

    return GetChannelData(
      channel,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

class GetLiveStreamsResponse extends StatusMessageResponse {
  final List<LiveStreamData>? liveStreams;

  GetLiveStreamsResponse(this.liveStreams, status, String message)
      : super(status: status, message: message);

  factory GetLiveStreamsResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final liveStreamsJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;

    List<LiveStreamData>? liveStreamsList;
    if (liveStreamsJson != null) {
      liveStreamsList = liveStreamsJson.map((item) {
        return LiveStreamData.fromJson(item);
      }).toList();
    }

    return GetLiveStreamsResponse(
      liveStreamsList,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

class GetLiveStreamToken extends StatusMessageResponse {
  final LiveStreamData? data;

  GetLiveStreamToken(this.data, status, String message)
      : super(status: status, message: message);

  factory GetLiveStreamToken.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final liveStreamData =
        json.containsKey('data') ? LiveStreamData.fromJson(json['data']) : null;

    return GetLiveStreamToken(
      liveStreamData,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

class LiveStreamData {
  final int? id;
  final int? userId;
  final int? channelId;
  final String? agoraChannelName;
  final String? thumbnail;
  final String? title;
  final String? agoraToken;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  LiveStreamData({
    required this.id,
    required this.userId,
    required this.channelId,
    required this.agoraChannelName,
    required this.thumbnail,
    required this.title,
    required this.agoraToken,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory LiveStreamData.fromJson(Map<String, dynamic> json) {
    return LiveStreamData(
      id: json['id'],
      userId: json['user_id'],
      channelId: json['channel_id'],
      agoraChannelName: json['agora_channel_name'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      agoraToken: json['agoratoken'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

//////////////////////   Get Pro Packages   /////////////////
class GetProPackagesResponse extends StatusMessageResponse {
  final List<ProPackage>? packagesData;

  GetProPackagesResponse(this.packagesData, status, String message)
      : super(status: status, message: message);

  factory GetProPackagesResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final packageJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<ProPackage>? packagesList;
    if (packageJson != null) {
      packagesList = (packageJson).map((item) {
        return ProPackage.fromJson(item);
      }).toList();
    }
    return packageJson == null
        ? GetProPackagesResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetProPackagesResponse(packagesList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

//////////////////////   GET SEARCH USERS   /////////////////
class GetSearchUserResponse extends StatusMessageResponse {
  final List<SearchUsers>? searchuserlist;

  GetSearchUserResponse(this.searchuserlist, status, String message)
      : super(status: status, message: message);

  factory GetSearchUserResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final searchJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<SearchUsers>? searchlist;
    if (searchJson != null) {
      searchlist = (searchJson).map((item) {
        return SearchUsers.fromJson(item);
      }).toList();
    }
    return searchJson == null
        ? GetSearchUserResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetSearchUserResponse(searchlist, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

// //////////////////////    get Country  ////////////////////////
class CountryApiResponse extends StatusMessageResponse {
  final List<Country>? countryData;
  CountryApiResponse(this.countryData, status, String message)
      : super(status: status, message: message);
  factory CountryApiResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<Country>? countryList;

    if (offerJson != null) {
      countryList = (offerJson).map((item) {
        return Country.fromJson(item);
      }).toList();
    }
    return CountryApiResponse(countryList, statusMessageResponse.status,
        statusMessageResponse.message);
  }
}

//////////////////  get banners  ////////////////

class BannersApiResponse extends StatusMessageResponse {
  final List<BannersModel>? bannersData;
  BannersApiResponse(this.bannersData, status, String message)
      : super(status: status, message: message);
  factory BannersApiResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<BannersModel>? bannersList;

    if (offerJson != null) {
      bannersList = (offerJson).map((item) {
        return BannersModel.fromJson(item);
      }).toList();
    }
    return BannersApiResponse(bannersList, statusMessageResponse.status,
        statusMessageResponse.message);
  }
}

// ///////////////////////////////////////////////////
class DepositHistoryParse extends StatusMessageResponse {
  final List<DepositHistory>? depositData;
  DepositHistoryParse(this.depositData, status, String message)
      : super(status: status, message: message);
  factory DepositHistoryParse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<DepositHistory>? bannersList;
    if (offerJson != null) {
      bannersList = (offerJson).map((item) {
        return DepositHistory.fromJson(item);
      }).toList();
    }
    return DepositHistoryParse(bannersList, statusMessageResponse.status,
        statusMessageResponse.message);
  }
}

//////////////////////////
///////////////////////////////////////////////////////////////////////
class WithdrawHistoryParse extends StatusMessageResponse {
  final List<WithdrawHistory>? withdrawData;
  WithdrawHistoryParse(this.withdrawData, status, String message)
      : super(status: status, message: message);
  factory WithdrawHistoryParse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<WithdrawHistory>? dataList;
    if (offerJson != null) {
      dataList = (offerJson).map((item) {
        return WithdrawHistory.fromJson(item);
      }).toList();
    }
    return WithdrawHistoryParse(
        dataList, statusMessageResponse.status, statusMessageResponse.message);
  }
}

///////////////////////////////////////////////////////////////////////
class TransactionParse extends StatusMessageResponse {
  final List<TransactionHistory>? transactionData;
  TransactionParse(this.transactionData, status, String message)
      : super(status: status, message: message);
  factory TransactionParse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final offerJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<TransactionHistory>? dataList;
    if (offerJson != null) {
      dataList = (offerJson).map((item) {
        return TransactionHistory.fromJson(item);
      }).toList();
    }
    return TransactionParse(
        dataList, statusMessageResponse.status, statusMessageResponse.message);
  }
}

// ///////////////////////////////////////////////////////////////////
class MatchDataParse extends StatusMessageResponse {
  final MatchData? matchData;

  MatchDataParse(this.matchData, status, String message)
      : super(status: status, message: message);

  factory MatchDataParse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final matchDataJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : null;
    MatchData? data;
    if (matchDataJson != null) {
      data = MatchData.fromJson(matchDataJson);
    }
    return MatchDataParse(
        data, statusMessageResponse.status, statusMessageResponse.message);
  }
}
/////////////////////////////////////////////////////////////////////

class PlanData extends StatusMessageResponse {
  final List<Package>? planData;
  PlanData(this.planData, status, String message)
      : super(status: status, message: message);
  factory PlanData.fromJson(Map<String, dynamic> json) {
    final offerJson =
        json.containsKey('packages') ? json['packages'] as List<dynamic> : null;
    List<Package>? dataList;
    if (offerJson != null) {
      dataList = (offerJson).map((item) {
        return Package.fromJson(item);
      }).toList();
    }
    return PlanData(dataList, 200, "");
  }
}

// //////////////////////////////////////////////////////////////
class GetBalance extends StatusMessageResponse {
  final int? balance;
  GetBalance(this.balance, status, String message)
      : super(status: status, message: message);
  factory GetBalance.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final data = json.containsKey('data') ? json['data'] as int : null;

    return GetBalance(
        data, statusMessageResponse.status, statusMessageResponse.message);
  }
}

/////////////////////////////////////////////////////////////////////////
///
class TermsAndConditions {
  final int id;
  final int type;
  final String pageTitle;
  final String description;

  TermsAndConditions({
    required this.id,
    required this.type,
    required this.pageTitle,
    required this.description,
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
      id: json['id'] as int,
      type: json['type'] as int,
      pageTitle: json['page_title'] as String,
      description: json['description'] as String,
    );
  }
}

// ///////////  GET ALL CHATT /////////////////////\\\

class AllChatApiResponse extends StatusMessageResponse {
  final List<ChatMessage>? chatsData;

  AllChatApiResponse(this.chatsData,
      {required int super.status, required super.message});

  factory AllChatApiResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final dynamic chatData =
        json['data']; // Dynamic type to handle both List and Map
    List<ChatMessage>? bannersList;

    if (chatData != null) {
      if (chatData is List<dynamic>) {
        bannersList = chatData.map((item) {
          return ChatMessage.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else if (chatData is Map<String, dynamic>) {
        // Handle Map case here if needed
        // Example: Parse map data into a single ChatMessage object
        bannersList = [ChatMessage.fromJson(chatData)];
      } else {
        // Handle unexpected type for 'data' field
        print("Unexpected type for 'data': $chatData");
      }
    }

    return AllChatApiResponse(
      bannersList,
      status: statusMessageResponse.status,
      message: statusMessageResponse.message,
    );
  }
}

////////////////   GET TEAMS ////////////
///

class GetTeamsResponse extends StatusMessageResponse {
  final List<MyTeamModel>? teams;
  GetTeamsResponse(this.teams, status, String message)
      : super(status: status, message: message);
  factory GetTeamsResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<MyTeamModel>? teamslist;
    if (organizationJson != null) {
      teamslist = (organizationJson).map((item) {
        return MyTeamModel.fromJson(item);
      }).toList();
    }
    return organizationJson == null
        ? GetTeamsResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetTeamsResponse(teamslist, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

// //////////////// team details  /////////////////

class GetTeamDetailResponse extends StatusMessageResponse {
  final DetailTeam? team;

  GetTeamDetailResponse(this.team, status, String message)
      : super(status: status, message: message);

  factory GetTeamDetailResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final teamJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : null;
    DetailTeam? team;
    if (teamJson != null) {
      team = DetailTeam.fromJson(teamJson);
    }
    return GetTeamDetailResponse(
      team,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

///////////////////  Site Setting /////////////

class SettingResponse extends StatusMessageResponse {
  final SiteSetting? setting;

  SettingResponse(this.setting, status, String message)
      : super(status: status, message: message);

  factory SettingResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final teamJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : null;
    SiteSetting? team;
    if (teamJson != null) {
      team = SiteSetting.fromJson(teamJson);
    }
    return SettingResponse(
      team,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

// ////////////////////////  USER JOINED TOURNAMENTS /////

class GetBlogList extends StatusMessageResponse {
  final List<BlogList>? blogList;
  GetBlogList(this.blogList, status, String message)
      : super(status: status, message: message);

  factory GetBlogList.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final blogJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<BlogList>? blogsData;
    if (blogJson != null) {
      blogsData = (blogJson).map((item) {
        return BlogList.fromJson(item);
      }).toList();
    }
    return blogJson == null
        ? GetBlogList(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetBlogList(blogsData, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

// //////////////// team details  /////////////////

class BlogDetailResponse extends StatusMessageResponse {
  final BlogDetailModel? blog;

  BlogDetailResponse(this.blog, status, String message)
      : super(status: status, message: message);

  factory BlogDetailResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final teamJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : null;
    BlogDetailModel? blogData;
    if (teamJson != null) {
      blogData = BlogDetailModel.fromJson(teamJson);
    }
    return BlogDetailResponse(
      blogData,
      statusMessageResponse.status,
      statusMessageResponse.message,
    );
  }
}

////// Parce Magazines ......

class GetMagazines extends StatusMessageResponse {
  final List<Magazine>? magazines;
  GetMagazines(this.magazines, status, String message)
      : super(status: status, message: message);

  factory GetMagazines.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final organizationJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<Magazine>? magazinesList;
    if (organizationJson != null) {
      magazinesList = (organizationJson).map((item) {
        return Magazine.fromJson(item);
      }).toList();
    }
    return organizationJson == null
        ? GetMagazines(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetMagazines(magazinesList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

class GetMyPolls extends StatusMessageResponse {
  final List<PollModel>? polls;
  GetMyPolls(this.polls, status, String message)
      : super(status: status, message: message);

  factory GetMyPolls.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final pollJson =
        json.containsKey('data') ? json['data'] as List<dynamic> : null;
    List<PollModel>? pollsList;
    if (pollJson != null) {
      pollsList = (pollJson).map((item) {
        return PollModel.fromJson(item);
      }).toList();
    }
    return pollJson == null
        ? GetMyPolls(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : GetMyPolls(pollsList, statusMessageResponse.status,
            statusMessageResponse.message);
  }
}

////////////////////////////////MODELLL/////////////////////////////////////

class Package {
  final int id;
  final String? name;
  final double? price;
  final bool isSubscribed;

  Package({
    required this.id,
    this.name,
    this.price,
    required this.isSubscribed,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toDouble(),
      isSubscribed: json['is_subscribed'],
    );
  }
}

class MatchData {
  int? id;
  int? tournamentId;
  int? round;
  int? groupsMatch;
  int? competitor1;
  int? competitor2;
  int? c1Score;
  int? c2Score;
  int? c1CheckIn;
  int? c2CheckIn;
  int? winnerId;
  int? looserId;
  int? joinStatus;
  int? matchStatus;
  int? scoreUpdatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  TeamData? competitor1Data;
  TeamData? competitor2Data;
  String? tournamentName;
  List<Moderator>? moderators;
  String? endCheckInTime;
  dynamic tournamentOwnerId;

  MatchData({
    this.id,
    this.endCheckInTime,
    this.tournamentId,
    this.round,
    this.groupsMatch,
    this.competitor1,
    this.competitor2,
    this.c1Score,
    this.c2Score,
    this.c1CheckIn,
    this.c2CheckIn,
    this.winnerId,
    this.looserId,
    this.joinStatus,
    this.matchStatus,
    this.scoreUpdatedBy,
    this.createdAt,
    this.updatedAt,
    this.competitor1Data,
    this.competitor2Data,
    this.tournamentName,
    this.moderators,
    this.tournamentOwnerId,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        endCheckInTime: json['end_checkin_time'],
        id: json['id'],
        tournamentId: json['tournament_id'],
        round: json['round'],
        groupsMatch: json['groups_match'],
        competitor1: json['competitor_1'],
        competitor2: json['competitor_2'],
        c1Score: json['c1_score'],
        c2Score: json['c2_score'],
        c1CheckIn: json['c1_check_in'],
        c2CheckIn: json['c2_check_in'],
        winnerId: json['winnerId'],
        looserId: json['looserId'],
        joinStatus: json['join_status'],
        matchStatus: json['match_status'],
        scoreUpdatedBy: json['score_updated_by'],
        tournamentOwnerId: json['tournament_owner_id'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        competitor1Data: json['competetor_1'] != null
            ? TeamData.fromJson(json['competetor_1'])
            : null,
        competitor2Data: json['competetor_2'] != null
            ? TeamData.fromJson(json['competetor_2'])
            : null,
        tournamentName: json['tournament_name'],
        moderators: json['moderators'] != null
            ? List<Moderator>.from(
                json['moderators'].map((x) => Moderator.fromJson(x)))
            : [],
      );
}

class TeamData {
  int? id;
  String? name;
  String? logo;
  int? gameId;
  int? captain;
  String? about;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  TeamData({
    this.id,
    this.name,
    this.logo,
    this.gameId,
    this.captain,
    this.about,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) => TeamData(
        id: json['id'],
        // Prefer 'name', fallback to 'username' if 'name' is null or empty
        name: (json['name'] != null && json['name'].toString().isNotEmpty)
            ? json['name']
            : (json['username'] ?? ''),
        // Prefer 'logo', fallback to 'image' if 'logo' is null or empty
        logo: (json['logo'] != null && json['logo'].toString().isNotEmpty)
            ? json['logo']
            : (json['image'] ?? ''),
        gameId: json['game_id'],
        captain: json['captain'],
        about: json['about'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
      );
}

class Competitor {
  int? id;
  String? username;
  String? profileImage;
  String? gender;
  String? name;
  int? level;
  String? userType;
  String? logo;

  Competitor({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
    this.logo,
  });

  factory Competitor.fromJson(Map<String, dynamic> json) => Competitor(
        id: json['id'],
        username: json['username'],
        profileImage: json['profile_image'],
        gender: json['gender'],
        name: json['name'],
        level: json['level'],
        userType: json['user_type'],
        logo: json['logo'],
      );
}

class Moderator {
  int? id;
  String? username;
  String? profileImage;
  String? gender;
  String? name;
  int? level;
  String? userType;
  String? role;

  Moderator({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
    this.role,
  });

  factory Moderator.fromJson(Map<String, dynamic> json) => Moderator(
        id: json['id'],
        username: json['username'],
        profileImage: json['profile_image'],
        gender: json['gender'],
        name: json['name'],
        level: json['level'],
        userType: json['user_type'],
        role: json['role'],
      );
}

// /////////////////////////////       COUNTRY DATA  ///////////////////////////////

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////

class TransactionHistory {
  int id;
  int userId;
  String? flag;
  double? amount;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  TransactionHistory({
    this.id = 0,
    this.userId = 0,
    this.flag,
    this.amount,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        flag: json['flag'],
        amount: json['amount']?.toDouble(),
        description: json['description'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'flag': flag,
        'amount': amount,
        'description': description,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

// ///////////////////////////////////////////////////

class WithdrawHistory {
  int? id;
  String? type;
  String? fullName;
  String? paypalEmail;
  int? userId;
  String? iban;
  String? country;
  String? swiftCode;
  double? amount;
  String? status;
  String? address;
  double? deduction;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  WithdrawHistory({
    this.id,
    this.type,
    this.fullName,
    this.paypalEmail,
    this.userId,
    this.iban,
    this.country,
    this.swiftCode,
    this.amount,
    this.status,
    this.address,
    this.deduction,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory WithdrawHistory.fromJson(Map<String, dynamic> json) =>
      WithdrawHistory(
        id: json['id'] ?? 0,
        type: json['type'] ?? "",
        fullName: json['full_name'] ?? "",
        paypalEmail: json['paypal_email'] ?? "",
        userId: json['user_id'] ?? 0,
        iban: json['iban'] ?? "",
        country: json['country'] ?? "",
        swiftCode: json['swift_code'] ?? "",
        amount:
            json['amount'] != null ? (json['amount'] as num).toDouble() : 0.0,
        status: json['status'] ?? "",
        address: json['address'] ?? "",
        deduction: json['deduction'] != null
            ? (json['deduction'] as num).toDouble()
            : 0.0,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'full_name': fullName,
        'paypal_email': paypalEmail,
        'user_id': userId,
        'iban': iban,
        'country': country,
        'swift_code': swiftCode,
        'amount': amount,
        'status': status,
        'address': address,
        'deduction': deduction,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };
}

// ///////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////// PORTFOLIO MODEL /////////////////

class PortfolioData {
  final dynamic id;
  final dynamic userId;
  final dynamic mediaType;
  final dynamic media;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt; // It might be null or DateTime
  final dynamic title;
  final dynamic description;
  final dynamic link;
  final dynamic thumbnail;

  PortfolioData({
    required this.id,
    required this.userId,
    required this.mediaType,
    this.thumbnail,
    required this.media,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.title,
    required this.description,
    required this.link,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      mediaType: json['media_type'] ?? 0,
      media: json['media'],
      thumbnail: json['thumbnail'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'] ?? "",
      title: json['title'],
      description: json['description'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_type': mediaType,
      'media': media,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'title': title,
      'description': description,
      'link': link,
      'thumbnail': thumbnail,
    };
  }
}

// /////////////////////////////////User DATA RESPONSE  MODEL  //////////////////////
class UserDataModel {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? about;
  final int? followingCount;
  final int? followerCount;
  final int? postCount;
  final int? orgFollowerCount;
  final String? deviceId;
  final String? deviceModel;
  final String? phone;
  final String? profileImage;
  final DateTime? emailVerifiedAt;
  final String? cover;
  final String? gender;
  final int? isDummy;
  final String? dateOfBirth;
  final String? level;
  final String? userType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? notifyJoinTournament;
  final int? notifyFollowChannel;
  final int? notifyFollowUser;
  final int? notifyFollowOrganization;
  final int? isFollowing;
  final int? is_profile_complete;
  final int? is_email_verified;
  UserDataModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.about,
    this.followingCount,
    this.followerCount,
    this.postCount,
    this.orgFollowerCount,
    this.deviceId,
    this.deviceModel,
    this.phone,
    this.profileImage,
    this.emailVerifiedAt,
    this.cover,
    this.gender,
    this.isDummy,
    this.dateOfBirth,
    this.level,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.notifyJoinTournament,
    this.notifyFollowChannel,
    this.notifyFollowUser,
    this.notifyFollowOrganization,
    this.isFollowing,
    this.is_profile_complete,
    this.is_email_verified,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      about: json['about'],
      followingCount: json['following_count'] ?? 0,
      followerCount: json['follower_count'] ?? 0,
      postCount: json['post_count'] ?? 0,
      orgFollowerCount: json['org_follower_count'] ?? 0,
      deviceId: json['device_id'],
      deviceModel: json['device_model'],
      phone: json['phone'],
      profileImage: json['image'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      cover: json['cover'],
      gender: json['gender'],
      isDummy: json['is_dummy'],
      dateOfBirth: json['dob'],
      level: json['level']?.toString(),
      userType: json['user_type']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      notifyJoinTournament: json['notify_join_tournament'],
      notifyFollowChannel: json['notify_follow_channel'],
      notifyFollowUser: json['notify_follow_user'],
      notifyFollowOrganization: json['notify_follow_organization'],
      isFollowing: json['is_following'],
      is_profile_complete: json['is_profile_complete'],
      is_email_verified: json['is_email_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'about': about,
      'following_count': followingCount,
      'follower_count': followerCount,
      'post_count': postCount,
      'org_follower_count': orgFollowerCount,
      'device_id': deviceId,
      'device_model': deviceModel,
      'phone': phone,
      'image': profileImage,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'cover': cover,
      'gender': gender,
      'is_dummy': isDummy,
      'dob': dateOfBirth,
      'level': level,
      'user_type': userType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'notify_join_tournament': notifyJoinTournament,
      'notify_follow_channel': notifyFollowChannel,
      'notify_follow_user': notifyFollowUser,
      'notify_follow_organization': notifyFollowOrganization,
      'is_following': isFollowing,
      'is_profile_complete': is_profile_complete,
      'is_email_verified': is_email_verified,
    };
  }

  UserDataModel copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? about,
    int? followingCount,
    int? followerCount,
    int? postCount,
    int? orgFollowerCount,
    String? deviceId,
    String? deviceModel,
    String? phone,
    String? profileImage,
    DateTime? emailVerifiedAt,
    String? cover,
    String? gender,
    int? isDummy,
    String? dateOfBirth,
    String? level,
    String? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? notifyJoinTournament,
    int? notifyFollowChannel,
    int? notifyFollowUser,
    int? notifyFollowOrganization,
    int? is_profile_complete,
    int? is_email_verified,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      is_email_verified: is_email_verified ?? this.is_email_verified,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      about: about ?? this.about,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      postCount: postCount ?? this.postCount,
      orgFollowerCount: orgFollowerCount ?? this.orgFollowerCount,
      deviceId: deviceId ?? this.deviceId,
      deviceModel: deviceModel ?? this.deviceModel,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      cover: cover ?? this.cover,
      gender: gender ?? this.gender,
      isDummy: isDummy ?? this.isDummy,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      level: level ?? this.level,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notifyJoinTournament: notifyJoinTournament ?? this.notifyJoinTournament,
      notifyFollowChannel: notifyFollowChannel ?? this.notifyFollowChannel,
      notifyFollowUser: notifyFollowUser ?? this.notifyFollowUser,
      notifyFollowOrganization:
          notifyFollowOrganization ?? this.notifyFollowOrganization,
      is_profile_complete: is_profile_complete ?? this.is_profile_complete,
    );
  }
}

class OnBoard {
  final title, description;

  OnBoard({
    required this.title,
    required this.description,
  });
}

// OnBoarding content list
// final List<OnBoard> onboardingData = [
//   OnBoard(title: AppStrings.TILE1, description: AppStrings.TILE1_DESC),
//   OnBoard(title: AppStrings.TILE2, description: AppStrings.TILE2_DESC),
//   OnBoard(title: AppStrings.TILE3, description: AppStrings.TILE3_DESC)
// ];

class BusinessRegistrationResponse {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String description;

  BusinessRegistrationResponse(
      {required this.id,
      required this.name,
      required this.mobileNumber,
      required this.email,
      required this.description});

  factory BusinessRegistrationResponse.fromJson(Map<String, dynamic> json) {
    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String name = json.containsKey('name') ? json['name'] ?? '' : '';
    final String mobileNumber =
        json.containsKey('mobileNumber') ? json['mobileNumber'] : '';
    final String email = json.containsKey('email') ? json['email'] ?? '' : '';
    final String description =
        json.containsKey('description') ? json['description'] ?? '' : '';

    return BusinessRegistrationResponse(
        id: id,
        name: name,
        mobileNumber: mobileNumber,
        email: email,
        description: description);
  }

  BusinessRegistrationResponse copyWith(
          {String? name,
          String? mobileNumber,
          String? email,
          String? description}) =>
      BusinessRegistrationResponse(
          id: id,
          name: name ?? this.name,
          mobileNumber: mobileNumber ?? this.mobileNumber,
          email: email ?? this.email,
          description: description ?? this.description);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        'description': description,
      };
}

class CompanyMembershipResponse {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String description;

  CompanyMembershipResponse(
      {required this.id,
      required this.name,
      required this.mobileNumber,
      required this.email,
      required this.description});

  factory CompanyMembershipResponse.fromJson(Map<String, dynamic> json) {
    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String name = json.containsKey('name') ? json['name'] ?? '' : '';
    final String mobileNumber =
        json.containsKey('mobileNumber') ? json['mobileNumber'] : '';
    final String email = json.containsKey('email') ? json['email'] ?? '' : '';
    final String description =
        json.containsKey('description') ? json['description'] ?? '' : '';

    return CompanyMembershipResponse(
        id: id,
        name: name,
        mobileNumber: mobileNumber,
        email: email,
        description: description);
  }

  CompanyMembershipResponse copyWith(
          {String? name,
          String? mobileNumber,
          String? email,
          String? description}) =>
      CompanyMembershipResponse(
          id: id,
          name: name ?? this.name,
          mobileNumber: mobileNumber ?? this.mobileNumber,
          email: email ?? this.email,
          description: description ?? this.description);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        'description': description,
      };
}

class PlaceResponse {
  final String id;
  final String name;
  final String address;
  final String numberOfPeople;
  final List<String> imagePath;
  final List<HoursResponse> hours;
  final bool isFavourite;
  final bool isWifi;
  final bool isCharging;
  final bool isLaptopStand;
  final String description;

  PlaceResponse(
      {required this.id,
      required this.name,
      required this.numberOfPeople,
      required this.address,
      required this.imagePath,
      required this.hours,
      required this.isFavourite,
      required this.isWifi,
      required this.isCharging,
      required this.isLaptopStand,
      required this.description});

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String name = json.containsKey('name') ? json['name'] ?? '' : '';
    final String numberOfPeople =
        json.containsKey('numberOfPeople') ? json['numberOfPeople'] : '';
    final String address =
        json.containsKey('address') ? json['address'] ?? '' : '';
    final List<String> imagePath =
        json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String description =
        json.containsKey('description') ? json['description'] ?? '' : '';
    final bool isFavourite =
        json.containsKey('isFavourite') ? json['isFavourite'] : false;
    final bool isWifi = json.containsKey('isWifi') ? json['isWifi'] : false;
    final bool isCharging =
        json.containsKey('isCharging') ? json['isCharging'] : false;
    final bool isLaptopStand =
        json.containsKey('isLaptopStand') ? json['isLaptopStand'] : false;
    final List<HoursResponse> hours = json.containsKey('hours')
        ? ((json['hours'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .map((e) => HoursResponse.fromJson(e))
            .toList())
        : <HoursResponse>[];

    return PlaceResponse(
        id: id,
        name: name,
        numberOfPeople: numberOfPeople,
        address: address,
        imagePath: imagePath,
        hours: hours,
        isFavourite: isFavourite,
        isWifi: isWifi,
        isCharging: isCharging,
        isLaptopStand: isLaptopStand,
        description: description);
  }

  PlaceResponse copyWith(
          {String? name,
          String? numberOfPeople,
          String? address,
          bool? isFavourite,
          bool? isCharging,
          bool? isWifi,
          bool? isLaptopStand,
          List<String>? imagePath,
          List<HoursResponse>? hours,
          String? description}) =>
      PlaceResponse(
          id: id,
          name: name ?? this.name,
          numberOfPeople: numberOfPeople ?? this.numberOfPeople,
          address: address ?? this.address,
          isFavourite: isFavourite ?? this.isFavourite,
          isWifi: isWifi ?? this.isWifi,
          isCharging: isCharging ?? this.isCharging,
          isLaptopStand: isLaptopStand ?? this.isLaptopStand,
          imagePath: imagePath ?? this.imagePath,
          hours: hours ?? this.hours,
          description: description ?? this.description);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'numberOfPeople': numberOfPeople,
        'address': address,
        'imagePath': imagePath,
        'hours': hours,
        'isFavourite': isFavourite,
        'isWifi': isWifi,
        'isCharging': isCharging,
        'isLaptopStand': isLaptopStand,
        'description': description
      };
}

class HoursResponse {
  final String id;
  final String name;
  final String time;

  HoursResponse({
    required this.id,
    required this.name,
    required this.time,
  });

  factory HoursResponse.fromJson(Map<String, dynamic> json) {
    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String name = json.containsKey('name') ? json['name'] ?? '' : '';
    final String time = json.containsKey('time') ? json['time'] ?? '' : '';

    return HoursResponse(id: id, name: name, time: time);
  }

  HoursResponse copyWith({String? name, String? time}) =>
      HoursResponse(id: id, name: name ?? this.name, time: time ?? this.time);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'time': time};
}

// //////  Review Response   //////////////////////////////////

// //////////////////////////////////////////////////////////////////////////////////
class NotificationModel {
  final int? id;
  final int? fromUserId;
  final int? toUserId;
  final int? postId;
  final int? organizationId;
  final int? tournamentId;
  final String? text;
  final int? isRead;
  final String? notificationType;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt; // May be null
  final NotifierModel? notifier;
  final dynamic matchId;
  final dynamic teamId;

  NotificationModel({
    this.teamId,
    this.id,
    this.matchId,
    this.fromUserId,
    this.toUserId,
    this.postId,
    this.organizationId,
    this.tournamentId,
    this.text,
    this.isRead,
    this.notificationType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.notifier,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      matchId: json['match_id'],
      teamId: json['team_id'],
      id: json['id'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
      postId: json['post_id'],
      organizationId: json['organization_id'],
      tournamentId: json['tournament_id'],
      text: json['text'],
      isRead: json['is_read'],
      notificationType: json['notification_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      notifier: json['notifier'] != null
          ? NotifierModel.fromJson(json['notifier'])
          : null,
    );
  }
}

class NotifierModel {
  final int? id;
  final String? username;
  final String? profileImage;
  final String? gender;
  final String? name;
  final int? level;
  final String? userType;

  NotifierModel({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
  });

  factory NotifierModel.fromJson(Map<String, dynamic> json) {
    return NotifierModel(
      id: json['id'],
      username: json['username'],
      profileImage: json['image'],
      gender: json['gender'],
      name: json['name'],
      level: json['level'],
      userType: json['user_type'],
    );
  }
}

///////////////////////   GET ALL POST MODEL   //////////////////////////////////

class PostModel {
  int? id;
  int? userId;
  String? postText;
  dynamic height;
  dynamic width;
  dynamic postFile;
  dynamic postFileName;
  dynamic postFileThumb;
  String? postPrivacy;
  dynamic postType;
  String? postFeeling;
  String? postListening;
  String? postTraveling;
  String? postWatching;
  String? postPlaying;
  dynamic postPhoto;
  dynamic time;
  int? multiImage;
  int? multiImagePost;
  int? videoViews;
  int? sharedFrom;
  int? commentsStatus;
  int? active;
  int? isFeatured;
  int? imageOrVideo;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? commentsCount;
  int? likeCount;
  bool? isPostLiked;
  Postmedia? postmedia;
  Userdata? userdata;

  PostModel({
    this.id,
    this.userId,
    this.postText,
    this.height,
    this.width,
    this.postFile,
    this.postFileName,
    this.postFileThumb,
    this.postPrivacy,
    this.postType,
    this.postFeeling,
    this.postListening,
    this.postTraveling,
    this.postWatching,
    this.postPlaying,
    this.postPhoto,
    this.time,
    this.multiImage,
    this.multiImagePost,
    this.videoViews,
    this.sharedFrom,
    this.commentsStatus,
    this.active,
    this.isFeatured,
    this.imageOrVideo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.commentsCount,
    this.likeCount,
    this.isPostLiked,
    this.postmedia,
    this.userdata,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      postText: json['postText'],
      height: json['height'],
      width: json['width'],
      postFile: json['postFile'],
      postFileName: json['postFileName'],
      postFileThumb: json['postFileThumb'],
      postPrivacy: json['postPrivacy'],
      postType: json['postType'],
      postFeeling: json['postFeeling'],
      postListening: json['postListening'],
      postTraveling: json['postTraveling'],
      postWatching: json['postWatching'],
      postPlaying: json['postPlaying'],
      postPhoto: json['postPhoto'],
      time: json['time'],
      multiImage: json['multiImage'],
      multiImagePost: json['multiImagePost'],
      videoViews: json['videoViews'],
      sharedFrom: json['sharedFrom'],
      commentsStatus: json['commentsStatus'],
      active: json['active'],
      isFeatured: json['isFeatured'],
      imageOrVideo: json['imageOrVideo'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'],
      commentsCount: json['comments_count'],
      likeCount: json['like_count'],
      isPostLiked: json['is_post_liked'],
      postmedia: json['postmedia'] != null
          ? Postmedia.fromJson(json['postmedia'])
          : null,
      userdata:
          json['userdata'] != null ? Userdata.fromJson(json['userdata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postText': postText,
      'height': height,
      'width': width,
      'postFile': postFile,
      'postFileName': postFileName,
      'postFileThumb': postFileThumb,
      'postPrivacy': postPrivacy,
      'postType': postType,
      'postFeeling': postFeeling,
      'postListening': postListening,
      'postTraveling': postTraveling,
      'postWatching': postWatching,
      'postPlaying': postPlaying,
      'postPhoto': postPhoto,
      'time': time,
      'multiImage': multiImage,
      'multiImagePost': multiImagePost,
      'videoViews': videoViews,
      'sharedFrom': sharedFrom,
      'commentsStatus': commentsStatus,
      'active': active,
      'isFeatured': isFeatured,
      'imageOrVideo': imageOrVideo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
      'comments_count': commentsCount,
      'like_count': likeCount,
      'is_post_liked': isPostLiked,
      'postmedia': postmedia?.toJson(),
      'userdata': userdata?.toJson(),
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? postText,
    dynamic height,
    dynamic width,
    dynamic postFile,
    dynamic postFileName,
    dynamic postFileThumb,
    String? postPrivacy,
    dynamic postType,
    String? postFeeling,
    String? postListening,
    String? postTraveling,
    String? postWatching,
    String? postPlaying,
    dynamic postPhoto,
    String? time,
    int? multiImage,
    int? multiImagePost,
    int? videoViews,
    int? sharedFrom,
    int? commentsStatus,
    int? active,
    int? isFeatured,
    int? imageOrVideo,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    int? commentsCount,
    int? likeCount,
    bool? isPostLiked,
    Postmedia? postmedia,
    Userdata? userdata,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      postText: postText ?? this.postText,
      height: height ?? this.height,
      width: width ?? this.width,
      postFile: postFile ?? this.postFile,
      postFileName: postFileName ?? this.postFileName,
      postFileThumb: postFileThumb ?? this.postFileThumb,
      postPrivacy: postPrivacy ?? this.postPrivacy,
      postType: postType ?? this.postType,
      postFeeling: postFeeling ?? this.postFeeling,
      postListening: postListening ?? this.postListening,
      postTraveling: postTraveling ?? this.postTraveling,
      postWatching: postWatching ?? this.postWatching,
      postPlaying: postPlaying ?? this.postPlaying,
      postPhoto: postPhoto ?? this.postPhoto,
      time: time ?? this.time,
      multiImage: multiImage ?? this.multiImage,
      multiImagePost: multiImagePost ?? this.multiImagePost,
      videoViews: videoViews ?? this.videoViews,
      sharedFrom: sharedFrom ?? this.sharedFrom,
      commentsStatus: commentsStatus ?? this.commentsStatus,
      active: active ?? this.active,
      isFeatured: isFeatured ?? this.isFeatured,
      imageOrVideo: imageOrVideo ?? this.imageOrVideo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commentsCount: commentsCount ?? this.commentsCount,
      likeCount: likeCount ?? this.likeCount,
      isPostLiked: isPostLiked ?? this.isPostLiked,
      postmedia: postmedia ?? this.postmedia,
      userdata: userdata ?? this.userdata,
    );
  }
}

class Postmedia {
  int? id;
  int? postId;
  int? imageOrVideo;
  String? media;
  DateTime? createdAt;
  DateTime? updatedAt;

  Postmedia({
    this.id,
    this.postId,
    this.imageOrVideo,
    this.media,
    this.createdAt,
    this.updatedAt,
  });

  factory Postmedia.fromJson(Map<String, dynamic> json) {
    return Postmedia(
      id: json['id'],
      postId: json['postId'],
      imageOrVideo: json['image_or_video'],
      media: json['media'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'image_or_video': imageOrVideo,
      'media': media,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Postmedia copyWith({
    int? id,
    int? postId,
    int? imageOrVideo,
    String? media,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Postmedia(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      imageOrVideo: imageOrVideo ?? this.imageOrVideo,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Userdata {
  int? id;
  String? username;
  String? profileImage;
  dynamic gender;
  String? name;
  int? level;

  Userdata({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      id: json['id'],
      username: json['username'],
      profileImage: json['profile_image'],
      gender: json['gender'],
      name: json['name'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
      'gender': gender,
      'name': name,
      'level': level,
    };
  }

  Userdata copyWith({
    int? id,
    String? username,
    String? profileImage,
    dynamic gender,
    String? name,
    int? level,
  }) {
    return Userdata(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }
}

// //////////////////   GET ALL COMMENTS MODEL //////////////////////////////////

class CommentsModel {
  int? id;
  int? userId;
  int? postId;
  String? comment;
  int? likeCount;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Userdata? userdata;

  CommentsModel({
    this.id,
    this.userId,
    this.postId,
    this.comment,
    this.likeCount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userdata,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      id: json['id'],
      userId: json['userId'],
      postId: json['postId'],
      comment: json['comment'],
      likeCount: json['likeCount'],
      deletedAt: json['deletedAt'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      userdata:
          json['userdata'] != null ? Userdata.fromJson(json['userdata']) : null,
    );
  }

  CommentsModel copyWith({
    int? id,
    int? userId,
    int? postId,
    String? comment,
    int? likeCount,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Userdata? userdata,
  }) =>
      CommentsModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        comment: comment ?? this.comment,
        likeCount: likeCount ?? this.likeCount,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userdata: userdata ?? this.userdata,
      );
}

class OrganizationModel {
  dynamic name;
  dynamic type;
  dynamic description;
  dynamic discordInviteLink;
  dynamic twitchUsername;
  dynamic email;
  dynamic website;
  dynamic facebook;
  dynamic youtube;
  dynamic instagram;
  dynamic smashcast;
  dynamic createdBy;
  dynamic logo;
  dynamic headerImage;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  OrganizationModel({
    this.name,
    this.type,
    this.description,
    this.discordInviteLink,
    this.twitchUsername,
    this.email,
    this.website,
    this.facebook,
    this.youtube,
    this.instagram,
    this.smashcast,
    this.createdBy,
    this.logo,
    this.headerImage,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      name: json['name'],
      type: json['type'],
      description: json['description'],
      discordInviteLink: json['discord_invite_link'],
      twitchUsername: json['twitch_username'],
      email: json['email'],
      website: json['website'],
      facebook: json['facebook'],
      youtube: json['youtube'],
      instagram: json['instagram'],
      smashcast: json['smashcast'],
      createdBy: json['created_by'],
      logo: json['logo'],
      headerImage: json['header_image'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }
}

class SearchUsers {
  int? id;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? firstName;
  String? lastName;
  String? username;
  String? mobile;
  int? mblUnverified;
  String? gender;
  DateTime? dateOfBirth;
  String? cover;
  int? status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  dynamic deletedAt;
  String? pubgId;
  int? referralId;
  int? joinMoney;
  int? walletBalance;
  String? memberPackageUpgraded;
  String? playerId;
  int? countryId;
  String? countryCode;
  String? verifyCode;
  String? userTemplate;
  String? fbId;
  String? loginVia;
  String? newUser;
  String? profileImage;
  dynamic budyList;
  String? pushNoti;
  String? entryFrom;
  String? ludoUsername;
  int? active;
  dynamic timezone;
  int? level;
  String? userType;
  int? position;

  SearchUsers({
    this.userType,
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.username,
    this.mobile,
    this.mblUnverified,
    this.gender,
    this.dateOfBirth,
    this.cover,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.deletedAt,
    this.pubgId,
    this.referralId,
    this.joinMoney,
    this.walletBalance,
    this.memberPackageUpgraded,
    this.playerId,
    this.countryId,
    this.countryCode,
    this.verifyCode,
    this.userTemplate,
    this.fbId,
    this.loginVia,
    this.newUser,
    this.profileImage,
    this.budyList,
    this.pushNoti,
    this.entryFrom,
    this.ludoUsername,
    this.active,
    this.timezone,
    this.level,
    this.position,
  });
  factory SearchUsers.fromJson(Map<String, dynamic> json) {
    return SearchUsers(
      userType: json['user_type'] ?? "",
      position: json['position'] ?? 0,
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      mobile: json['mobile'],
      mblUnverified: json['mbl_unverified'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      cover: json['cover'],
      status: json['status'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      deletedAt: json['deleted_at'],
      pubgId: json['pubg_id'],
      referralId: json['referral_id'],
      joinMoney: json['join_money'],
      walletBalance: json['wallet_balance'],
      memberPackageUpgraded: json['member_package_upgraded'],
      playerId: json['player_id'],
      countryId: json['country_id'],
      countryCode: json['country_code'],
      verifyCode: json['verify_code'],
      userTemplate: json['user_template'],
      fbId: json['fb_id'],
      loginVia: json['login_via'],
      newUser: json['new_user'],
      profileImage: json['image'],
      budyList: json['budy_list'],
      pushNoti: json['push_noti'],
      entryFrom: json['entry_from'],
      ludoUsername: json['ludo_username'],
      active: json['active'],
      timezone: json['timezone'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType,
      'position': position,
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'mobile': mobile,
      'mbl_unverified': mblUnverified,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'cover': cover,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'deleted_at': deletedAt,
      'pubg_id': pubgId,
      'referral_id': referralId,
      'join_money': joinMoney,
      'wallet_balance': walletBalance,
      'member_package_upgraded': memberPackageUpgraded,
      'player_id': playerId,
      'country_id': countryId,
      'country_code': countryCode,
      'verify_code': verifyCode,
      'user_template': userTemplate,
      'fb_id': fbId,
      'login_via': loginVia,
      'new_user': newUser,
      'image': profileImage,
      'budy_list': budyList,
      'push_noti': pushNoti,
      'entry_from': entryFrom,
      'ludo_username': ludoUsername,
      'active': active,
      'timezone': timezone,
      'level': level,
    };
  }

  SearchUsers copyWith({
    String? userType,
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstName,
    String? lastName,
    String? username,
    String? mobile,
    int? mblUnverified,
    String? gender,
    DateTime? dateOfBirth,
    String? cover,
    int? status,
    dynamic createdBy,
    dynamic updatedBy,
    dynamic deletedBy,
    dynamic deletedAt,
    String? pubgId,
    int? referralId,
    int? joinMoney,
    int? walletBalance,
    String? memberPackageUpgraded,
    String? playerId,
    int? countryId,
    String? countryCode,
    String? verifyCode,
    String? userTemplate,
    String? fbId,
    String? loginVia,
    String? newUser,
    String? profileImage,
    dynamic budyList,
    String? pushNoti,
    String? entryFrom,
    String? ludoUsername,
    int? active,
    dynamic timezone,
    int? level,
    int? position,
  }) =>
      SearchUsers(
        userType: userType ?? this.userType,
        position: position ?? this.position,
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        mobile: mobile ?? this.mobile,
        mblUnverified: mblUnverified ?? this.mblUnverified,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        cover: cover ?? this.cover,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedBy: deletedBy ?? this.deletedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        pubgId: pubgId ?? this.pubgId,
        referralId: referralId ?? this.referralId,
        joinMoney: joinMoney ?? this.joinMoney,
        walletBalance: walletBalance ?? this.walletBalance,
        memberPackageUpgraded:
            memberPackageUpgraded ?? this.memberPackageUpgraded,
        playerId: playerId ?? this.playerId,
        countryId: countryId ?? this.countryId,
        countryCode: countryCode ?? this.countryCode,
        verifyCode: verifyCode ?? this.verifyCode,
        userTemplate: userTemplate ?? this.userTemplate,
        fbId: fbId ?? this.fbId,
        loginVia: loginVia ?? this.loginVia,
        newUser: newUser ?? this.newUser,
        profileImage: profileImage ?? this.profileImage,
        budyList: budyList ?? this.budyList,
        pushNoti: pushNoti ?? this.pushNoti,
        entryFrom: entryFrom ?? this.entryFrom,
        ludoUsername: ludoUsername ?? this.ludoUsername,
        active: active ?? this.active,
        timezone: timezone ?? this.timezone,
        level: level ?? this.level,
      );
}

class AllTournaments {
  int? id;
  int? userId;
  String? name;
  String? slug;
  DateTime? dateIni;
  DateTime? dateFin;
  DateTime? registerDateLimit;
  int? sport;
  dynamic promoter;
  String? hostOrganization;
  dynamic technicalAssistance;
  int? ruleId;
  int? type;
  dynamic venueId;
  dynamic levelId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic gameId;
  dynamic orgId;
  dynamic description;
  String? startTime;
  String? startDatetime;
  String? banner;
  dynamic contact;
  String? criticalRules;
  String? rules;
  dynamic regionId;
  String? checkInTime;
  dynamic scoreReporting;
  dynamic registrationParticipantLimit;
  dynamic format;
  dynamic bracketFormat;
  dynamic isReward;
  dynamic totalReward;
  dynamic first;
  dynamic second;
  dynamic third;
  dynamic regFee;
  dynamic reportWinnerOnly;
  String? registrationRegions;
  String? contactOption;
  String? contactValue;
  dynamic checkIn;
  dynamic requiredScreenshot;
  String? status;
  dynamic publish;
  dynamic updatedBy;
  dynamic deletedBy;
  dynamic round;
  dynamic noOfGroup;
  dynamic inFinal;
  dynamic winnerUser;
  dynamic isJoined;
  Region? region;
  dynamic gameName;
  Organization? organization;
  dynamic schedule;
  dynamic isStart;
  List? moderators;
  String? tournamentStatus;
  dynamic seedingType;

  AllTournaments({
    this.moderators,
    this.seedingType,
    this.isStart,
    this.gameName,
    this.schedule,
    this.id,
    this.userId,
    this.startDatetime,
    this.name,
    this.slug,
    this.dateIni,
    this.dateFin,
    this.registerDateLimit,
    this.sport,
    this.promoter,
    this.hostOrganization,
    this.technicalAssistance,
    this.ruleId,
    this.type,
    this.venueId,
    this.levelId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.gameId,
    this.orgId,
    this.description,
    this.startTime,
    this.banner,
    this.contact,
    this.criticalRules,
    this.rules,
    this.regionId,
    this.checkInTime,
    this.scoreReporting,
    this.registrationParticipantLimit,
    this.format,
    this.bracketFormat,
    this.isReward,
    this.totalReward,
    this.first,
    this.second,
    this.third,
    this.regFee,
    this.reportWinnerOnly,
    this.registrationRegions,
    this.contactOption,
    this.contactValue,
    this.checkIn,
    this.requiredScreenshot,
    this.status,
    this.publish,
    this.updatedBy,
    this.deletedBy,
    this.round,
    this.noOfGroup,
    this.inFinal,
    this.winnerUser,
    this.isJoined,
    this.region,
    this.organization,
    this.tournamentStatus,
  });
  factory AllTournaments.fromJson(Map<String, dynamic> json) {
    return AllTournaments(
      seedingType: json['seeding_type'],
      startDatetime: json['start_datetime'],
      moderators: json['org_moderators'],
      isStart: json['is_start'],
      schedule: json['schedule'],
      gameName: json['game_name'],
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      slug: json['slug'],
      dateIni: json['dateIni'] != null ? DateTime.parse(json['dateIni']) : null,
      dateFin: json['dateFin'] != null ? DateTime.parse(json['dateFin']) : null,
      registerDateLimit: json['registerDateLimit'] != null
          ? DateTime.parse(json['registerDateLimit'])
          : null,
      sport: json['sport'],
      promoter: json['promoter'],
      hostOrganization: json['host_organization'],
      technicalAssistance: json['technical_assistance'],
      ruleId: json['rule_id'],
      type: json['type'],
      venueId: json['venue_id'],
      levelId: json['level_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'],
      gameId: json['game_id'],
      orgId: json['org_id'],
      description: json['description'],
      startTime: json['start_time'],
      banner: json['banner'],
      contact: json['contact'],
      criticalRules: json['critical_rules'],
      rules: json['rules'],
      regionId: json['region_id'],
      checkInTime: json['check_in_time'],
      scoreReporting: json['score_reporting'],
      registrationParticipantLimit: json['registration_participant_limit'],
      format: json['format'],
      bracketFormat: json['bracket_format'],
      isReward: json['is_reward'],
      totalReward: json['total_reward'],
      first: json['first_prize'],
      second: json['second_prize'],
      third: json['third'],
      regFee: json['reg_fee'],
      reportWinnerOnly: json['report_winner_only'],
      registrationRegions: json['registration_regions'],
      contactOption: json['contact_option'],
      contactValue: json['contact_value'],
      checkIn: json['check_in'],
      requiredScreenshot: json['required_screenshot'],
      status: json['status'],
      publish: json['publish'],
      updatedBy: json['updated_by'] ?? "",
      deletedBy: json['deleted_by'] ?? "",
      round: json['round'],
      noOfGroup: json['no_of_group'],
      inFinal: json['in_final'],
      winnerUser: json['winner_user'] ?? "",
      isJoined: json['is_joined'] ?? "",
      tournamentStatus: json['tournament_status'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'seeding_type': seedingType ?? "",
        'org_moderators': moderators ?? [],
        'start_datetime': startDatetime ?? "",
        "is_start": isStart ?? 0,
        "schedule": schedule ?? "",
        "game_name": gameName,
        "id": id,
        "user_id": userId,
        "name": name,
        "slug": slug,
        "dateIni": dateIni?.toIso8601String(),
        "dateFin": dateFin?.toIso8601String(),
        "registerDateLimit": registerDateLimit?.toIso8601String(),
        "sport": sport,
        "promoter": promoter,
        "host_organization": hostOrganization,
        "technical_assistance": technicalAssistance,
        "rule_id": ruleId,
        "type": type,
        "venue_id": venueId,
        "level_id": levelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "game_id": gameId,
        "org_id": orgId,
        "description": description,
        "start_time": startTime,
        "banner": banner,
        "contact": contact,
        "critical_rules": criticalRules,
        "rules": rules,
        "region_id": regionId,
        "check_in_time": checkInTime,
        "score_reporting": scoreReporting,
        "registration_participant_limit": registrationParticipantLimit,
        "format": format,
        "bracket_format": bracketFormat,
        "is_reward": isReward,
        "total_reward": totalReward,
        "first_prize": first,
        "second_prize": second,
        "third": third,
        "reg_fee": regFee,
        "report_winner_only": reportWinnerOnly,
        "registration_regions": registrationRegions,
        "contact_option": contactOption,
        "contact_value": contactValue,
        "check_in": checkIn,
        "required_screenshot": requiredScreenshot,
        "status": status,
        "publish": publish,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
        "round": round,
        "no_of_group": noOfGroup,
        "in_final": inFinal,
        "winner_user": winnerUser,
        "is_joined": isJoined,
        "region": region?.toMap(),
        "organization": organization?.toMap(),
        "tournament_status": tournamentStatus,
      };
}

class Organization {
  Organization(
      {this.id,
      this.name,
      this.description,
      this.email,
      this.logo,
      this.followersCount});

  int? id;
  String? name;
  String? description;
  String? email;
  String? logo;
  dynamic followersCount;

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json["id"],
      followersCount: json['followers_count'],
      name: json["name"],
      description: json["description"],
      email: json["email"],
      logo: json["logo"],
    );
  }

  Map<String, dynamic> toMap() => {
        "followers_count": followersCount,
        "id": id,
        "name": name,
        "description": description,
        "email": email,
        "logo": logo,
      };
}

class Region {
  Region({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class OrganizationsModel {
  int? id;
  String? name;
  int? type;
  String? logo;
  String? description;
  String? headerImage;
  String? discordInviteLink;
  String? twitchUsername;
  String? email;
  String? website;
  String? facebook;
  String? youtube;
  String? instagram;
  String? smashcast;
  int? staffCount;
  int? followersCount;
  int? createdBy;
  int? updatedBy;
  dynamic deletedAt;
  dynamic deletedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isFollowing;
  int? isVerified;
  UserData? userdata;
  List<UserData>? staff;
  int? isOwner;

  OrganizationsModel({
    this.staff,
    this.isFollowing,
    this.isOwner,
    this.id,
    this.name,
    this.type,
    this.logo,
    this.description,
    this.headerImage,
    this.discordInviteLink,
    this.twitchUsername,
    this.email,
    this.website,
    this.facebook,
    this.youtube,
    this.instagram,
    this.smashcast,
    this.staffCount,
    this.followersCount,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.userdata,
    this.createdAt,
    this.updatedAt,
    this.isVerified,
  });

  factory OrganizationsModel.fromJson(Map<String, dynamic> json) {
    return OrganizationsModel(
      id: json['id'],
      isOwner: json['is_owner'],
      isFollowing: json['is_following'],
      isVerified: json['is_verified'],
      name: json['name'],
      type: json['type'],
      logo: json['logo'],
      description: json['description'],
      headerImage: json['header_image'],
      discordInviteLink: json['discord_invite_link'],
      twitchUsername: json['twitch_username'],
      email: json['email'],
      website: json['website'],
      facebook: json['facebook'],
      youtube: json['youtube'],
      instagram: json['instagram'],
      smashcast: json['smashcast'],
      staffCount: json['staffCount'],
      followersCount: json['followers_count'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'],
      deletedBy: json['deleted_by'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      userdata:
          json['userdata'] != null ? UserData.fromJson(json['userdata']) : null,
      staff: json['staff'] != null
          ? (json['staff'] as List).map((e) => UserData.fromJson(e)).toList()
          : null,
    );
  }

  OrganizationsModel copyWith({
    List<UserData>? staff,
    int? isFollowing,
    int? isOwner,
    UserData? userdata,
    int? id,
    String? name,
    int? type,
    String? logo,
    String? description,
    String? headerImage,
    dynamic discordInviteLink,
    String? twitchUsername,
    String? email,
    String? website,
    String? facebook,
    String? youtube,
    String? instagram,
    String? smashcast,
    int? staffCount,
    int? followersCount,
    int? createdBy,
    int? updatedBy,
    dynamic deletedAt,
    dynamic deletedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      OrganizationsModel(
        userdata: userdata ?? this.userdata,
        isOwner: isOwner ?? this.isOwner,
        id: id ?? this.id,
        isFollowing: isFollowing ?? this.isFollowing,
        name: name ?? this.name,
        type: type ?? this.type,
        logo: logo ?? this.logo,
        description: description ?? this.description,
        headerImage: headerImage ?? this.headerImage,
        discordInviteLink: discordInviteLink ?? this.discordInviteLink,
        twitchUsername: twitchUsername ?? this.twitchUsername,
        email: email ?? this.email,
        website: website ?? this.website,
        facebook: facebook ?? this.facebook,
        youtube: youtube ?? this.youtube,
        instagram: instagram ?? this.instagram,
        smashcast: smashcast ?? this.smashcast,
        staffCount: staffCount ?? this.staffCount,
        followersCount: followersCount ?? this.followersCount,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        deletedBy: deletedBy ?? this.deletedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        staff: staff ?? this.staff,
      );
}

class UserData {
  int? id;
  String? username;
  String? profileImage;
  String? gender;
  String? name;
  int? level;
  String? userType;

  UserData({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      profileImage: json['profile_image'],
      gender: json['gender'],
      name: json['name'],
      level: json['level'],
      userType: json['user_type'],
    );
  }
}

class GameModel {
  int? id;
  String? gameName;
  String? packageName;
  String? gameImage;
  String? gameRules;
  String? status;
  String? gameType;
  int? follower;
  String? idPrefix;
  String? gameLogo;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  GameModel({
    this.id,
    this.gameName,
    this.packageName,
    this.gameImage,
    this.gameRules,
    this.status,
    this.gameType,
    this.follower,
    this.idPrefix,
    this.gameLogo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? 0,
      gameName: json['game_name'] ?? '',
      packageName: json['package_name'] ?? '',
      gameImage: json['game_image'] ?? '',
      gameRules: json['game_rules'] ?? '',
      status: json['status'] ?? '',
      gameType: json['game_type'] ?? "",
      follower: json['follower'] ?? "",
      idPrefix: json['id_prefix'] ?? "",
      gameLogo: json['game_logo'] ?? "",
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : DateTime.now(),
    );
  }
}

class ChannelModel {
  int? id;
  int? orgId;
  int? userId;
  String? name;
  String? logo;
  String? header;
  String? description;
  int? followerCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int? subscribed;

  ChannelModel({
    this.id,
    this.orgId,
    this.userId,
    this.name,
    this.logo,
    this.header,
    this.description,
    this.followerCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subscribed,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      orgId: json['org_id'],
      userId: json['user_id'],
      name: json['name'],
      logo: json['logo'],
      header: json['header'],
      description: json['description'],
      followerCount: json['follower_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      subscribed: json['subscribed'],
    );
  }
}

class ProPackage {
  final int? id;
  final String? packageName;
  final double? packagePrice;
  final String? time;
  final int? monthYearSwitch;
  final double? yearPrice;
  final int? portfolioMedia;
  final int? tournamentLimit;
  final int? liveStream;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? isSubscribed;

  ProPackage({
    this.id,
    this.packageName,
    this.packagePrice,
    this.time,
    this.monthYearSwitch,
    this.yearPrice,
    this.portfolioMedia,
    this.tournamentLimit,
    this.liveStream,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSubscribed,
  });

  factory ProPackage.fromJson(Map<String, dynamic> json) {
    return ProPackage(
      id: json['id'],
      packageName: json['package_name'] ?? "",
      packagePrice: (json['package_price'] as num?)?.toDouble(),
      time: json['time'],
      monthYearSwitch: json['month_year_switch'],
      yearPrice: (json['year_price'] as num?)?.toDouble(),
      portfolioMedia: json['portfolio_media'],
      tournamentLimit: json['tournament_limit'],
      liveStream: json['live_stream'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      isSubscribed: json['is_subscribed'],
    );
  }
}

// ALL BANNERS
class BannersModel {
  int? id;
  String? image;
  String? video;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  BannersModel({
    this.id,
    this.image,
    this.video,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    return BannersModel(
      id: json['id'] as int,
      image: json['image'] ?? "",
      video: json['video'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'video': video,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class ChatMessage {
  dynamic time;
  int? id;
  int? toId;
  int? fromId;
  int? tournamentId;
  String? message;
  int? type;
  String? media;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? myMessage;
  User? user;

  ChatMessage({
    this.id,
    this.toId,
    this.fromId,
    this.tournamentId,
    this.message,
    this.type,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.myMessage,
    this.user,
    this.time,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      time: json['created_time'],
      toId: json['to_id'],
      fromId: json['from_id'],
      tournamentId: json['tournament_id'],
      message: json['message'],
      type: json['type'],
      media: json['media'] ?? "",
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'],
      myMessage: json['my_message'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  int? id;
  String? username;
  String? profileImage;
  String? gender;
  String? name;
  int? level;
  String? userType;

  User({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profileImage: json['image'],
      gender: json['gender'],
      name: json['name'],
      level: json['level'],
      userType: json['user_type'],
    );
  }
}

class DepositHistory {
  int? id;
  int? userId;
  int? withdrawMethodId;
  dynamic amount;
  String? currency;
  String? charge;
  String? rate;
  String? finalAmount;
  dynamic detail;
  dynamic btcAmo;
  dynamic btcWallet;
  dynamic trx;
  String? depositStatus;
  dynamic adminFeedback;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? withdrawMethod;

  DepositHistory({
    this.id,
    this.userId,
    this.withdrawMethodId,
    this.amount,
    this.currency,
    this.charge,
    this.rate,
    this.finalAmount,
    this.detail,
    this.btcAmo,
    this.btcWallet,
    this.trx,
    this.depositStatus,
    this.adminFeedback,
    this.createdAt,
    this.updatedAt,
    this.withdrawMethod,
  });

  factory DepositHistory.fromJson(Map<String, dynamic> json) {
    return DepositHistory(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      withdrawMethodId: json['withdraw_method_id'] as int?,
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      charge: json['charge'] as String?,
      rate: json['rate'] as String?,
      finalAmount: json['final_amo'] as String?,
      detail: json['detail'],
      btcAmo: json['btc_amo'],
      btcWallet: json['btc_wallet'],
      trx: json['trx'],
      depositStatus: json['deposit_status'] as String?,
      adminFeedback: json['admin_feedback'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      withdrawMethod: json['withdraw_method'] as String?,
    );
  }
}

class Game {
  final int? id;
  final String? gameName;
  final String? gameImage;

  Game({
    this.id,
    this.gameName,
    this.gameImage,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gameName: json['game_name'],
      gameImage: json['game_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_name': gameName,
      'game_image': gameImage,
    };
  }
}

class MyTeamModel {
  int? id;
  String? name;
  String? logo;
  int? gameId;
  int? captain;
  String? about;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Game? game;
  int? members;

  MyTeamModel({
    this.id,
    this.name,
    this.logo,
    this.gameId,
    this.captain,
    this.about,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.game,
    this.members,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) {
    return MyTeamModel(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
      gameId: json["game_id"],
      captain: json["captain"],
      about: json["about"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
      members: json["team_members"],
      game: json["game"] != null ? Game.fromJson(json["game"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "logo": logo,
      "game_id": gameId,
      "captain": captain,
      "about": about,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "game": game?.toJson(),
      "members": members,
    };
  }
}

class DetailTeam {
  final int? id;
  final String? name;
  final String? about;
  final String? logo;
  final int? gameId;
  final int? captain;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Game? game;
  final List<Member>? members;
  final Member? captainInfo;
  final int? createdBy;

  DetailTeam(
      {this.id,
      this.name,
      this.logo,
      this.gameId,
      this.captain,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.game,
      this.members,
      this.captainInfo,
      this.createdBy,
      this.about});

  DetailTeam copyWith({
    int? id,
    String? name,
    String? logo,
    String? about,
    int? gameId,
    int? captain,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    Game? game,
    List<Member>? members,
    Member? captainInfo,
    int? createdBy,
  }) {
    return DetailTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      gameId: gameId ?? this.gameId,
      captain: captain ?? this.captain,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      game: game ?? this.game,
      members: members ?? this.members,
      captainInfo: captainInfo ?? this.captainInfo,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory DetailTeam.fromJson(Map<String, dynamic> json) {
    return DetailTeam(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      about: json['about'],
      gameId: json['game_id'],
      captain: json['captain'],
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      game: json['game'] != null ? Game.fromJson(json['game']) : null,
      captainInfo: json['captain_info'] != null
          ? Member.fromJson(json['captain_info'])
          : null,
      members: json['members'] != null
          ? (json['members'] as List).map((i) => Member.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'about': about,
      'logo': logo,
      'game_id': gameId,
      'captain': captain,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'game': game?.toJson(),
      'members': members?.map((i) => i.toJson()).toList(),
    };
  }
}

class Member {
  final int? id;
  final String? username;
  final String? profileImage;
  final String? gender;
  final String? name;
  final int? level;
  final String? userType;
  final int? captain;

  Member({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
    this.captain,
  });

  Member copyWith({
    int? id,
    String? username,
    String? profileImage,
    String? gender,
    String? name,
    int? level,
    String? userType,
    int? captain,
  }) {
    return Member(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      level: level ?? this.level,
      userType: userType ?? this.userType,
      captain: captain ?? this.captain,
    );
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      username: json['username'],
      profileImage: json['image'],
      gender: json['gender'],
      name: json['name'],
      level: json['level'],
      userType: json['user_type'],
      captain: json['captain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
      'gender': gender,
      'name': name,
      'level': level,
      'user_type': userType,
      'captain': captain,
    };
  }
}

class BlogList {
  final int? id;
  final String? title;
  final String? link; // Nullable field
  final String? category;
  final String? image;
  final String? metaTitle;
  final String? createdAt;

  BlogList(
      {this.id,
      this.title,
      this.link,
      this.category,
      this.image,
      this.metaTitle,
      this.createdAt});

  // Factory constructor to create an instance from JSON
  factory BlogList.fromJson(Map<String, dynamic> json) {
    return BlogList(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      link: json['link'] ?? "",
      category: json['category'] ?? "",
      image: json['image'] ?? "",
      metaTitle: json['meta_title'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'category': category,
      'image': image,
      'meta_title': metaTitle,
      'created_at': createdAt
    };
  }
}

class BlogDetailModel {
  int? id;
  String? title;
  String? category;
  String? metaTitle;
  String? metaDescription;
  String? link;
  String? description;
  String? image;
  int? isFeatured;
  int? status;
  String? publishedAt;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deletedAt;

  BlogDetailModel({
    this.id,
    this.title,
    this.category,
    this.metaTitle,
    this.metaDescription,
    this.link,
    this.description,
    this.image,
    this.isFeatured,
    this.status,
    this.publishedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) {
    return BlogDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      category: json['category'] ?? "",
      metaTitle: json['meta_title'] ?? "",
      metaDescription: json['meta_description'] ?? "",
      link: json['link'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      isFeatured: json['is_featured'] ?? 0,
      status: json['status'] ?? 0,
      publishedAt: json['published_at'] ?? "",
      createdBy: json['created_by'] ?? "",
      updatedBy: json['updated_by'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'link': link,
      'description': description,
      'image': image,
      'is_featured': isFeatured,
      'status': status,
      'published_at': publishedAt,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String(),
      'deleted_at': deletedAt,
    };
  }
}

class RatingResponse {
  final List<Rating>? ratings;
  final CalculateRatings? calculateRatings;

  RatingResponse({this.ratings, this.calculateRatings});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((item) => Rating.fromJson(item as Map<String, dynamic>))
          .toList(),
      calculateRatings: json['calculate_ratings'] != null
          ? CalculateRatings.fromJson(json['calculate_ratings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratings': ratings?.map((item) => item.toJson()).toList(),
      'calculate_ratings': calculateRatings?.toJson(),
    };
  }
}

class Rating {
  final int? id;
  final int? fromUserId;
  final int? toUserId;
  final int? rating;
  final String? review;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final ProfileData? userData;

  Rating({
    this.id,
    this.fromUserId,
    this.toUserId,
    this.rating,
    this.review,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userData,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as int?,
      fromUserId: json['from_user_id'] as int?,
      toUserId: json['to_user_id'] as int?,
      rating: json['rating'] as int?,
      review: json['review'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      userData: json['user_data'] != null
          ? ProfileData.fromJson(json['user_data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'rating': rating,
      'review': review,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user_data': userData?.toJson(),
    };
  }
}

class ProfileData {
  final int? id;
  final String? username;
  final String? profileImage;
  final String? gender;
  final String? name;
  final int? level;
  final String? userType;
  final String? cover;

  ProfileData({
    this.id,
    this.username,
    this.profileImage,
    this.gender,
    this.name,
    this.level,
    this.userType,
    this.cover,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as int?,
      username: json['username'] as String?,
      profileImage: json['profile_image'] as String?,
      gender: json['gender'] as String?,
      name: json['name'] as String?,
      level: json['level'] as int?,
      userType: json['user_type'] as String?,
      cover: json['cover'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
      'gender': gender,
      'name': name,
      'level': level,
      'user_type': userType,
      'cover': cover,
    };
  }
}

class CalculateRatings {
  final double? total;
  final int? countTotalUser;

  CalculateRatings({this.total, this.countTotalUser});

  factory CalculateRatings.fromJson(Map<String, dynamic> json) {
    return CalculateRatings(
      total: (json['total'] as num?)?.toDouble(),
      countTotalUser: json['count_total_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'count_total_user': countTotalUser,
    };
  }
}

class ExperienceList {
  int? id;
  int? userId;
  String? role;
  String? orgName;
  String? duration;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? orgLogo;

  ExperienceList({
    this.id,
    this.userId,
    this.role,
    this.orgName,
    this.duration,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.orgLogo,
  });

  // Factory constructor to create a ExperienceList object from JSON
  factory ExperienceList.fromJson(Map<String, dynamic> json) {
    return ExperienceList(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      role: json['role'] as String?,
      orgName: json['org_name'] as String?,
      duration: json['duration'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      orgLogo: json['org_logo'] as String?,
    );
  }

  // Method to convert a ExperienceList object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role': role,
      'org_name': orgName,
      'duration': duration,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'org_logo': orgLogo,
    };
  }

  // copyWith method to create a copy of the current ExperienceList with optional new values
  ExperienceList copyWith({
    int? id,
    int? userId,
    String? role,
    String? orgName,
    String? duration,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? orgLogo,
  }) {
    return ExperienceList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      orgName: orgName ?? this.orgName,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      orgLogo: orgLogo ?? this.orgLogo,
    );
  }
}

class Magazine {
  int? id;
  String? title;
  String? description;
  String? magazineCover;
  String? magazineFile;
  int? viewsCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Magazine({
    this.id,
    this.title,
    this.description,
    this.magazineCover,
    this.magazineFile,
    this.viewsCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      magazineCover: json['magazine_cover'],
      magazineFile: json['magazine_file'],
      viewsCount: json['views_count'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'magazine_cover': magazineCover,
      'magazine_file': magazineFile,
      'views_count': viewsCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class PollModel {
  int? id;
  int? orgId;
  String? title;
  bool? isActive;
  DateTime? lastDatetime;
  int? createdBy;
  int? voteCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  List<Option>? options;
  int? totalVotes;
  bool? isVoted;
  int? userVoteId;

  PollModel({
    this.id,
    this.orgId,
    this.title,
    this.isActive,
    this.lastDatetime,
    this.createdBy,
    this.voteCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
    this.totalVotes,
    this.isVoted,
    this.userVoteId,
  });

  // Method to create a Poll object from JSON data
  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json['id'],
      orgId: json['org_id'],
      title: json['title'],
      isActive: json['is_active'] == 1,
      lastDatetime: json['last_datetime'] != null
          ? DateTime.parse(json['last_datetime'])
          : null,
      createdBy: json['created_by'],
      voteCount: json['vote_count'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      options: json['options'] != null
          ? (json['options'] as List).map((e) => Option.fromJson(e)).toList()
          : null,
      totalVotes: json['total_votes'],
      isVoted: json['is_voted'] == 1,
      userVoteId: json['user_vote_id'],
    );
  }

  // Method to convert a Poll object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'title': title,
      'is_active': isActive == true ? 1 : 0,
      'last_datetime': lastDatetime?.toIso8601String(),
      'created_by': createdBy,
      'vote_count': voteCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'options': options?.map((e) => e.toJson()).toList(),
      'total_votes': totalVotes,
      'is_voted': isVoted == true ? 1 : 0,
      'user_vote_id': userVoteId,
    };
  }
}

class Option {
  int? id;
  int? pollId;
  String? optionText;
  int? noOfVotes;

  Option({
    this.id,
    this.pollId,
    this.optionText,
    this.noOfVotes,
  });

  // Method to create an Option object from JSON data
  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      pollId: json['poll_id'],
      optionText: json['option_text'],
      noOfVotes: json['no_of_votes'],
    );
  }

  // Method to convert an Option object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poll_id': pollId,
      'option_text': optionText,
      'no_of_votes': noOfVotes,
    };
  }
}

class Comments {
  int? id;
  int? userId;
  int? livestreamId;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  Comments({
    this.id,
    this.userId,
    this.livestreamId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      userId: json['user_id'],
      livestreamId: json['livestream_id'],
      comment: json['comment'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class AllCommentsApiResponse extends StatusMessageResponse {
  final List<Comments>? commentsData;

  AllCommentsApiResponse(this.commentsData,
      {required int super.status, required super.message});

  factory AllCommentsApiResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final dynamic chatData =
        json['data']; // Dynamic type to handle both List and Map
    List<Comments>? bannersList;
    if (chatData != null) {
      if (chatData is List<dynamic>) {
        bannersList = chatData.map((item) {
          return Comments.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else if (chatData is Map<String, dynamic>) {
        // Handle Map case here if needed
        // Example: Parse map data into a single ChatMessage object
        bannersList = [Comments.fromJson(chatData)];
      } else {
        // Handle unexpected type for 'data' field
        print("Unexpected type for 'data': $chatData");
      }
    }
    return AllCommentsApiResponse(
      bannersList,
      status: statusMessageResponse.status,
      message: statusMessageResponse.message,
    );
  }
}

class JoinLiveStreamResponse extends StatusMessageResponse {
  final int? userCounts;
  JoinLiveStreamResponse(this.userCounts, status, String message)
      : super(status: status, message: message);
  factory JoinLiveStreamResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final countData = json.containsKey('data') ? json['data'] as int : null;

    return JoinLiveStreamResponse(
        countData, statusMessageResponse.status, statusMessageResponse.message);
  }
}
