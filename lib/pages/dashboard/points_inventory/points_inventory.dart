import 'package:flutter/material.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/table_cell.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/pages/dashboard/claim_points/claim_points.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';
import 'package:loyalty_program/pages/dashboard/installation/search_item.dart';
import 'package:loyalty_program/pages/dashboard/loyalty_rewards/loyalty_rewards.dart';
import 'package:loyalty_program/pages/dashboard/sidemenu/side_menu.dart';

class PointsInventoryHistory extends StatefulWidget {
  const PointsInventoryHistory({super.key});

  @override
  State<PointsInventoryHistory> createState() => _PointsInventoryHistoryState();
}

class _PointsInventoryHistoryState extends State<PointsInventoryHistory> {
  void handleMenuItemTap(String selectedTitle) {
    if (selectedTitle == "Home") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Dashboard()),
      );
    } else if (selectedTitle == "Installation") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SearchNewItem()),
      );
    } else if (selectedTitle == "Claim Points") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ClaimPoints()),
      );
    } else if (selectedTitle == "Loyalty Rewards") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoyaltyRewards()),
      );
    } else if (selectedTitle == "Logout") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()), // 👈 your login page
        (route) => false, // 👈 remove all previous routes
      );
    }
  }

  final List<List<String>> data = List.generate(
    30, // number of rows
    (_) => ['31-Dec-2024', 'Points Earned', '1500', 'Auto Approved by System'],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebarDrawer(
        currentScreen: "Points Inventory\n/ History",
        onMenuItemTap: handleMenuItemTap,
      ),
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (value) {
              print("Search: $value");
            },
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: kDefaultTextFieldColor.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 1,
      ),
      body: CommonScaffoldLayout(
        title: "Points Inventory History",
        child: Column(
          children: [
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  children: [
                    tableHeader('Date'),
                    tableHeader("Inventory Type"),
                    tableHeader("Points"),
                    tableHeader("Details"),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    for (int i = 0; i < data.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: i % 2 == 0
                              ? Colors
                                    .grey
                                    .shade100 // even rows
                              : Colors.grey.shade300,
                        ),
                        children: data[i].map((e) => tableCell(e)).toList(),
                      ),
                    // TableRow(
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade300,
                    //   ),
                    //   children: [
                    //     tableCell(''),
                    //     tableCell(''),
                    //     tableCell('Total $total'),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
