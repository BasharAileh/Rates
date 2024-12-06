import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/widgets.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: AspectRatios.heightWithoutAppBar * 0.31990521327,
            horizontal: AspectRatios.width * 0.07051282051),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Verify your mobile number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(
                height: AspectRatios.height * 0.03791469194,
              ),
              const Flexible(
                child: Text(
                  'Please enter the OTP consisting of 6-digits that has been sent to your mobile number',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.02132701421,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    6,
                    (index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: AspectRatios.width * 0.13034188034,
                            height: AspectRatios.height * 0.05450236966,
                            child: customTextField(borderRadius: 15),
                          ),
                          if (index != 5)
                            SizedBox(
                              width: AspectRatios.width * 0.01538461538,
                            )
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: AspectRatios.height * 0.01777251184,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(
                    AspectRatios.width * 0.58717948717,
                    AspectRatios.height * 0.05450236966,
                  ),
                  maximumSize: Size(
                    AspectRatios.width * 0.58717948717,
                    AspectRatios.height * 0.05450236966,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(verifySuccessRoute);
                },
                child: const Text('data'),
              ),
              SizedBox(
                height: AspectRatios.height * 0.02369668246,
              ),
              SizedBox(
                height: AspectRatios.height * 0.02251184834,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No OTP has been received ? '),
                    Text(
                      'Resend',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
