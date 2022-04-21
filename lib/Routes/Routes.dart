// ignore_for_file: file_names

import 'package:fanboos/Controller/mainpage/menu_utama.dart';
import 'package:fanboos/Controller/Tab/General/ToDoListDownLine/w_ToDoListDownline.dart';
import 'package:get/get.dart';

List<GetPage> get getRoutePages => _routePages;

List<GetPage> _routePages = [
  GetPage(name: MenuUtama.TAG, page: () => const MenuUtama()),
  GetPage(name: WidgetToDoListDownline.TAG, page: () => WidgetToDoListDownline()),
];
