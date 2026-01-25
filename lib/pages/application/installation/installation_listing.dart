import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/models/my_installation_list_model.dart';
import 'package:loyalty_program/pages/application/installation/installation_home.dart';

class InstallationListing extends StatefulWidget {
  const InstallationListing({super.key});

  @override
  State<InstallationListing> createState() => _InstallationListingState();
}

class _InstallationListingState extends State<InstallationListing> {
  bool isLoading = false;
  List<MyProductsInstallation> installations = [];
  Map<int, bool> expandedStates = {}; // Track which items are expanded

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInstallationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InstallationListHeaderSection(),
                    SizedBox(height: 20),
                    if (isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kPrimaryColor,
                            ),
                          ),
                        ),
                      )
                    else if (installations.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            'No Data Found',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kTextFieldPlaceholderColor,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: installations.asMap().entries.map((entry) {
                          final index = entry.key;
                          final installation = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _InstallationItem(
                              index: index + 1,
                              installation: installation,
                              isExpanded: expandedStates[index] ?? false,
                              onTap: () {
                                setState(() {
                                  expandedStates[index] =
                                      !(expandedStates[index] ?? false);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getInstallationList() async {
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      var user = await UserPrefsService.getUser();
      final response = await api.request(
        path: GetMyInstallationList,
        type: RequestType.post,
        data: {'user_id': user?.id ?? 0},
        useFormData: true,
      );

      final json = response.data;
      final installationsResponse = MyProductsInstallationsResponse.fromJson(
        json,
      );
      if (installationsResponse.error == 0) {
        setState(() {
          installations = installationsResponse.installations;
        });
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Installation List Failed"),
              content: const Text("Failed to load installations"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Installation List Failed"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class InstallationListHeaderSection extends StatelessWidget {
  const InstallationListHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Text with underline
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installation List',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: kTextHeadingColor,
              ),
            ),
          ],
        ),
        // Right side - Add New button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InstallationHome()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Add New",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _InstallationItem extends StatefulWidget {
  const _InstallationItem({
    required this.index,
    required this.installation,
    required this.isExpanded,
    required this.onTap,
  });

  final int index;
  final MyProductsInstallation installation;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  State<_InstallationItem> createState() => _InstallationItemState();
}

class _InstallationItemState extends State<_InstallationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_InstallationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Section
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isExpanded ? kPrimaryColor : kBoxBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: widget.isExpanded
                    ? Radius.zero
                    : Radius.circular(12),
                bottomRight: widget.isExpanded
                    ? Radius.zero
                    : Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${widget.index}.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isExpanded
                              ? Colors.white
                              : kTextFieldHeadingNameColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.installation.clientName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: widget.isExpanded
                                    ? Colors.white
                                    : kTextFieldHeadingNameColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.installation.serialNumber,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: widget.isExpanded
                                    ? Colors.white.withOpacity(0.9)
                                    : kTextFieldPlaceholderColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      widget.isExpanded ? 0.25 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    turns: widget.isExpanded ? 0.5 : 0.0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.isExpanded ? Colors.white : kPrimaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expanded Content Section
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBoxBackgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images Section
                if (widget.installation.uploadPics.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ...widget.installation.uploadPics.take(3).map((pic) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                pic.linkThumbnail.isNotEmpty
                                    ? pic.linkThumbnail
                                    : pic.link,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: kBoxBackgroundColor,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 24,
                                      color: kTextFieldPlaceholderColor,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 70,
                                        height: 70,
                                        color: kBoxBackgroundColor,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  kPrimaryColor,
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          );
                        }).toList(),
                        if (widget.installation.uploadPics.length > 3)
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: kBoxBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '+${widget.installation.uploadPics.length - 3}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kTextFieldHeadingNameColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                // Details Section
                _DetailRow(
                  label: 'Client Name:',
                  value: widget.installation.clientName,
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Serial Number:',
                  value: widget.installation.serialNumber,
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Client Mobile:',
                  value: widget.installation.clientMobile,
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Installation City:',
                  value: widget.installation.installationCity,
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Item Installed:',
                  value: widget.installation.itemInstalled,
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Points Earned:',
                  value: widget.installation.pointsEarned.toString(),
                ),
                SizedBox(height: 8),
                _DetailRow(
                  label: 'Installation Address:',
                  value: widget.installation.installationAddress,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kTextFieldPlaceholderColor,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: kTextFieldHeadingNameColor,
            ),
          ),
        ),
      ],
    );
  }
}
