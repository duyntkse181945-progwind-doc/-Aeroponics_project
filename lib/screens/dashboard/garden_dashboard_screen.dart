import 'package:flutter/material.dart';
import 'add_garden_card.dart';
import 'garden_detail_screen.dart';
import '../auth/login_screen.dart';

class GardenDashboardScreen extends StatefulWidget {
  const GardenDashboardScreen({super.key});

  @override
  State<GardenDashboardScreen> createState() => _GardenDashboardScreenState();
}

class _GardenDashboardScreenState extends State<GardenDashboardScreen> {
  bool phaoOn = true;
  bool roofOpen = true;

  /// STATE xác định đang chọn khu vườn nào
  int selectedGarden = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌈 Nền gradient cho toàn bộ màn hình
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2F8F46),
              Color(0xFF1E6F3D),
              Color(0xFF134E2E),
            ],
          ),
        ),

        // 🛡 SafeArea tránh tai thỏ / thanh trạng thái
        child: SafeArea(
          child: Column(
            children: [

              ///  PHẦN HEADER + TAB (CỐ ĐỊNH – KHÔNG CUỘN)

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildGardenTabs(),
                  ],
                ),
              ),

              ///  PHẦN NỘI DUNG CÓ THỂ CUỘN

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// GRID HIỂN THỊ SENSOR + TOGGLE

                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _sensorCard(
                            icon: Icons.thermostat,
                            title: "Cảm biến nhiệt độ",
                            value: "28.5 °C",
                          ),
                          _sensorCard(
                            icon: Icons.water_drop,
                            title: "Cảm biến độ ẩm đất",
                            value: "78 %",
                          ),
                          _sensorCard(
                            icon: Icons.wb_sunny,
                            title: "Cảm biến ánh sáng",
                            value: "12000 Lux",
                          ),
                          _sensorCard(
                            icon: Icons.bar_chart,
                            title: "Cảm biến EC / pH",
                            value: "EC: 1.5\npH: 6.2",
                          ),
                          _toggleCard(
                            icon: Icons.waves,
                            title: "Phao điện tử",
                            isOn: phaoOn,
                            onChanged: (v) =>
                                setState(() => phaoOn = v),
                          ),
                          _toggleCard(
                            icon: Icons.home,
                            title: "Mái che",
                            isOn: roofOpen,
                            onChanged: (v) =>
                                setState(() => roofOpen = v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// ➕ Nút thêm vườn
                      _addGardenButton(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER: avatar + tiêu đề + mô tả
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Quản lý chung khu vườn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Dữ liệu thông minh cho vụ mùa bội thu.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// 🔴 LOGOUT (GIỮ NGUYÊN – KHÔNG ĐỤNG)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  /// TAB chuyển đổi khu vườn
  Widget _buildGardenTabs() {
    return Row(
      children: [
        Expanded(
          child: _tab(
            text: "Khu vườn 1",
            active: selectedGarden == 1,
            onTap: () {
              setState(() {
                selectedGarden = 1;
              });
            },
            onManage: () {
              _openGardenDetail(1);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _tab(
            text: "Khu vườn 2",
            active: selectedGarden == 2,
            onTap: () {
              setState(() {
                selectedGarden = 2;
              });
            },
            onManage: () {
              _openGardenDetail(2);
            },
          ),
        ),
      ],
    );
  }

  Widget _tab({
    required String text,
    required bool active,
    required VoidCallback onTap,
    required VoidCallback onManage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: active ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: active ? null : Border.all(color: Colors.white54),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onManage,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.menu, color: Colors.white70, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// CARD SENSOR
  Widget _sensorCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 170),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
          ///  FIX OVERFLOW DUY NHẤT: cho value co giãn chiều cao
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                value,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.35, // phần này là của ec hiển thị trong khung đó
                ),
              ),
            ),


            /// ✅ THÊM LẠI TRẠNG THÁI (KHÔI PHỤC UI CŨ)
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.circle, size: 10, color: Colors.greenAccent),
                SizedBox(width: 6),
                Text(
                  "Trạng thái: Tốt",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// CARD TOGGLE
  Widget _toggleCard({
    required IconData icon,
    required String title,
    required bool isOn,
    required ValueChanged<bool> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 170),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOn ? "Bật" : "Tắt",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isOn,
                  activeColor: Colors.greenAccent,
                  activeTrackColor:
                  Colors.green.withOpacity(0.4), // 👈 SỬA
                  inactiveTrackColor: Colors.white24, // 👈 SỬA
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// NÚT THÊM VƯỜN
  Widget _addGardenButton() {
    return GestureDetector(
      onTap: _showAddGardenOverlay,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF7CFFC4), // 👈 SỬA: XANH MINT DỊU (UI CŨ)
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 8),
          const Text(
            "Thêm vườn",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  void _showAddGardenOverlay() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return const AddGardenCard();
      },
    );
  }

  /// MỞ MÀN HÌNH CHI TIẾT KHU VƯỜN
  void _openGardenDetail(int gardenId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GardenDetailScreen(gardenId: gardenId),
      ),
    );
  }
}
