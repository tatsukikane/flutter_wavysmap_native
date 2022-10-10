import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/views/widgets/custom_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

//パッケージ利用ボトムバー永続化（動画が止まらなくなる。）
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }


// class _HomeScreenState extends State<HomeScreen> {
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   // }
//   int pageIdx = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PersistentTabView(
//         navBarStyle: NavBarStyle.style11,
//         // navBarStyle: NavBarStyle.style14,
//         // navBarStyle: NavBarStyle.style6,


//         backgroundColor: Colors.black54,
//         context,
//         screens: pages,
//         items:  [
//           PersistentBottomNavBarItem(
//             icon: Icon(Icons.home, size: 30),
//             activeColorPrimary: Colors.blue.shade300,
//             inactiveColorPrimary: Colors.white,
//             title: 'Home',
//           ),
//           PersistentBottomNavBarItem(
//             icon: Icon(Icons.public, size: 30),
//             title: 'Map',
//             activeColorPrimary: Colors.blue.shade300,
//             inactiveColorPrimary: Colors.white,
//           ),
//           PersistentBottomNavBarItem(
//             icon: CustomIcon(),
//             // label: '',
//             activeColorPrimary: Colors.blue.shade300,
//             inactiveColorPrimary: Colors.white,
//           ),
//           PersistentBottomNavBarItem(
//             icon: Icon(Icons.search, size: 30),
//             title: 'Search',
//             activeColorPrimary: Colors.blue.shade300,
//             inactiveColorPrimary: Colors.white,

//           ),
//           PersistentBottomNavBarItem(
//             icon: Icon(Icons.person, size: 30),
//             title: 'Profile',
//             activeColorPrimary: Colors.blue.shade300,
//             inactiveColorPrimary: Colors.white,
//           ),
//         ],
//       )
//     );
//   }
// }


//パッケージを使わない場合
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.blue.shade300,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public, size: 30),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
