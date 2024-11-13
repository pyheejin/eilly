import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/signup.dart';
import 'package:eilly/widget/text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onLoginTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainTabScreen(),
      ),
    );
  }

  void _onSignupTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const TextFieldWidget(
              text: '이메일',
              hintText: '이메일을 입력해주세요.',
            ),
            const SizedBox(height: 50),
            const TextFieldWidget(
              text: '비밀번호',
              hintText: '비밀번호를 입력해주세요.',
            ),
            const SizedBox(height: 70),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _onLoginTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff5c35),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('이메일이  생각 안나요 | 비밀번호 찾기'),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: _onSignupTap,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    side: const BorderSide(color: Color(0xffff5c35)),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffff5c35),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
