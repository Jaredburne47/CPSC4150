# soloapp4_local_data_storage
QuickNotes is a simple Flutter app that lets users create, view, edit, and delete text notes — all stored locally on the device using shared_preferences.
The data is saved in a JSON-encoded list, ensuring it persists even after closing and reopening the app.

What the App Stores:
Stores a list of notes (each has an id, text, createdAt timestamp, and optional isStarred flag).
Each note represents a user’s quick thought or reminder.

Storage Used:
shared_preferences package (key/value storage).
All notes are serialized into one JSON string and stored under the key quicknotes_v1.
This appears in Androids storage as flutter.quicknotes_v1 inside FlutterSharedPreferences.xml.

How to run:
Run the commands:
flutter pub get
flutter run

In the app:
Tap menu then “Add 5 sample notes” to create sample data.
Edit, star, or delete notes to test functionality.
Close the app completely and reopen it and the notes will remain saved.
Tap menu then “Clear All” and then the data is cleared and empty state appears.

Data Format: All notes are stored as a single JSON array:
Example note entry: {
"id": "1712345678901234",
"text": "Ship it!",
"createdAt": "2025-10-21T18:20:00.000Z",
"isStarred": true
}

Edge Case I handled:
Corrupted JSON: If decoding fails, the app will reset the data gracefully.
