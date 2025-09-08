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
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _bodyController = TextEditingController();
  final _lengthController = TextEditingController();
  final _sleeveController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _shoulderController.dispose();
    _bodyController.dispose();
    _lengthController.dispose();
    _sleeveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clothing Size')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand (optional)'),
              ),
              _numberField(_shoulderController, 'Shoulder width (cm)'),
              _numberField(_bodyController, 'Body width (cm)'),
              _numberField(_lengthController, 'Length (cm)'),
              _numberField(_sleeveController, 'Sleeve length (cm)'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final item = ClothingItem(
                      name: _nameController.text,
                      brand: _brandController.text.isEmpty
                          ? null
                          : _brandController.text,
                      shoulderWidth: double.parse(_shoulderController.text),
                      bodyWidth: double.parse(_bodyController.text),
                      length: double.parse(_lengthController.text),
                      sleeveLength: double.parse(_sleeveController.text),
                    );
                    context.read<AppState>().addComparison(item);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Compare'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
