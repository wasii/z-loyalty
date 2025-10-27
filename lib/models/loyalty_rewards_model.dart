import 'package:intl/intl.dart';
import 'package:loyalty_program/components/constants.dart';

class LoyaltyRewardsResponse {
  final int error;
  final List<LoyaltyReward> loyaltyRewards;

  LoyaltyRewardsResponse({required this.error, required this.loyaltyRewards});

  factory LoyaltyRewardsResponse.fromJson(Map<String, dynamic> json) {
    return LoyaltyRewardsResponse(
      error: int.tryParse(json['error'].toString()) ?? 0,
      loyaltyRewards:
          (json['loyalty_rewards'] as List<dynamic>?)
              ?.map((e) => LoyaltyReward.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'loyalty_rewards': loyaltyRewards.map((e) => e.toJson()).toList(),
    };
  }
}

class LoyaltyReward {
  final String loyaltyRewardId;
  final String installerId;
  final String date;
  final int points;
  final String? rewardClaimDetails;
  final String addedOn;
  final bool isRewarded;
  final String? rewardedOn;
  final String? rewardRemarks;
  final List<RewardAttachment> rewardAttachments;
  final bool isRejected;
  final String? rejectedOn;
  final String? rejectedRemarks;

  LoyaltyReward({
    required this.loyaltyRewardId,
    required this.installerId,
    required this.date,
    required this.points,
    this.rewardClaimDetails,
    required this.addedOn,
    required this.isRewarded,
    this.rewardedOn,
    this.rewardRemarks,
    required this.rewardAttachments,
    required this.isRejected,
    this.rejectedOn,
    this.rejectedRemarks,
  });

  // Computed properties based on points
  String get rewardName {
    if (points >= 300 && points <= 1499) {
      return 'Cash Prize';
    } else if (points >= 1500 && points <= 2999) {
      return 'Bike Prize';
    } else if (points >= 3000) {
      return 'Umrah Prize';
    } else {
      return 'Reward';
    }
  }

  String get rewardImage {
    if (points >= 300 && points <= 1499) {
      return '${kIconFolder}iconcash.png';
    } else if (points >= 1500 && points <= 2999) {
      return '${kIconFolder}iconbike.png';
    } else if (points >= 3000) {
      return '${kIconFolder}iconumrah.png';
    } else {
      return 'assets/images/icons/reward.png';
    }
  }

  // Computed properties for date and time from rewardedOn
  String get customDate {
    if (rewardedOn == null || rewardedOn!.isEmpty) {
      return '';
    }
    try {
      DateTime dateTime = DateTime.parse(rewardedOn!);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return rewardedOn ?? '';
    }
  }

  String get customTime {
    if (rewardedOn == null || rewardedOn!.isEmpty) {
      return '';
    }
    try {
      DateTime dateTime = DateTime.parse(rewardedOn!);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      loyaltyRewardId: json['loyalty_reward_id'] ?? '',
      installerId: json['installer_id'] ?? '',
      date: json['date'] ?? '',
      points: int.tryParse(json['points'].toString()) ?? 0,
      rewardClaimDetails: json['reward_claim_details']?.toString(),
      addedOn: json['added_on'] ?? '',
      isRewarded: json['is_rewarded'].toString() == "1",
      rewardedOn: json['rewarded_on']?.toString(),
      rewardRemarks: json['reward_remarks']?.toString(),
      rewardAttachments:
          (json['reward_attachments'] as List<dynamic>?)
              ?.map((e) => RewardAttachment.fromJson(e))
              .toList() ??
          [],
      isRejected: json['is_rejected'].toString() == "1",
      rejectedOn: json['rejected_on']?.toString(),
      rejectedRemarks: json['rejected_remarks']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loyalty_reward_id': loyaltyRewardId,
      'installer_id': installerId,
      'date': date,
      'points': points,
      'reward_claim_details': rewardClaimDetails,
      'added_on': addedOn,
      'is_rewarded': isRewarded ? "1" : "0",
      'rewarded_on': rewardedOn,
      'reward_remarks': rewardRemarks,
      'reward_attachments': rewardAttachments.map((e) => e.toJson()).toList(),
      'is_rejected': isRejected ? "1" : "0",
      'rejected_on': rejectedOn,
      'rejected_remarks': rejectedRemarks,
    };
  }
}

class RewardAttachment {
  final String link;
  final String linkThumbnail;

  RewardAttachment({required this.link, required this.linkThumbnail});

  factory RewardAttachment.fromJson(Map<String, dynamic> json) {
    return RewardAttachment(
      link: json['link'] ?? '',
      linkThumbnail: json['link_thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'link': link, 'link_thumbnail': linkThumbnail};
  }
}
