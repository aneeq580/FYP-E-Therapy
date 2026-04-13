import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';

class NoteItem {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

class KeepNotesController extends GetxController {
  static const String storageKey = 'keep_notes_notes';

  final RxList<NoteItem> notes = <NoteItem>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadNotes();
  }

  Future<void> _loadNotes() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final savedJson = prefs.getString(storageKey);
    if (savedJson != null && savedJson.isNotEmpty) {
      try {
        final list = jsonDecode(savedJson) as List<dynamic>;
        final loaded = list
            .map((item) => NoteItem.fromJson(item as Map<String, dynamic>))
            .toList();
        notes.assignAll(loaded);
      } catch (_) {
        notes.clear();
      }
    }
    isLoading.value = false;
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((note) => note.toJson()).toList());
    await prefs.setString(storageKey, encoded);
  }

  void addNote(String title, String content) {
    final note = NoteItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      updatedAt: DateTime.now(),
    );
    notes.insert(0, note);
    _saveNotes();
  }

  void updateNote(NoteItem note, String title, String content) {
    final index = notes.indexWhere((item) => item.id == note.id);
    if (index == -1) return;
    notes[index] = NoteItem(
      id: note.id,
      title: title.trim(),
      content: content.trim(),
      updatedAt: DateTime.now(),
    );
    notes.refresh();
    _saveNotes();
  }

  void deleteNote(NoteItem note) {
    notes.removeWhere((item) => item.id == note.id);
    _saveNotes();
  }

  List<NoteItem> get filteredNotes {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return notes;
    }
    return notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }
}

class KeepNotesScreen extends StatelessWidget {
  const KeepNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KeepNotesController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keep Notes'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditNoteScreen(context, controller),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search notes',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    '${controller.filteredNotes.length} notes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final notes = controller.filteredNotes;
              if (notes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 72,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Keep short notes here and come back anytime.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () => _openEditNoteScreen(
                      context,
                      controller,
                      existingNote: note,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title.isEmpty
                                      ? 'Untitled note'
                                      : note.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => controller.deleteNote(note),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              note.content.isEmpty
                                  ? 'No additional details yet.'
                                  : note.content,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Updated ${_formatDate(note.updatedAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openEditNoteScreen(
    BuildContext context,
    KeepNotesController controller, {
    NoteItem? existingNote,
  }) {
    Get.to(
      () => KeepNoteEditorScreen(
        controller: controller,
        existingNote: existingNote,
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class KeepNoteEditorScreen extends StatefulWidget {
  const KeepNoteEditorScreen({
    super.key,
    required this.controller,
    this.existingNote,
  });

  final KeepNotesController controller;
  final NoteItem? existingNote;

  @override
  State<KeepNoteEditorScreen> createState() => _KeepNoteEditorScreenState();
}

class _KeepNoteEditorScreenState extends State<KeepNoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title);
    _contentController = TextEditingController(
      text: widget.existingNote?.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit note' : 'New note'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                minLines: 12,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              if (isEditing)
                Text(
                  'Last updated ${KeepNotesScreen._formatDate(widget.existingNote!.updatedAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    if (widget.existingNote == null) {
      widget.controller.addNote(title, content);
    } else {
      widget.controller.updateNote(widget.existingNote!, title, content);
    }
    Get.back();
  }
}
