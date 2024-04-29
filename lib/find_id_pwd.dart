import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class FindIdPwdScreen extends StatefulWidget {
  const FindIdPwdScreen({super.key});

  @override
  State<FindIdPwdScreen> createState() => _FindIdPwdScreenState();
}

class _FindIdPwdScreenState extends State<FindIdPwdScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: Get.arguments['tab'] == 'id' ? 0 : 1,
    animationDuration: const Duration(milliseconds: 300),
  );
  String nowTab = Get.arguments['tab'];

  @override
  void initState() {
    super.initState();
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (tabController.index == 0) {
      setState(() {
        nowTab = 'id';
      });
    } else if (tabController.index == 1) {
      setState(() {
        nowTab = 'pwd';
      });
    }
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      overlayColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      indicatorColor: pointColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      labelColor: Colors.black,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: grey300,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      tabs: const [
        Tab(text: "아이디 찾기"),
        Tab(text: "비밀번호 재설정"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _tabBar(),
                const SizedBox(height: 25),
                nowTab == 'id' ? const Text('id') : const Text('pwd')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
