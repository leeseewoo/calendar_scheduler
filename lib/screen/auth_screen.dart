import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 로고 이미지
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset(
                  'assets/img/logo.png',
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),

            // 구글로 로그인 버튼
            ElevatedButton(
              onPressed: () => onGoogleLoginPress(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SECONDARY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: Text('구글로 로그인'),
            ),
          ],
        ),
      ),
    );
  }

  onGoogleLoginPress(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      // signIn 함수를 실행해서 로그인을 진행합니다.
      GoogleSignInAccount? account = await googleSignIn.signIn();

      print(account);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패')),
      );
    }
  }
}
