import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/models/loyalty_rewards_model.dart';

class LoyaltyRewardHome extends StatefulWidget {
  const LoyaltyRewardHome({super.key});

  @override
  State<LoyaltyRewardHome> createState() => _LoyaltyRewardHomeState();
}

class _LoyaltyRewardHomeState extends State<LoyaltyRewardHome> {
  bool isLoading = false;
  List<LoyaltyReward> rewards = [];
  int pointsSpent = 0;
  bool isPendingExpanded = false;
  bool isCompletedExpanded = false;
  bool isRejectedExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoyaltyRewardList();
    });
  }

  List<LoyaltyReward> get pendingRewards {
    return rewards
        .where((reward) => !reward.isRewarded && !reward.isRejected)
        .toList();
  }

  List<LoyaltyReward> get completedRewards {
    return rewards.where((reward) => reward.isRewarded).toList();
  }

  List<LoyaltyReward> get rejectedRewards {
    return rewards.where((reward) => reward.isRejected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoyaltyRewardHeader(
                    heading: 'Loyalty Rewards',
                    dateRange: 'Date: N/A', //Aug 10 - Sep 10, 2025',
                    pointsSpent: pointsSpent.toString(),
                  ),
                  const SizedBox(height: 20),
                  if (rewards.isEmpty)
                    Center(
                      child: Text(
                        'No Data Found',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextFieldPlaceholderColor,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        _ExpandableTab(
                          title: 'Pending (Claimed)',
                          count: pendingRewards.length,
                          isExpanded: isPendingExpanded,
                          onTap: () {
                            setState(() {
                              isPendingExpanded = !isPendingExpanded;
                            });
                          },
                          rewards: pendingRewards,
                        ),
                        const SizedBox(height: 12),
                        _ExpandableTab(
                          title: 'Rewarded',
                          count: completedRewards.length,
                          isExpanded: isCompletedExpanded,
                          onTap: () {
                            setState(() {
                              isCompletedExpanded = !isCompletedExpanded;
                            });
                          },
                          rewards: completedRewards,
                        ),
                        const SizedBox(height: 12),
                        _ExpandableTab(
                          title: 'Rejected',
                          count: rejectedRewards.length,
                          isExpanded: isRejectedExpanded,
                          onTap: () {
                            setState(() {
                              isRejectedExpanded = !isRejectedExpanded;
                            });
                          },
                          rewards: rejectedRewards,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getLoyaltyRewardList() async {
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      var user = await UserPrefsService.getUser();
      final response = await api.request(
        path: GetLoyaltyRewards,
        type: RequestType.post,
        data: {'user_id': 65},
        useFormData: true,
      );

      final json = response.data;
      final claimPoints = LoyaltyRewardsResponse.fromJson(json);
      if (claimPoints.error == 0) {
        setState(() {
          rewards = claimPoints.loyaltyRewards;
          // Calculate total points from all rewards
          pointsSpent = rewards.fold(0, (sum, reward) => sum + reward.points);
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Loyalty Rewards Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class LoyaltyRewardHeader extends StatelessWidget {
  const LoyaltyRewardHeader({
    super.key,
    required this.heading,
    required this.dateRange,
    required this.pointsSpent,
  });

  final String heading;
  final String dateRange;
  final String pointsSpent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeading(heading: heading),
              const SizedBox(height: 16),
              _DateRangePill(text: dateRange),
            ],
          ),
        ),
        _PointsSpentCard(points: pointsSpent),
      ],
    );
  }
}

class _DateRangePill extends StatelessWidget {
  const _DateRangePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kTextFieldHeadingNameColor,
              ),
            ),
            SizedBox(width: 5),
            Image.asset(
              '${kIconFolder}icondropdown.png',
              width: 10,
              height: 5.83,
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsSpentCard extends StatelessWidget {
  const _PointsSpentCard({required this.points});

  final String points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Points Spent',
            style: TextStyle(
              fontSize: 14,
              color: kTextFieldPlaceholderColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(kIconFolder + 'iconZcoin.png', height: 28, width: 28),
              const SizedBox(width: 8),
              Text(
                points,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextFieldHeadingNameColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableTab extends StatelessWidget {
  const _ExpandableTab({
    required this.title,
    required this.count,
    required this.isExpanded,
    required this.onTap,
    required this.rewards,
  });

  final String title;
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<LoyaltyReward> rewards;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPrimaryColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTextFieldHeadingNameColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && rewards.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: rewards
                  .expand(
                    (reward) => [
                      LoyaltyRewardCell(
                        title: reward.rewardName,
                        points: reward.points,
                        date: reward.customDate,
                        time: reward.customTime,
                        imagePath: reward.rewardImage,
                      ),
                      const SizedBox(height: 5),
                    ],
                  )
                  .toList(),
            ),
          ),
        if (isExpanded && rewards.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBoxBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'No $title Rewards',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTextFieldPlaceholderColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class LoyaltyRewardCell extends StatefulWidget {
  const LoyaltyRewardCell({
    super.key,
    required this.title,
    required this.points,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  final String title;
  final int points;
  final String date;
  final String time;
  final String imagePath;

  @override
  State<LoyaltyRewardCell> createState() => _LoyaltyRewardCellState();
}

class _LoyaltyRewardCellState extends State<LoyaltyRewardCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const LoyaltyRewardHistory()),
        // );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBoxBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left Section - Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(widget.imagePath, width: 36, height: 33),
              ),
            ),
            const SizedBox(width: 16),
            // Middle Section - Title and Points
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.points} Points',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Right Section - Date and Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.date,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.time,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
