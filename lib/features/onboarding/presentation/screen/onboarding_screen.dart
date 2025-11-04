import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
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
      // Navigator.pushNamedAndRemoveUntil(context, '', (context) => false);
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
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: index == 0
                      ? TextButton(
                          onPressed: _skipPage,
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: AppColor.main),
                          ),
                        )
                      : const SizedBox(height: 40),
                ),
                SizedBox(height: 64),
                SvgPicture.asset(data['image']!),
                SizedBox(height: 32),
                Column(
                  children: [
                    Text(
                      data['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.main,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data['subtitle']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.main,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (dotIndex) => Container(
                      margin: const EdgeInsets.all(4),
                      width: _currentIndex == dotIndex ? 10 : 6,
                      height: _currentIndex == dotIndex ? 10 : 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == dotIndex
                            ? AppColor.main
                            : AppColor.second,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (index > 0)
                      TextButton(
                        onPressed: _prevPage,
                        child: const Text("Back"),
                      )
                    else
                      const SizedBox(width: 80),
                    if (index == 2)
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: 154,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColor.main,
                            borderRadius: BorderRadius.circular(500),
                          ),
                          child: Center(
                            child: Text(
                              'get started',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColor.main,
                            borderRadius: BorderRadius.circular(500),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
