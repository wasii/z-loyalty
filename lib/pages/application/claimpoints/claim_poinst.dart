import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/models/claim_points_model.dart';
import 'package:loyalty_program/models/claim_reward_model.dart';
import 'package:loyalty_program/models/dashboard_model.dart';
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
  List<SchemeDetail> schemeDetails = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDashboardData();
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
                  if (schemeDetails.isNotEmpty)
                    ...schemeDetails.map((scheme) {
                      final userPoints = int.tryParse(kUserPoints) ?? 0;
                      final minPoints = int.tryParse(scheme.minPoints) ?? 0;
                      final isEditable = userPoints >= minPoints;

                      // Extract path after mobile_app_apis/
                      String claimPath = '';
                      if (scheme.claimUrl.contains('mobile_app_apis/')) {
                        final index =
                            scheme.claimUrl.indexOf('mobile_app_apis/') +
                            'mobile_app_apis/'.length;
                        claimPath = scheme.claimUrl.substring(index);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClaimPointRewardSection(
                          title: scheme.itemName,
                          points: scheme.minPoints,
                          imagePath: scheme.picUrl,
                          onClaim: () {
                            showCustomPopup(
                              context,
                              scheme.itemName,
                              claimPath,
                            );
                          },
                          editable: isEditable,
                        ),
                      );
                    }).toList(),
                  SizedBox(height: 20),
                  ClaimPointsEarningHeadingSection(claims: claims),
                  SizedBox(height: 10),
                  if (claims.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No Data Found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: kTextFieldPlaceholderColor,
                          ),
                        ),
                      ),
                    )
                  else
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

  void showCustomPopup(BuildContext parentContext, String title, String path) {
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
                const SizedBox(height: 16),

                /// Title / Text
                Text(
                  "Are you sure to claim\n$title",
                  style: GoogleFonts.inter(
                    fontSize: 20,
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
                          claimReward(path, _controller.text);
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

  void loadDashboardData() async {
    try {
      final dashboardData = await UserPrefsService.getDashboardData();
      if (dashboardData != null && mounted) {
        setState(() {
          schemeDetails = dashboardData.schemeDetails;
        });
      }
    } catch (e) {
      // Silently handle error, dashboard data is optional
    }
  }

  void getClaimPoints() async {
    setState(() => isLoading = true);

    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0},
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

  void claimReward(String path, String remarks) async {
    setState(() => isLoading = true);
    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: path,
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
            builder: (context) => ClaimPointSuccessful(
              rewardName: 'Cash',
              icon: '${kIconFolder}iconcash.png',
            ),
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
}
