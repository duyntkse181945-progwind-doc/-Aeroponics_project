import 'dart:async';
import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isOtpSent = false;
  int countdown = 60;
  Timer? timer;

  String? phoneError; /// 🔥 LỖI SỐ ĐIỆN THOẠI

  // =========================
  // GỬI OTP (CÓ VALIDATE SĐT)
  // =========================
  void sendOtp() {
    final phone = phoneController.text.trim();

    setState(() {
      phoneError = null;

      /// ❌ Không được để trống
      if (phone.isEmpty) {
        phoneError = 'Số điện thoại không được để trống';
      }
      /// ❌ Không đủ 10 số
      else if (phone.length < 10) {
        phoneError = 'Số điện thoại phải đủ 10 chữ số';
      }
    });

    /// ❌ Nếu có lỗi → KHÔNG gửi OTP
    if (phoneError != null) return;

    /// ✅ SỐ HỢP LỆ → GỬI OTP
    setState(() {
      isOtpSent = true;
      countdown = 60;
    });

    startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi mã OTP')),
    );
  }

  // =========================
  // ĐẾM NGƯỢC GỬI LẠI OTP
  // =========================
  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown == 0) {
        t.cancel();
      } else {
        setState(() => countdown--);
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// =========================
            /// NHẬP SỐ ĐIỆN THOẠI
            /// =========================
            TextField(
              controller: phoneController,
              enabled: !isOtpSent, /// Đã gửi OTP thì khóa ô SĐT
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() => phoneError = null),
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: const OutlineInputBorder(),
                errorText: phoneError, /// HIỂN THỊ LỖI
              ),
            ),

            const SizedBox(height: 16),

            /// =========================
            /// NHẬP OTP (CHỈ HIỆN SAU KHI GỬI)
            /// =========================
            if (isOtpSent) ...[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "Mã OTP",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),

              const SizedBox(height: 8),

              /// ĐẾM THỜI GIAN GỬI LẠI OTP
              Text(
                countdown > 0
                    ? "Gửi lại OTP sau $countdown giây"
                    : "Bạn có thể gửi lại OTP",
                style: TextStyle(
                  color: countdown > 0 ? Colors.grey : Colors.blue,
                ),
              ),
            ],

            const Spacer(),

            /// =========================
            /// NÚT GỬI OTP / XÁC NHẬN OTP
            /// =========================
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
                onPressed: () {
                  if (!isOtpSent) {
                    sendOtp(); /// CHỈ GỬI KHI SĐT HỢP LỆ
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen(),
                      ),
                    );
                  }
                },
                child: Text(isOtpSent ? "Xác nhận OTP" : "Gửi mã OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
