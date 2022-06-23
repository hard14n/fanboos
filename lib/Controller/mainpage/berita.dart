// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// List<MRModel> dtArray = [];

bool loading = false;
int count = 0;
int jumlahMR = 0;

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({Key? key}) : super(key: key);
  @override
  _BeritaScreenState createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO("/helpdesk_notification/get_need_approval");
  }

  Future<void> _onRefresh() async {
    jumlahMR = 0;
    count = 0;
    getdataFromAPIwDIO("/helpdesk_notification/get_need_approval");
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            height: 50,
            width: wScreen,
            color: Colors.blue,
            child: const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                "Pemberitahuan aplikasi / Notifikasi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Container(
            width: wScreen,
            constraints:
                BoxConstraints.expand(height: hScreen - (hScreen * 0.28)),
            color: Colors.white,
            child: ListView(
              children: [
                RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: _onRefresh,
                    child: MaintenanceRequest(hScreen, wScreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getdataFromAPIwDIO(String Myurl) async {
    String _url = alamaturl + Myurl;
    Dio _dio = Dio();
    Response response;
    jumlahMR = 0;
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));
      print(response.data['data']);
      if (response.statusCode == invalidTokenStatusCode) {
        // login ulang
        setState(() {
          loading = false;
          count = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          jumlahMR = response.data['data'];
          setState(() {
            loading = true;
            count = 1;
          });
        } else {
          //
          setState(() {
            loading = false;
            count = 0;
          });
        }
      }
    } on DioError catch (dioError) {
      print(dioError.response!.data);
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  Container MaintenanceRequest(double hScreen, double wScreen) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      height: hScreen * 0.07,
      width: wScreen,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
        ),
      ),
      child: Row(
        children: [
          const Text(
            "Maintenance Request / Need Approval",
            style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            // color: Colors.amber[200],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1,
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Text(
              jumlahMR.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
