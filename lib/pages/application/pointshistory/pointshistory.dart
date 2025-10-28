import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/models/points_inventory_history_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_cell.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_header.dart';

class PointsHistoryView extends StatefulWidget {
  const PointsHistoryView({super.key});

  @override
  State<PointsHistoryView> createState() => _PointsHistoryViewState();
}

class _PointsHistoryViewState extends State<PointsHistoryView> {
  bool isLoading = false;
  List<PointsInventoryHistoryData> points = [];

  @override
  void initState() {
    super.initState();
    getPointsInventoryHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PointsHistoryHeader(),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (points.isEmpty)
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
                            ...points.map((point) {
                              // Check if points already has a sign
                              String pointsStr = point.points.toString();
                              if (!pointsStr.startsWith('-')) {
                                pointsStr = '+$pointsStr';
                              }

                              return Column(
                                children: [
                                  PointsHistoryCell(
                                    detail: point.details,
                                    inventorytype: point.inventoryType,
                                    points: pointsStr,
                                  ),
                                  SizedBox(height: 5),
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getPointsInventoryHistory() async {
    setState(() => isLoading = true);

    try {
      var user = await UserPrefsService.getUser();
      final api = ApiService();
      final response = await api.request(
        path: GetPointsInventoryHistory,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0},
        useFormData: true,
      );

      final json = response.data;
      final historyPoints = PointsInventoryHistoryResponse.fromJson(json);
      if (historyPoints.error == 0) {
        setState(() {
          points = historyPoints.pointsInventoryHistory;
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Points Inventory Failed"),
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
