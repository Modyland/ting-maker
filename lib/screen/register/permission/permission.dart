import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  List<Permission> permissions = [
    (Platform.isAndroid && deviceInfo['version.sdkInt'] >= 33) || Platform.isIOS
        ? Permission.photos
        : Permission.storage,
    Permission.camera,
    Permission.notification,
    Permission.locationWhenInUse,
  ];

  void _requestPermissions() async {
    Map<Permission, PermissionStatus> permissionsCheck = await [
      (Platform.isAndroid && deviceInfo['version.sdkInt'] >= 33) ||
              Platform.isIOS
          ? Permission.photos
          : Permission.storage,
      Permission.camera,
      Permission.notification,
      Permission.locationWhenInUse,
    ].request();

    bool isLocationGranted = false;
    permissionsCheck.forEach((permission, status) {
      if (permission == Permission.locationWhenInUse) {
        if (status == PermissionStatus.granted) {
          isLocationGranted = true;
          return;
        }
      }
    });

    if (isLocationGranted) {
      Get.toNamed('/phone_check');
    } else {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\tTING 앱 이용을 위해', style: registerTitleStyle),
            Text('\t접근 권한이 필요합니다.', style: registerTitleStyle),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: permissions.length,
                itemBuilder: (context, index) {
                  final permission = permissions[index];
                  return PermissionWidget(permission);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: 52,
              decoration: enableButton,
              child: MaterialButton(
                animationDuration: Durations.short4,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  _requestPermissions();
                },
                child: const Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionWidget extends StatefulWidget {
  const PermissionWidget(this.permission, {super.key});

  final Permission permission;

  @override
  State<PermissionWidget> createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  @override
  void initState() {
    super.initState();
  }

  String permissionName(String original) {
    switch (original) {
      case 'Permission.locationWhenInUse':
        return '위치 사용 권한 (필수)';
      case 'Permission.photos' || 'Permission.storage':
        return '앨범 접근 권한 (선택)';
      case 'Permission.camera':
        return '카메라 접근 권한 (선택)';
      case 'Permission.notification':
        return '알림 메시지 (선택)';
      default:
        return '';
    }
  }

  CircleAvatar? permissionIcon(String original) {
    switch (original) {
      case 'Permission.locationWhenInUse':
        return CircleAvatar(
          backgroundColor: grey300,
          radius: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: Icon(
              Icons.location_on_outlined,
              color: pointColor,
            ),
          ),
        );
      case 'Permission.photos' || 'Permission.storage':
        return CircleAvatar(
          backgroundColor: grey300,
          radius: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: Icon(
              Icons.image_outlined,
              color: pointColor,
            ),
          ),
        );
      case 'Permission.camera':
        return CircleAvatar(
          backgroundColor: grey300,
          radius: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: Icon(
              Icons.camera_alt_outlined,
              color: pointColor,
            ),
          ),
        );
      case 'Permission.notification':
        return CircleAvatar(
          backgroundColor: grey300,
          radius: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: Icon(
              Icons.sms_outlined,
              color: pointColor,
            ),
          ),
        );
    }
    return null;
  }

  RichText? permissionSubscription(String original) {
    switch (original) {
      case 'Permission.locationWhenInUse':
        return RichText(
          text: TextSpan(
            text:
                'ting 지도 서비스 이용\n위치 기반 동네 게시물 확인\n* ting은 서비스 제공을 위한 용도로만 위치정보가 수집되며\n그 외의 용도로 위치정보를 수집하지 않습니다.',
            style: TextStyle(
              fontSize: 12,
              color: grey400,
            ),
          ),
        );
      case 'Permission.photos' || 'Permission.storage':
        return RichText(
          text: TextSpan(
            text: '프로필 설정, 게시물 이미지 업로드',
            style: TextStyle(
              fontSize: 12,
              color: grey400,
            ),
          ),
        );
      case 'Permission.camera':
        return RichText(
          text: TextSpan(
            text: '게시물 이미지 업로드',
            style: TextStyle(
              fontSize: 12,
              color: grey400,
            ),
          ),
        );
      case 'Permission.notification':
        return RichText(
          text: TextSpan(
            text: '채팅 메시지 및 혜택 정보 알림',
            style: TextStyle(
              fontSize: 12,
              color: grey400,
            ),
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: permissionIcon(widget.permission.toString()),
      title: Text(
        permissionName(widget.permission.toString()),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: permissionSubscription(
        widget.permission.toString(),
      ),
    );
  }
}
