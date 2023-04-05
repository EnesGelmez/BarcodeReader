import 'dart:developer';
import 'dart:io';
import 'package:barcode_reader/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

import '../components/rounded_button.dart';

void main() => runApp(const MaterialApp(
      home: MyHome(),
    ));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  List list = [];
  Barcode? result;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final player = AudioCache();
  bool squareCode = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    bool isNeedSafeArea = MediaQuery.of(context).viewPadding.top > 0;
    Size size = MediaQuery.of(context).size;
    final AudioPlayer audioPlayer = new AudioPlayer();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          if (isNeedSafeArea)
            SafeArea(
              top: true,
              child: Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                ),
              ),
            ),
          Container(
            height: 161.1,
            decoration: const BoxDecoration(
              color: kBackgroundColor,
            ),
            child: _buildQrView(context),
          ),
          SizedBox(
            height: size.height * 0.02,
            child: Container(
              decoration: const BoxDecoration(
                color: kBackgroundColor,
              ),
            ),
          ),
          Container(
            height: size.height * 0.5,
            decoration: const BoxDecoration(
              color: kBackgroundColor,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.orange[400],
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red[400],
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      if (direction == DismissDirection.endToStart) {
                        list.removeAt(index);
                      } else {
                        log("test123456");
                      }
                    });
                  },
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                const Text('Are you sure you want to delete?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes'),
                              )
                            ],
                          );
                        },
                      );
                      log('Deletion confirmed: $confirmed');
                      return confirmed;
                    } else {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'Are you sure you want to add your favourites?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes'),
                              )
                            ],
                          );
                        },
                      );
                      log('Deletion confirmed: $confirmed');
                      return confirmed;
                    }
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(list[index]),
                      ),
                      title: Text(list[index]),
                      // subtitle: Text("\$${list[index]}"),
                      trailing: const Icon(Icons.arrow_back),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: kBackgroundColor),
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        RoundedButton(
                          text: "Clear List",
                          press: () {
                            list = [];
                            setState(() {});
                          },
                          color: kButtonColorPink,
                        ),

                        RoundedButton(
                          text: "Flash",
                          press: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          color: kButtonColorPink,
                        ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await controller?.flipCamera();
                        //     setState(() {});
                        //   },
                        //   child: FutureBuilder(
                        //     future: controller?.getCameraInfo(),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.data != null) {
                        //         return Text(
                        //             'Camera facing ${describeEnum(snapshot.data!)}');
                        //       } else {
                        //         return const Text('loading');
                        //       }
                        //     },
                        //   ),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await controller?.toggleFlash();
                        //     setState(() {});
                        //   },
                        //   child: FutureBuilder(
                        //     future: controller?.getFlashStatus(),
                        //     builder: (context, snapshot) {
                        //       return Text('Flash: ${snapshot.data}');
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RoundedButton(
                          text: "Pause",
                          press: () async {
                            await controller?.pauseCamera();
                          },
                          color: kButtonColorPink,
                        ),
                        RoundedButton(
                          text: "Resume",
                          press: () async {
                            await controller?.resumeCamera();
                          },
                          color: kButtonColorPink,
                        )
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RoundedButton(
                            text: "Type",
                            press: () {
                              setState(() {
                                if (squareCode) {
                                  squareCode = false;
                                } else {
                                  squareCode = true;
                                }
                              });
                            },
                            color: kButtonColorPink,
                          ),
                        ])
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    if (squareCode) {
      return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 125),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    } else {
      return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutWidth: size.width * 0.8,
            cutOutHeight: size.height * 0.09),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (result != null && result!.code == scanData.code) return;
      await player.play("voices/barkod.mp3").then((value) {
        setState(() {
          result = scanData;
          list.add(scanData.code!);
        });
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildCard(String value) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("${value}"),
            ],
          ),
        ),
      );
}
