import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding_1.svg',
      'title': 'Connect Effortlessly',
      'subtitle':
          'Make video calls using sign language and communicate easily anytime, anywhere.',
    },
    {
      'image': 'assets/images/onboarding_2.svg',
      'title': 'Instant Translation',
      'subtitle':
          'Convert speech to sign language and vice versa, breaking all communication barriers.',
    },
    {
      'image': 'assets/images/onboarding_3.svg',
      'title': 'Welcome to Lingo Sign',
      'subtitle':
          'Empowering communication for everyone, where voices and signs unite.',
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<OnboardingCubit>().completeOnboarding();
    }
  }

  void _skipPage() {
    _controller.animateToPage(
      onboardingData.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _skipPage,
                  child: SizedBox(
                    width: 60,
                    height: 48,
                    child: Center(
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: _currentIndex == 0
                              ? AppColor.main
                              : AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.height * 0.62,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Column(
                    children: [
                      SizedBox(height: context.height / 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(data['image']!),
                            const SizedBox(height: 32),
                            Text(
                              data['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.main,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                data['subtitle']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.main,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (dotIndex) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: _currentIndex == dotIndex ? 0 : 4,
                  ),
                  width: _currentIndex == dotIndex ? 12 : 8,
                  height: _currentIndex == dotIndex ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == dotIndex
                        ? AppColor.main
                        : AppColor.second,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentIndex > 0
                      ? TextButton(
                          onPressed: _prevPage,
                          child: const Text("Back"),
                        )
                      : const SizedBox(width: 80),
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: _currentIndex == onboardingData.length - 1
                          ? 154
                          : 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColor.main,
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: Center(
                        child: _currentIndex == onboardingData.length - 1
                            ? const Text(
                                'Get Started',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
