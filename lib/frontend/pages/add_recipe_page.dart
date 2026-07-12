import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:meal_planner/imports.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  File? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _pickedImage = File(picked.path);
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (_stepControllers.length <= 1) return;
    setState(() {
      final removed = _stepControllers.removeAt(index);
      removed.dispose();
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final steps = _stepControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title.')),
      );
      return;
    }

    if (steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step.')),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final recipeProvider = context.read<RecipeProvider>();
    String? imagePath;

    final pickedImage = _pickedImage;
    if (pickedImage != null) {
      imagePath = await copyImageToAppStorage(pickedImage, '$id.jpg');
    }

    final recipe = Recipe(id: id, title: title, imagePath: imagePath, steps: steps);

    await recipeProvider.addRecipe(recipe);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput(controller: _titleController, labelText: 'Title', hintText: 'Recipe title'),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: _pickedImage != null
                      ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                      : null,
                ),
                child: _pickedImage == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            TailwindText(context, classes: 'text-lg font-bold', 'Steps'),

            const SizedBox(height: 8),

            for (var i = 0; i < _stepControllers.length; i++)
              Padding(
                key: ValueKey(_stepControllers[i]),
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _stepControllers[i],
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Step ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (_stepControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeStep(i),
                      ),
                  ],
                ),
              ),

            TextButton.icon(
              onPressed: _addStep,
              icon: const Icon(Icons.add),
              label: const Text('Add step'),
            ),
          ],
        ),
      ),
    );
  }
}
