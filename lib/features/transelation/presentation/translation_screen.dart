import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingo_sign/core/utils/helper.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width > 600;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.history, size: isTablet ? 32 : 26),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, size: isTablet ? 32 : 26),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? context.width * 0.1 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: isTablet ? context.height * 0.15 : 250),
              Center(
                child: SvgPicture.asset(
                  'assets/images/person.svg',
                  height: isTablet ? 200 : 175,
                ),
              ),
              SizedBox(height: isTablet ? context.height * 0.12 : 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: isTablet ? 70 : 50,
                        decoration: BoxDecoration(
                          color: AppColor.second,
                          borderRadius: BorderRadius.circular(12),
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
                              child: SvgPicture.asset(
                                'assets/images/Camera.svg',
                                height: isTablet ? 35 : 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 10),
                    Container(
                      height: isTablet ? 70 : 50,
                      width: isTablet ? 70 : 50,
                      decoration: BoxDecoration(
                        color: AppColor.second,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/images/mic.svg',
                          height: isTablet ? 35 : 26,
                          width: isTablet ? 35 : 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? context.height * 0.1 : 50),
            ],
          ),
        ),
      ),
    );
  }
}
