import 'package:flutter/material.dart';

class AddGardenCard extends StatelessWidget {
  const AddGardenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 👈 để nền dialog trong suốt
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== TITLE =====
              const Text(
                "Thêm vườn mới",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ===== INPUT TÊN VƯỜN =====
              TextField(
                decoration: InputDecoration(
                  labelText: "Tên vườn",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== INPUT GHI CHÚ =====
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Ghi chú",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===== BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 👈 đóng overlay
                  },
                  child: const Text("Xác nhận"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
