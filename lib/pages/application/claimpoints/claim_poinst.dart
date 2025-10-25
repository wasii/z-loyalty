import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/models/claim_points_model.dart';
import 'package:loyalty_program/models/claim_reward_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_cell.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_header.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_header.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_successful.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_points_reward.dart';

class ClaimPoints extends StatefulWidget {
  const ClaimPoints({super.key});

  @override
  State<ClaimPoints> createState() => _ClaimPointsState();
}

class _ClaimPointsState extends State<ClaimPoints> {
  bool isLoading = false;
  List<InstallationClaim> claims = [];
  bool showCash = false;
  bool showBike = false;
  bool showUmrah = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getClaimPoints();
    });
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
                  ClaimPointsHeaderSection(),
                  SizedBox(height: 20),
                  ClaimPointRewardSection(
                    title: 'Claim Cash',
                    points: '300',
                    imagePath: '${kIconFolder}iconcash.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Cash',
                        'iconcash',
                        'Cash',
                      );
                    },
                    editable: showCash,
                  ),
                  SizedBox(height: 10),
                  ClaimPointRewardSection(
                    title: 'Bike Prize',
                    points: '1000',
                    imagePath: '${kIconFolder}iconbike.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Bike',
                        'iconbike',
                        'Bike',
                      );
                    },
                    editable: showBike,
                  ),
                  SizedBox(height: 10),
                  ClaimPointRewardSection(
                    title: 'Umrah Package',
                    points: '3000',
                    imagePath: '${kIconFolder}iconumrah.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Umrah Package',
                        'iconumrah',
                        'Umrah',
                      );
                    },
                    editable: showUmrah,
                  ),

                  SizedBox(height: 20),
                  ClaimPointsEarningHeadingSection(),
                  SizedBox(height: 10),
                  ...claims.take(4).map((claim) {
                    return Column(
                      children: [
                        ClaimPointsEarningHistoryCell(
                          title: claim.itemInstalled,
                          seiralnumber: claim.serialNumber,
                          points: '+${claim.pointsEarned}',
                          date: 'N/A', // Date field not available in API
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomPopup(
    BuildContext parentContext,
    String title,
    String icon,
    String reward,
  ) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Image
                Image.asset(
                  title == 'Claim Bike'
                      ? '${kBGFolder}bgBike.png'
                      : '$kIconFolder$icon.png',
                  height: 134,
                  width: 230,
                ),

                const SizedBox(height: 16),

                /// Title / Text
                Text(
                  "Are you Sure to\n$title",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: kTextFieldHeadingNameColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                /// TextField
                AppTextField(
                  controller: _controller,
                  hintText: 'Enter remarks (optional)',
                  prefixImage: 'iconchat.png',
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Claim',
                        onPressed: () {
                          print("User typed: ${_controller.text}");
                          Navigator.pop(context);
                          if (title == 'Claim Cash') {
                            claimCash(_controller.text);
                          } else if (title == 'Claim Bike') {
                            claimBike(_controller.text);
                          } else if (title == 'Claim Umrah') {
                            claimUmrah(_controller.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getClaimPoints() async {
    setState(() => isLoading = true);

    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': 68}, //user?.id ?? 0},
        useFormData: true,
      );

      final json = response.data;
      final claimPoints = InstallationClaimsResponse.fromJson(json);
      if (claimPoints.error == 0) {
        setState(() {
          claims = claimPoints.installationClaims;
          showCash = claimPoints.showCash;
          showBike = claimPoints.showBike;
          showUmrah = claimPoints.showUmrah;
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Claim Points Failed"),
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

  void claimCash(String remarks) async {
    setState(() => isLoading = true);
    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0, 'remarks': remarks},
        useFormData: true,
      );

      final json = response.data;
      final claimReward = ClaimRewardModel.fromJson(json);
      if (claimReward.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClaimPointSuccessful(rewardName: 'Cash', icon: 'iconcash'),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Claim Cash Failed"),
            content: Text(claimReward.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Claim Cash Failed"),
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

  void claimBike(String remarks) async {
    setState(() => isLoading = true);
    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0, 'remarks': remarks},
        useFormData: true,
      );

      final json = response.data;
      final claimReward = ClaimRewardModel.fromJson(json);
      if (claimReward.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClaimPointSuccessful(rewardName: 'Bike', icon: 'iconbike'),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Claim Bike Failed"),
            content: Text(claimReward.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Claim Bike Failed"),
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

  void claimUmrah(String remarks) async {
    setState(() => isLoading = true);
    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0, 'remarks': remarks},
        useFormData: true,
      );

      final json = response.data;
      final claimReward = ClaimRewardModel.fromJson(json);
      if (claimReward.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClaimPointSuccessful(rewardName: 'Umrah', icon: 'iconumrah'),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Claim Umrah Failed"),
            content: Text(claimReward.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Claim Umrah Failed"),
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
