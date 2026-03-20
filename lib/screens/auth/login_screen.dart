import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../dashboard/garden_dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 🔥 Controller SĐT để nhận dữ liệu từ Register
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; /// hiện mật khẩu

  // 🔥 MỞ REGISTER + NHẬN SĐT TRẢ VỀ
  Future<void> _goToRegister() async {
    final phoneFromRegister = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );

    if (phoneFromRegister != null) {
      setState(() {
        _phoneController.text = phoneFromRegister;
      });
    }
  }
  /// login sẽ sửa lại.
  Future<void> _handleLogin() async {

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
        ),
      );
      return;
    }

    try {

      final supabase = Supabase.instance.client;

      // Lấy user theo số điện thoại
      final response = await supabase
          .from('users')
          .select()
          .eq('number_phone', phone)
          .maybeSingle();

      if (response == null) {
        throw Exception('User không tồn tại');
      }

      final storedHash = response['password'];

      // 🔐 So sánh password với bcrypt
      final isValid = BCrypt.checkpw(password, storedHash);

      if (!isValid) {
        throw Exception('Sai mật khẩu');
      }

      // Đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const GardenDashboardScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai số điện thoại hoặc mật khẩu'),
        ),
      );

    }
  }


  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F3),
      body: SafeArea(
        child: Stack(
          children: [
            /// ===== BACKGROUND IMAGE =====
            Positioned.fill(
              child: Image.asset(
                'assets/images/Back_groundjpg.jpg',
                fit: BoxFit.cover,
              ),
            ),

            /// ===== LOGO =====
            Positioned(
              top: 8,
              left: 8,
              child: Image.asset(
                'assets/images/Logo_fpt.jpg',
                width: 42,
              ),
            ),

            /// ===== FORM LOGIN =====
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SMART AGRI',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// 🔥 SỐ ĐIỆN THOẠI (NHẬN SĐT TỪ REGISTER)
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Số Điện Thoại',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// MẬT KHẨU
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mật Khẩu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ĐĂNG KÝ - QUÊN MK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _goToRegister, // 🔥 QUAN TRỌNG
                            child: const Text('Đăng ký'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text('Quên mật khẩu'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// NÚT ĐĂNG NHẬP
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
