
// ignore_for_file: constant_identifier_names

// import 'package:fanboos/Controller/Tab/General/WidgetToDoList.dart';
import 'package:fanboos/Controller/ToDoList/TodoList.dart';
import 'package:fanboos/Controller/login_page.dart';
// import 'package:fanboos/Controller/mainpage/Informasi.dart';
// import 'package:fanboos/Controller/mainpage/alertScreen.dart';
import 'package:fanboos/Controller/mainpage/berita.dart';
// import 'package:fanboos/Controller/mainpage/drawerEndScreen.dart';
// import 'package:fanboos/Controller/mainpage/drawerScreen.dart';
// import 'package:fanboos/Controller/mainpage/homeScreen.dart';
import 'package:fanboos/Controller/mainpage/home_screen.dart';
import 'package:fanboos/Controller/mainpage/profile.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:fanboos/Systems/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:fanboos/Systems/connectivity_provider.dart';
import 'package:provider/provider.dart';

class MenuUtama extends StatefulWidget {
  // ignore: non_constant_identifier_names
  static const String TAG = '/MenuUtama';
  const MenuUtama({Key? key}) : super(key: key);

  @override
  _MenuUtamaState createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  late String token;

  int _selectorIndex = currenttab;
  // ignore: unused_field
  final List<Widget> _widgetOption = [
    const Home_Screen(),
    const BeritaScreen(),
    const ToDoList(),
    ProfileScreen()
  ];

  void _onItemTab(int index) {
    // print(index);
    setState(() {
      _selectorIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectorIndex =
        0; // angka 1 untuk default buttom tab bar "Home" ada di tab 1
    _onItemTab(_selectorIndex);

    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/menu_utama': (BuildContext context) => const MenuUtama(),
        '/loginpage': (BuildContext context) => const LoginPage(),
      },
      home: Scaffold(
        // drawer: DrawerScreen(),
        // endDrawer: InfoScreen(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(companyName),
          backgroundColor: kPrimaryColor,
          elevation: 0,
          toolbarHeight: mytoolbarHeight,
          // titleSpacing: 20,
        ),
        body: Consumer<ConnectivityProvider>(builder: (context, model, child) {
          // ignore: unnecessary_null_comparison
          if (model.isOnline != null) {
            // print(_selectorIndex);
            return model.isOnline
                ? _widgetOption.elementAt(_selectorIndex)
                : NoInternet();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
        bottomNavigationBar: navBarBottom(),
      ),
    );
  }

  Container navBarBottom() {
    // print(_selectorIndex);
    return Container(
      color: Colors.black54,
      child: DefaultTabController(
        length: 1,
        // initialIndex: 3,
        child: BottomNavigationBar(
          currentIndex: _selectorIndex,
          onTap: _onItemTab,
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle:
              const TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold),
          // unselectedLabelStyle: TextStyle(color: Colors.black54),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                // ignore: deprecated_member_use
                title: Text('Home'),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.email_outlined),
                // ignore: deprecated_member_use
                title: Text('Task'),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined),
                // ignore: deprecated_member_use
                title: Text('To Do List'),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_alt),
                // ignore: deprecated_member_use
                title: Text('Profile'),
                backgroundColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
