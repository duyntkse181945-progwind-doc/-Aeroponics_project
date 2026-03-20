import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {

      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      try {

        /// 🔐 HASH PASSWORD bằng bcrypt để mã hóa passwork
        final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        await Supabase.instance.client
            .from('users')
            .insert({
          'number_phone': phone,
          'password': hashedPassword,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công 🎉'),
          ),
        );

        Navigator.pop(context, phone);

      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng ký: $e'),
          ),
        );

      }

    }
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Tạo tài khoản mới',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                /// Tên hiển thị (Username)
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Tên hiển thị',
                    hintText: 'VD: Anh Ba, Chú Tư',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên hiển thị';
                    }
                    if (!RegExp(r'^[a-zA-ZÀ-ỹ0-9\s]+$')
                        .hasMatch(value.trim())) {
                      return 'Tên không được chứa ký tự đặc biệt';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// Số điện thoại
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'VD: 098xxxxxxx',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (!RegExp(r'^0\d{9}$').hasMatch(value.trim())) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu tối thiểu 6 ký tự';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// Xác nhận mật khẩu
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                /// Nút đăng ký
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
