// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

// import 'dart:convert';

import 'package:flutter/material.dart';

const kSFProDisplay = 'Poppins';
const kPrimaryColorString = '7FA53F';
const kPrimaryColor = Color(0xFF7FA53F);

//TextFields
const kTextFieldBackgroundColor = Color(0xFFD9D9D9);
const kTextFieldTextColor = Color(0xFFA09D98);
const kTextFieldHeadingNameColor = Color(0xFF383737);
const kTextFieldMandatoryColor = Color(0xFFFF0000);
const kDefaultTextFieldColor = Color(0xFF464646);
const kDefaultDisabledButtonColor = Color(0xFFC0E599);

//Image Paths
const kLogoFolder = 'assets/images/logos/';
const kIconFolder = 'assets/images/icons/';
const kBGFolder = 'assets/images/bg/';

const kSecondaryColor = Color.fromARGB(255, 0, 153, 255);
const kTextColor = Color(0xFF12153D);
const kTextLightColor = Color(0xFF9A9BB2);
const kFillStarColor = Color(0xFFFCC419);
const kErrorBackColor = Color(0xFFC72C41);

const kDefaultPadding = 20.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 0),
  blurRadius: 10,
  color: Colors.black26,
);

//URLs
const BaseURL = 'https://loyalty-program.ziewnic.com/mobile_app_apis/';
const LoginAPI = 'login.php';
const SendOTP = 'send_otp.php';
const ForgotPassword = 'forgot_password.php';
const ChangePassword = 'change_password.php';

const DashboardGetPoints = 'installer_dashboard.php';

//Registration
const CheckUserName = 'check_username_available.php';
const UserRegistration = 'new_registration.php';
//Installation
const VerifySerialNumber = 'verify_serial.php';
const AddInstallation = 'installation_add.php';
const GetProductList = 'items_list.php';
const GetMyInstallationList = 'installation_list.php';
const DeleteSingleFile = 'installation_delete_single_image.php';
const InstallationEdit = 'installation_edit.php';

//Claim Points
const GetClaimPoints = 'claim_points_list.php';

//Loyalty Rewards
const GetLoyaltyRewards = 'loyalty_rewards_list.php';

//Points Inventory History
const GetPointsInventoryHistory = 'points_inventory_list.php';
