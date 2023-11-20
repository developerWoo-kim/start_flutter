import 'package:flutter/material.dart';
import 'package:project/common/const/colors.dart';
import 'package:project/common/layout/default_layout.dart';
import 'package:project/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener); // 탭 이동에 따른 하단 탭 선택 스타일 변경은 ->  리스너 사용

  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '모두의 렌탈',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // 탭바에서 스크롤해도 옆으로 안넘어가는 설정
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Container(child: Text('음식'),)),
          Center(child: Container(child: Text('주문'),)),
          Center(child: Container(child: Text('프로필'),)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // 디폴트 : shifting -> 탭 메뉴를 클릭할 때 마다 선택된 메뉴가 확대됨
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
