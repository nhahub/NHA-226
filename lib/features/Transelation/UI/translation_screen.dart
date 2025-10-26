import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

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
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/Refresh.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.menu,
                          size: 28,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/si_notifications-fill.png',
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
                child: Image.asset('assets/images/person.png', height: 120),
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
                            child: Image.asset('assets/images/Camera.png'),
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
                      child: Image.asset('assets/images/mic.png'),
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
