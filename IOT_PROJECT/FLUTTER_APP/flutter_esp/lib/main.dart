// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_esp/Helper/service_locator.dart';
import 'package:flutter_esp/Service/MQTTAppState.dart';
import 'package:flutter_esp/Service/MQTTManager.dart';
import 'package:flutter_esp/components/card_control.dart';
import 'package:flutter_esp/components/temp_humi_gauge.dart';
import 'package:flutter_esp/components/volt_current_card.dart';
import 'package:flutter_esp/size_config.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTManager>(
      create: (context) => service_locator<MQTTManager>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MQTTManager _manager = MQTTManager();

  void ConnectMqtt() async{
    print("start");
    await Future.delayed(const Duration(microseconds: 100), () => _manager.connect());
    await Future.delayed(const Duration(seconds: 4),
      ()=> _manager.subScribeTo("temp"));
    print(_manager.currentState.getAppConnectionState);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    Future.delayed(const Duration(microseconds: 300),
        () => _manager.unSubscribeFromCurrentTopic());
    Future.delayed(
        const Duration(microseconds: 600), () => _manager.disconnect());
    super.dispose();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    ConnectMqtt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _manager = Provider.of<MQTTManager>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              Consumer<MQTTManager>(
              builder: (context, manager, child) {
                return Text(manager.currentState.getReceivedText); // Hiển thị giá trị temp
              },
            ),
              ElevatedButton(
                  onPressed: () {
                    print(0);
                    _manager.connect();
                    print(1);
                  },
                  child: const Text("subrice")),
            ],
          ),
        ),
      ),
    );
  }
}
