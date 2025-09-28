import 'package:flutter/material.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_cell.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_cell.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_header.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_header_cell.dart';

class PointsHistoryView extends StatefulWidget {
  const PointsHistoryView({super.key});

  @override
  State<PointsHistoryView> createState() => _PointsHistoryViewState();
}

class _PointsHistoryViewState extends State<PointsHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBarWithBackButton(
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
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
                          PointsHistoryHeaderCell(),
                          SizedBox(height: 5),
                          PointsHistoryCell(),

                          SizedBox(height: 5),
                          PointsHistoryCell(),
                          SizedBox(height: 5),
                          PointsHistoryCell(),
                          SizedBox(height: 5),
                          PointsHistoryCell(),

                          SizedBox(height: 20),

                          PointsHistoryHeaderCell(),
                          SizedBox(height: 5),
                          PointsHistoryCell(),

                          SizedBox(height: 5),

                          PointsHistoryCell(),
                          SizedBox(height: 5),
                          PointsHistoryCell(),
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
}
