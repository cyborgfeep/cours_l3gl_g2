import 'package:camera/camera.dart';
import 'package:cours_l3gl_g2/main.dart';
import 'package:cours_l3gl_g2/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController controller;
  late PageController pageController;
  bool isFlashOn = false;
  int numPage = 0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    pageController = PageController(initialPage: numPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            scanPage(),
            Container(
              color: Colors.white,
              child: const RotatedBox(
                  quarterTurns: 1,
                  child: CardWidget(
                    isClickable: false,
                    //width: 350,
                    height: 250,
                  )),
            )
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: ToggleSwitch(
            minWidth: 150,
            cornerRadius: 35,
            initialLabelIndex: numPage,
            totalSwitches: 2,
            radiusStyle: true,
            activeFgColor: numPage == 0 ? Colors.white : Colors.black,
            inactiveFgColor: numPage == 0 ? Colors.white : Colors.black,
            activeBgColor: numPage == 0 ? [Colors.grey] : [Colors.white],
            inactiveBgColor: numPage == 0 ? Colors.black : Colors.grey,
            labels: const ['Scanner un code', 'Ma carte'],
            onToggle: (index) {
              numPage = index!;
              pageController.animateToPage(numPage,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: numPage == 0 ? Colors.white : Colors.black,
                  )),
              numPage == 0
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          if (!isFlashOn) {
                            controller.setFlashMode(FlashMode.torch);
                          } else {
                            controller.setFlashMode(FlashMode.off);
                          }
                          isFlashOn = !isFlashOn;
                        });
                      },
                      icon: Icon(
                        !isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ))
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ],
    ));
  }

  Widget scanPage() {
    return Stack(
      children: [
        AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: CameraPreview(controller)),
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode
                        .dstOut), // This one will handle background + difference out
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
