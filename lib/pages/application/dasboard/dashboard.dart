import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/models/dashboard_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/components/loader.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _points = "0";
  bool isLoading = false;
  DashboardPointsModel? dashboardPointsModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardData();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (dashboardPointsModel != null) {
      _points = dashboardPointsModel!.myCurrentAvailablePoints;
    }
    super.setState(fn);
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
                  WelcomeText(),
                  SizedBox(height: 20),

                  //POINTS BALANCE
                  PointsBalance(points: _points),

                  SizedBox(height: 20),
                  // Scheme details images
                  if (dashboardPointsModel?.schemeDetails != null)
                    ...dashboardPointsModel!.schemeDetails.map((scheme) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: Image.network(
                              scheme.picUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 180,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  void dashboardData() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      var user = await UserPrefsService.getUser();
      final response = await api.request(
        path: DashboardGetPoints,
        type: RequestType.post,
        data: {'user_id': user?.id},
        useFormData: true,
      );

      final json = response.data;
      final dashboard = DashboardPointsModel.fromJson(json);

      if (dashboard.error == 0) {
        setState(() {
          dashboardPointsModel = dashboard;
          kUserPoints = dashboard.myCurrentAvailablePoints;
        });
        // Save dashboard data globally
        await UserPrefsService.saveDashboardData(dashboard);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Dashboard Failed"),
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

class WelcomeText extends StatefulWidget {
  const WelcomeText({super.key});

  @override
  State<WelcomeText> createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await UserPrefsService.getUser();
    if (user != null && mounted) {
      setState(() {
        userName = user.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: kTextFieldPlaceholderColor,
          ),
        ),
        Text(
          userName,
          style: GoogleFonts.inter(
            fontSize: 26,
            color: kTextHeadingColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PointsBalance extends StatelessWidget {
  final String points;
  const PointsBalance({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Point Balance:",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    points,
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Image.asset(
                "${kLogoFolder}ziewnic-white-logo.png",
                height: 40,
                width: 40,
              ),
            ],
          ),
          // const SizedBox(height: 18),
          // Row(
          //   children: [
          //     Text(
          //       "Expiration Date: ",
          //       style: GoogleFonts.inter(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //       ),
          //     ),
          //     Text(
          //       "N/A",
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class PrizeBox extends StatelessWidget {
  final String title;
  final String value;
  final String prize;
  final String imagePath;

  const PrizeBox({
    super.key,
    required this.title,
    required this.value,
    required this.prize,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: kBoxBackgroundColor, // green box
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👉 Left Side Texts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kPrimaryColor, // green box
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextFieldHeadingNameColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "Earned ",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: kTextFieldHeadingNameColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "$value Points",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kTextFieldHeadingNameColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "and Claimed",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prize,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              imagePath,
              height: 140,
              width: 138,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
