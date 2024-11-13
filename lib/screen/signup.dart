import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/widget/text_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _onTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainTabScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            const TextFieldWidget(
              text: '이메일',
              hintText: '이메일을 입력해주세요.',
            ),
            const SizedBox(height: 30),
            const TextFieldWidget(
              text: '비밀번호',
              hintText: '비밀번호를 입력해주세요.',
            ),
            const SizedBox(height: 30),
            const TextFieldWidget(
              text: '비밀번호 확인',
              hintText: '비밀번호를 입력해주세요.',
            ),
            const SizedBox(height: 30),
            const TextFieldWidget(
              text: '닉네임',
              hintText: '닉네임을 입력해주세요.',
            ),
            const SizedBox(height: 70),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: _onTap,
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
