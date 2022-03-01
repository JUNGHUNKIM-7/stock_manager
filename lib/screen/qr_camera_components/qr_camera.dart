import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/appbar_wrapper.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

class QrCamera extends StatefulWidget {
  const QrCamera({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCameraState();
}

class _QrCameraState extends State<QrCamera> {
  Barcode? result;
  String? prod;
  QRViewController? controller;
  late bool paused;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    paused = false;
  }

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
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(context: context, typeOfForm: 'qr'),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: outerSpacing),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: _buildQrView(context),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: innerSpacing * 2,
                    ),
                    if (result != null)
                      // 'QR Type: ${describeEnum(result!.format)}
                      Text('Data: ${prod ?? ''}')
                    else
                      Text(
                        'No QR Detected',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    const SizedBox(
                      height: innerSpacing * 2,
                    ),
                    StreamBuilder<bool>(
                        stream: theme.stream,
                        builder: (context, themeSnapShot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              OutlinedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                        width: 2),
                                  ),
                                ),
                                onPressed: () async {
                                  await controller?.toggleFlash();
                                  setState(() {});
                                },
                                child: FutureBuilder(
                                  future: controller?.getFlashStatus(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == true) {
                                      return Icon(
                                        Icons.flash_on,
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.flash_off,
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: innerSpacing),
                              OutlinedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                        width: 2),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    paused = !paused;
                                  });
                                  if (paused == true) {
                                    await controller?.pauseCamera();
                                  } else {
                                    await controller?.resumeCamera();
                                  }
                                },
                                child: paused == true
                                    ? Icon(
                                        Icons.play_arrow,
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                      )
                                    : Icon(
                                        Icons.pause,
                                        color: themeSnapShot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor,
                                      ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    return QRView(
      cameraFacing: CameraFacing.back,
      overlayMargin: EdgeInsets.symmetric(horizontal: scanArea / 4),
      formatsAllowed: const [BarcodeFormat.qrcode],
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.grey,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      final inventory = BlocProvider.of<BlocsCombiner>(context)
          .inventoryBloc
          .filterByIdWithQr(result!.code ?? '');

      setState(() {
        prod = inventory.title;
      });

      Future.delayed(const Duration(seconds: 1));

      try {
        context.goNamed('HistoryForm', extra: inventory);
      } catch (e) {
        throw Exception(e.toString());
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red[600],
            content: Text(
              'No Permission',
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 14),
            )),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
