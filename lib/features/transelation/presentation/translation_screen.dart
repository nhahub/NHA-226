import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "Abdelrahman";
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 88),

                Text(
                  "Hi ${name},",
                  style: TextStyle(
                    fontFamily: 'Gloock',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColor.black
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Let's understand each other better",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.darkGray
                  ),
                ),

                SizedBox(height: 32,),

                Container(
                  width: double.infinity,
                  height: 196,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.second
                    ),

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: 
                    Column(
                      children: [
                        Text(
                          'Use the camera below to capture or record your sign language gestures',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGray,
                          ),
                          ),

                          SizedBox(height: 70,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: (){}, 
                                icon: Icon(
                                Icons.copy,
                                color: AppColor.darkGray,
                                )
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 32,),

              Text(
                '• Hold your hand clearly in front of the camera',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.darkGray
                ),
              ),

              Text(
                '• Ensure good lighting',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.darkGray
                ),
              ),

              SizedBox(height: 197,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      
                    ),
                    child: 
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            AppColor.main,
                            AppColor.second
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.41, 
                            1.0,
                          ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ],
                      ),
                      child: Center(
                        child: SizedBox(
                          child: SvgPicture.asset(
                            'assets/images/mdi_camera.svg',
                            ),
                        ),
                      ),
                    )
                    ),
                ],
              )
              ],
            ),
      ),
    );
  }
}
