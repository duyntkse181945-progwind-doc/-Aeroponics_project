import 'package:flutter/material.dart';

class GardenDetailScreen extends StatefulWidget {
  final int gardenId;

  const GardenDetailScreen({
    super.key,
    required this.gardenId,
  });

  @override
  State<GardenDetailScreen> createState() => _GardenDetailScreenState();
}

class _GardenDetailScreenState extends State<GardenDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// 🌈 GIỮ NGUYÊN GRADIENT GIỐNG DASHBOARD
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

        child: SafeArea(
          child: Column(
            children: [

              /// ================= HEADER =================
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildHeader(),
              ),

              /// ================= CONTENT =================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [

                      const SizedBox(height: 16),

                      /// DÃY
                      _sectionCard(
                        title: "Dãy (Row)",
                        icon: Icons.view_column,
                        onAdd: () {
                          _showAddDialog("Thêm dãy mới");
                        },
                      ),

                      const SizedBox(height: 16),

                      /// TRỤ
                      _sectionCard(
                        title: "Trụ (Tower)",
                        icon: Icons.agriculture,
                        onAdd: () {
                          _showAddDialog("Thêm trụ mới");
                        },
                      ),

                      const SizedBox(height: 30),
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

  /// ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quản lý khu vườn ${widget.gardenId}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Quản lý khu, dãy và trụ trong vườn",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  /// ================= SECTION CARD =================
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              /// NÚT THÊM
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.greenAccent),
              ),
            ],
          ),

          const Divider(color: Colors.white24),

          /// DEMO DANH SÁCH (SAU NÀY GẮN DATA)
          const Text(
            "Chưa có dữ liệu",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// ================= DIALOG THÊM =================
  void _showAddDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: const TextField(
            decoration: InputDecoration(
              hintText: "Nhập tên...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }
}
