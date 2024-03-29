import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/report_utama.controller.dart';

class ReportUtamaScreen extends GetView<ReportUtamaController> {
  const ReportUtamaScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Please wait a moment, something cool is being processed. :)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
