import 'package:flutter/material.dart';
import 'login_screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  String? passwordError;
  String? confirmError;

  void handleSubmit() {
    final password = passController.text.trim();
    final confirm = confirmController.text.trim();

    setState(() {
      passwordError = null;
      confirmError = null;

      if (password.isEmpty) {
        passwordError = 'Mật khẩu không được để trống';
      } else if (password.length < 6) {
        passwordError = 'Mật khẩu phải có ít nhất 6 ký tự';
      }

      if (confirm.isEmpty) {
        confirmError = 'Vui lòng nhập lại mật khẩu';
      } else if (password != confirm) {
        confirmError = 'Mật khẩu không trùng khớp';
      }
    });

    // ✅ THÀNH CÔNG → HIỆN SNACKBAR + QUAY VỀ LOGIN MƯỢT
    if (passwordError == null && confirmError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt lại mật khẩu thành công')),
      );

      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo mật khẩu mới")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// MẬT KHẨU MỚI
            TextField(
              controller: passController,
              obscureText: obscure1,
              onChanged: (_) => setState(() => passwordError = null),
              decoration: InputDecoration(
                labelText: "Mật khẩu mới",
                errorText: passwordError,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => obscure1 = !obscure1),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// NHẬP LẠI MẬT KHẨU
            TextField(
              controller: confirmController,
              obscureText: obscure2,
              onChanged: (_) => setState(() => confirmError = null),
              decoration: InputDecoration(
                labelText: "Nhập lại mật khẩu",
                errorText: confirmError,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => obscure2 = !obscure2),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: handleSubmit,
                child: const Text("Hoàn tất"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
