// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, avoid_unnecessary_containers, unused_local_variable, unnecessary_new, avoid_print, sized_box_for_whitespace

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'mListingFee.dart';

List<ListingFeeModel> dtArray = [];

bool loading = false;
int count = 0;

class ListingFee extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<ListingFee> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl + "/listing_fee/list";
    Dio _dio = Dio();
    Response response;

    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));
      // print(response.data['data']);
      if (response.statusCode == invalidTokenStatusCode) {
        // login ulang
        setState(() {
          loading = false;
          count = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          dtArray.clear();

          dtArray = ListingFeeModel.listFromJson(response.data['data']);

          // print(dtArray);

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

  Future<void> _onRefresh() async {
    dtArray.clear();
    count = 0;

    getdataFromAPIwDIO();

    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            'Form Listing Fee / Form Daftar Biaya',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              height: hScreen * 0.1,
              width: wScreen,
              color: Colors.blue,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  "Untuk status Paid,Cancelled, dan Rejected data yang ditampilkan hanya ditahun yang berjalan (2022)",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              height: hScreen * 0.06,
              width: wScreen,
              color: Colors.grey[300],
              child: Text(
                namaLengkap,
                style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            dtArray.isEmpty && count == 0
                ? CircularProgressIndicator()
                : RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: _onRefresh,
                    child: Container(
                      height: hScreen - (hScreen * 0.3),
                      width: wScreen * 0.98,
                      // color: Colors.green,
                      // margin: EdgeInsets.all(2),
                      child: ListView(
                        children: dtArray
                            .map(
                              (e) => Container(
                                child: listData(context, e),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  InkWell listData(BuildContext context, ListingFeeModel e) {
    return InkWell(
      onTap: () {
        setState(() {
          formActive = 'ListingFee';
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ToDoListDetail(
        //       idLaporan: e.id_laporan_detail,
        //       topik: e.deskripsi_topik,
        //       uraianTopik: e.uraian_tindakan,
        //       followUp: e.follow_up,
        //       pic: userID,
        //       dueDate: dueDate,
        //     ),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 1.0),
        decoration: BoxDecoration(
          // color: Colors.grey[50],
          border: Border(
            bottom: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // color: Colors.blue[50],
              height: 37,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * 0.8,
                    // color: Colors.blue,
                    child: new SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        e.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
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
                      e.jumlah.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
