import 'package:cours_l3gl_g2/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class CardWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final bool isClickable;

  const CardWidget(
      {super.key, this.height, this.width, required this.isClickable});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.width);
    return GestureDetector(
      onTap: () {
        if (widget.isClickable) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScanScreen(),
              ));
        }
      },
      child: Center(
        child: Container(
          height: widget.height ?? 200,
          width: widget.width ?? 400,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: const AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(.3), BlendMode.srcIn)),
          ),
          child: Center(
            child: Container(
              height: 125,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    child: PrettyQrView.data(
                      data: 'https://google.com',
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  widget.isClickable
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Scanner")
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
