import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/body_profile.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _shoulderController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text(
          '体型登録',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, label: '名前'),
                const SizedBox(height: 16),
                _buildNumberField(_heightController, label: '身長 (cm)'),
                const SizedBox(height: 16),
                _buildNumberField(_shoulderController, label: '肩幅 (cm)'),
                const SizedBox(height: 16),
                _buildNumberField(_chestController, label: '胸囲 (cm)'),
                const SizedBox(height: 16),
                _buildNumberField(_waistController, label: 'ウエスト (cm)'),
                const SizedBox(height: 16),
                _buildNumberField(_hipController, label: 'ヒップ (cm)'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final profile = BodyProfile(
                          name: _nameController.text,
                          height: double.parse(_heightController.text),
                          shoulderWidth: double.parse(_shoulderController.text),
                          chest: double.parse(_chestController.text),
                          waist: double.parse(_waistController.text),
                          hip: double.parse(_hipController.text),
                        );
                        context.read<AppState>().addProfile(profile);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      '登録する',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {required String label}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      validator: (v) => v!.isEmpty ? '必須項目です' : null,
    );
  }

  Widget _buildNumberField(TextEditingController controller, {required String label}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      keyboardType: TextInputType.number,
      validator: (v) => v!.isEmpty ? '必須項目です' : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.pink.shade300),
      ),
    );
  }
}
