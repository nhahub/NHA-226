import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(onTap: () {}, child: Icon(Icons.history)),

                      const SizedBox(width: 10),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/images/si_notifications-fill.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 280),

            Center(
              child: InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/person.svg',
                  height: 120,
                ),
              ),
            ),

            const SizedBox(height: 250),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.second,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Text Field",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset('assets/images/Camera.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.second,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {},
                      child: SvgPicture.asset('assets/images/mic.svg'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
