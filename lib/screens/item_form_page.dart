import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/clothing_item.dart';

class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _chestController = TextEditingController();
  final _lengthController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  String _selectedCategory = 'トップス';
  final List<String> _categories = ['トップス', 'ボトムス', 'ワンピース', 'アウター'];

  @override
  void dispose() {
    _productNameController.dispose();
    _brandController.dispose();
    _shoulderController.dispose();
    _chestController.dispose();
    _lengthController.dispose();
    _sleeveController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppState>().selectedProfile;
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          '服サイズ入力',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade300,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.checkroom,
                          color: Colors.orange.shade400,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profile?.name ?? ''}の服サイズ入力',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            '商品ページのサイズ表を確認して入力',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                _buildSectionTitle('商品情報'),
                const SizedBox(height: 10),
                _buildInputField(
                  controller: _productNameController,
                  label: '商品名',
                  hint: '例: キッズ半袖Tシャツ',
                  icon: Icons.shopping_bag,
                  isRequired: true,
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  controller: _brandController,
                  label: 'ブランド',
                  hint: '例: ユニクロ',
                  icon: Icons.store,
                ),
                const SizedBox(height: 15),
                Text(
                  'カテゴリー',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _categories.map((c) {
                    final selected = _selectedCategory == c;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? Colors.orange.shade300 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),
                _buildSectionTitle('サイズ詳細 (cm)'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _shoulderController,
                        label: '肩幅',
                        hint: '例: 32',
                        icon: Icons.accessibility,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInputField(
                        controller: _chestController,
                        label: '身幅（胸囲）',
                        hint: '例: 35',
                        icon: Icons.favorite,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _lengthController,
                        label: _getLengthLabel(),
                        hint: _getLengthHint(),
                        icon: Icons.height,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    if (_showSleeveLength()) ...[
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildInputField(
                          controller: _sleeveController,
                          label: '袖丈',
                          hint: '例: 15',
                          icon: Icons.gesture,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ],
                ),
                if (_showBottomFields()) ...[
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _waistController,
                          label: 'ウエスト',
                          hint: '例: 26',
                          icon: Icons.circle,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildInputField(
                          controller: _hipController,
                          label: 'ヒップ',
                          hint: '例: 30',
                          icon: Icons.circle_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.ruler,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'サイズ表の見方',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _getSizeGuide(),
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _saveItem,
                    child: const Text(
                      'サイズを保存して比較する',
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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final sleeveText = _showSleeveLength() ? _sleeveController.text : '0';
      final item = ClothingItem(
        name: _productNameController.text,
        brand: _brandController.text.isEmpty ? null : _brandController.text,
        shoulderWidth: double.parse(_shoulderController.text),
        bodyWidth: double.parse(_chestController.text),
        length: double.parse(_lengthController.text),
        sleeveLength: double.parse(sleeveText.isEmpty ? '0' : sleeveText),
      );
      context.read<AppState>().addComparison(item);
      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: isRequired
          ? (v) => v == null || v.isEmpty ? '$labelは必須です' : null
          : null,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.orange.shade300,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _getLengthLabel() {
    switch (_selectedCategory) {
      case 'トップス':
      case 'アウター':
        return '着丈';
      case 'ボトムス':
        return '股下';
      case 'ワンピース':
        return '総丈';
      default:
        return '着丈';
    }
  }

  String _getLengthHint() {
    switch (_selectedCategory) {
      case 'トップス':
      case 'アウター':
        return '例: 45';
      case 'ボトムス':
        return '例: 55';
      case 'ワンピース':
        return '例: 75';
      default:
        return '例: 45';
    }
  }

  bool _showSleeveLength() {
    return _selectedCategory == 'トップス' ||
        _selectedCategory == 'アウター' ||
        _selectedCategory == 'ワンピース';
  }

  bool _showBottomFields() {
    return _selectedCategory == 'ボトムス' ||
        _selectedCategory == 'ワンピース';
  }

  String _getSizeGuide() {
    switch (_selectedCategory) {
      case 'トップス':
        return '• 肩幅：肩の端から端まで\n• 身幅：脇の下を平置きで測定\n• 着丈：襟から裾まで';
      case 'ボトムス':
        return '• 身幅：ウエスト部分を平置きで測定\n• 股下：股部分から裾まで\n• ウエスト：ウエスト部分の幅';
      case 'ワンピース':
        return '• 身幅：胸部分を平置きで測定\n• 総丈：肩から裾まで\n• 袖丈：肩から袖口まで';
      case 'アウター':
        return '• 肩幅：肩の端から端まで\n• 身幅：脇の下を平置きで測定\n• 着丈：襟から裾まで';
      default:
        return '商品ページのサイズ表を参考に入力してください';
    }
  }
}
