import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_colors.dart';
import 'package:flutter_myapp/pages/add_medicine/add_medicine_page.dart';
import 'package:flutter_myapp/pages/history/history_page.dart';
import 'package:flutter_myapp/pages/today/today_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [const TodayPage(), const HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(),
            body: _pages[_currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: _onAddMedicine,
              child: const Icon(CupertinoIcons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildBottomAppBar()),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 0,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CupertinoButton(
            onPressed: () {
              _onCurrentPage(0);
            },
            child: Icon(
              CupertinoIcons.checkmark,
              color: _currentIndex == 0
                  ? MyAppColors.primaryColor
                  : Colors.grey[300],
            ),
          ),
          CupertinoButton(
            onPressed: () {
              _onCurrentPage(1);
            },
            child: Icon(
              CupertinoIcons.text_badge_checkmark,
              color: _currentIndex == 1
                  ? MyAppColors.primaryColor
                  : Colors.grey[300],
            ),
          ),
        ]),
      ),
    );
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMedicine() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddMedicinePage()));
  }
}
