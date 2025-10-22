# soloapp4_local_data_storage


QuickNotes is a simple Flutter app that lets users create, view, edit, and delete text notes — all stored locally on the device using shared_preferences.
The data is saved in a JSON-encoded list, ensuring it persists even after closing and reopening the app.

Stores a list of notes (each has an id, text, createdAt timestamp, and optional isStarred flag).
Each note represents a user’s quick thought or reminder.

Example note entry: {
"id": "1712345678901234",
"text": "Ship it!",
"createdAt": "2025-10-21T18:20:00.000Z",
"isStarred": true
}

All notes are serialized into one JSON string and stored under the key quicknotes_v1.
This appears in Androids storage as flutter.quicknotes_v1 inside FlutterSharedPreferences.xml.