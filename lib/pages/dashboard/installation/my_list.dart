import 'package:flutter/material.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/table_cell.dart';
import 'package:loyalty_program/models/my_installation_list_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/pages/dashboard/installation/view_my_item.dart';

class MyProductList extends StatefulWidget {
  const MyProductList({super.key});

  @override
  State<MyProductList> createState() => _MyProductListState();
}

class _MyProductListState extends State<MyProductList> {
  bool isLoading = false;
  List<MyProductsInstallation> installation_list = [];

  @override
  void initState() {
    super.initState();
    getMyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: kPrimaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          CommonScaffoldLayout(
            title: 'Installation',
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: [
                        tableHeader("Serial"),
                        tableHeader("Name"),
                        tableHeader("Installed"),
                        tableHeader("Points"),
                        tableHeader("Action"),
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
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      },
                      children: [
                        for (int i = 0; i < installation_list.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Colors
                                        .grey
                                        .shade100 // even rows
                                  : Colors.grey.shade300,
                            ),
                            children: [
                              tableCell(installation_list[i].serialNumber),
                              tableCell(installation_list[i].clientName),
                              tableCell(installation_list[i].itemInstalled),
                              tableCell(
                                installation_list[i].pointsEarned.toString(),
                              ),
                              tableCellWithActions(
                                onEdit: () {
                                  editItem(installation_list[i]);
                                },
                                onView: () {
                                  viewItem(installation_list[i]);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  void editItem(MyProductsInstallation item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewMyItem(isEditable: true, myProduct: item),
      ),
    );
  }

  void viewItem(MyProductsInstallation item) {}
  void getMyList() async {
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: GetMyInstallationList,
        type: RequestType.post,
        data: {'user_id': 65},
        useFormData: true,
      );

      final json = response.data;
      final installation = MyProductsInstallationsResponse.fromJson(json);
      if (installation.error == 0) {
        setState(() {
          installation_list = installation.installations;
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("My Installation Failed"),
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
