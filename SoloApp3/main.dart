import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

/// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo App 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use Material 3 styling with a custom seed color
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const DogImagePage(),
    );
  }
}

/// Page that shows a random dog image
class DogImagePage extends StatefulWidget {
  const DogImagePage({super.key});

  @override
  State<DogImagePage> createState() => _DogImagePageState();
}

class _DogImagePageState extends State<DogImagePage> {
  String? imageUrl;        // Stores the fetched dog image URL
  bool isLoading = false;  // Tracks loading state
  String? errorMessage;    // Holds error message if any

  /// Fetches a random dog image from the Dog CEO API
  Future<void> fetchDogImage() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response =
      await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          imageUrl = data['message'];
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please check your connection.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDogImage(); // Fetch on app start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐶 Random Dog Viewer'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Different UIs depending on state
          child: isLoading
          // LOADING STATE
              ? const CircularProgressIndicator()
              : errorMessage != null
          // ERROR STATE
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: fetchDogImage,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          )
          // SUCCESS STATE
              : imageUrl != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl!,
                  height: 300,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: fetchDogImage,
                icon: const Icon(Icons.pets),
                label: const Text('Fetch Another Dog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          )
          // EMPTY STATE (should rarely happen)
              : const Text('No image available.'),
        ),
      ),
    );
  }
}