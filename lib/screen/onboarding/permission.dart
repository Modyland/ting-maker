import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  List<Permission> permissions = [
    Permission.locationWhenInUse,
    (Platform.isAndroid && deviceInfo['version.sdkInt'] >= 33) || Platform.isIOS
        ? Permission.photos
        : Permission.storage,
    Permission.camera,
    Permission.notification,
  ];

  void _requestPermissions() async {
    Map<Permission, PermissionStatus> permissionsCheck = await [
      Permission.locationWhenInUse,
      (Platform.isAndroid && deviceInfo['version.sdkInt'] >= 33) ||
              Platform.isIOS
          ? Permission.photos
          : Permission.storage,
      Permission.camera,
      Permission.notification,
    ].request();

    bool allGranted = true;
    permissionsCheck.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allGranted = false;
        return;
      }
    });

    if (allGranted) {
      Get.toNamed('service_agree');
    } else {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Spacer(),
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
                      color: Color(0xffffffff),
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

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PermissionWidget extends StatefulWidget {
  const PermissionWidget(this.permission, {super.key});

  final Permission permission;

  @override
  State<PermissionWidget> createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await widget.permission.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  String permissionName(String original) {
    switch (original) {
      case 'Permission.locationWhenInUse':
        return '위치 사용 권한';
      case 'Permission.photos' || 'Permission.storage':
        return '앨범 접근 권한';
      case 'Permission.camera':
        return '카메라 접근 권한';
      case 'Permission.notification':
        return '알림 메시지';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        permissionName(widget.permission.toString()),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
      ),
    );
  }
}
