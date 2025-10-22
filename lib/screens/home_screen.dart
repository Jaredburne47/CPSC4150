import 'package:flutter/material.dart';
import '../models/quick_note.dart';
import '../services/note_storage.dart';
import '../widgets/note_form_sheet.dart';
import '../widgets/empty_state.dart';

// Main screen displaying the list of notes
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteStorage _storage = NoteStorage();
  final List<QuickNote> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Loads notes from shared_preferences
  Future<void> _load() async {
    setState(() => _loading = true);
    final loaded = await _storage.load();
    setState(() {
      _notes
        ..clear()
        ..addAll(loaded);
      _loading = false;
    });
  }

  // Saves current list of notes

  Future<void> _persist() async => _storage.save(_notes);

  //adds new note from the bottom sheet
  Future<void> _addNote() async {
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const NoteFormSheet(),
      ),
    );
    if (text == null) return;
    setState(() {
      _notes.insert(
        0,
        QuickNote(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: text,
          createdAt: DateTime.now(),
        ),
      );
    });
    await _persist();
    _snack('Saved note');
  }

  // Edit an existing note
  Future<void> _editNote(QuickNote note) async {
    final updatedText = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: NoteFormSheet(initialText: note.text),
      ),
    );
    if (updatedText == null) return;
    final idx = _notes.indexWhere((n) => n.id == note.id);
    setState(() => _notes[idx] = note.copyWith(text: updatedText));
    await _persist();
    _snack('Updated');
  }
  // Toggle star status
  Future<void> _toggleStar(QuickNote note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    setState(() => _notes[idx] = note.copyWith(isStarred: !note.isStarred));
    await _persist();
  }
  //delete a note by swiping
  Future<void> _delete(QuickNote note) async {
    setState(() => _notes.removeWhere((n) => n.id == note.id));
    await _persist();
    _snack('Deleted');
  }

  // Clear all saved notes
  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all?'),
        content: const Text('This will remove all notes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _notes.clear());
    await _storage.clear();
    _snack('All cleared');
  }

  // Add five pre-filled sample notes to easily test/showcase
  Future<void> _seedSamples() async {
    final now = DateTime.now();
    setState(() {
      _notes
        ..clear()
        ..addAll(List.generate(5, (i) {
          const texts = [
            'Ship it!',
            'Read Chapter 7',
            'Email Prof about project',
            'Groceries: eggs, milk, rice',
            'Daily quote: "Stay curious."',
          ];
          return QuickNote(
            id: (now.microsecondsSinceEpoch + i).toString(),
            text: texts[i],
            createdAt: now.subtract(Duration(minutes: i * 5)),
            isStarred: i.isEven,
          );
        }));
    });
    await _persist();
    _snack('Added 5 sample notes');
  }

  // Show a quick snackbar message
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickNotes (Local Persist)'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'seed') _seedSamples();
              if (v == 'clear') _clearAll();
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'seed', child: Text('Add 5 sample notes')),
              PopupMenuItem(value: 'clear', child: Text('Clear all')),
            ],
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? EmptyState(onAdd: _addNote)
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: _notes.length,
          itemBuilder: (ctx, i) {
            final n = _notes[i];
            return Dismissible(
              key: ValueKey(n.id),
              background: Container(
                color: Colors.red.shade400,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => _delete(n),
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                      n.isStarred ? Icons.star : Icons.star_border),
                  onPressed: () => _toggleStar(n),
                ),
                title: Text(n.text),
                subtitle: Text(
                  'Saved ${n.createdAt.toLocal()}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editNote(n),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
    );
  }
}