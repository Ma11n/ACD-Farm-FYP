import 'package:dairyfarmapp/screens/sellmilk/receivedmilk.dart';
import 'package:dairyfarmapp/screens/sellmilk/selledmilk.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';

class MilkDetailScreen extends StatelessWidget {
  const MilkDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Sell Milk"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'RECEIVED'),
              Tab(text: 'SELLED'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ReceivedMilk(),
            SelledMilk(),
          ],
        ),
      ),
    );
  }
}
