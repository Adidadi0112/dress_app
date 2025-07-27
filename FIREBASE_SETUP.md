# Firebase Setup Guide for Dress App

This guide will help you set up Firebase for the Dress App, replacing the Xano backend.

## Prerequisites

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

## Setup Steps

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `dress-app` (or your preferred name)
4. Enable Google Analytics (optional)
5. Create the project

### 2. Configure Firebase Authentication

1. In Firebase Console, go to Authentication
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider
5. Optionally enable "Google" provider for social login

### 3. Configure Firestore Database

1. In Firebase Console, go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to your users)

### 4. Configure Firebase Storage (for images)

1. In Firebase Console, go to Storage
2. Click "Get started"
3. Choose "Start in test mode"
4. Select same location as Firestore

### 5. Configure Firebase for Flutter

Run the FlutterFire configuration command:

```bash
cd /path/to/dressapp
flutterfire configure
```

This will:
- Generate platform-specific configuration files
- Update `lib/firebase_options.dart` with your project configuration
- Configure Android and iOS apps

Select the platforms you want to support (iOS, Android, Web).

### 6. Update Firestore Security Rules

Replace the default Firestore rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Users can read and write their own items
      match /items/{itemId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 7. Update Storage Security Rules

Replace the default Storage rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Data Structure

### Users Collection (`/users/{userId}`)
```json
{
  "uid": "string",
  "name": "string",
  "email": "string",
  "photoURL": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Items Collection (`/users/{userId}/items/{itemId}`)
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "imageUrl": "string",
  "categories": ["string"],
  "occasions": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Testing

1. Run the app: `flutter run`
2. Create a test account using the register screen
3. Try logging in/out
4. Test adding items to your wardrobe

## Migration Notes

The app has been migrated from Xano to Firebase with the following changes:

1. **Authentication**: Now uses Firebase Auth instead of Xano auth tokens
2. **Data Storage**: Items are stored in Firestore instead of Xano database
3. **User Management**: User profiles stored in Firestore
4. **Real-time Updates**: Firestore provides real-time data synchronization
5. **Offline Support**: Firestore works offline by default

## Troubleshooting

### Common Issues:

1. **"Default FirebaseOptions" error**: Make sure you've run `flutterfire configure`
2. **Permission denied**: Check your Firestore security rules
3. **Authentication errors**: Verify email/password provider is enabled in Firebase Console

### Getting Help:

- Check Firebase Console for detailed error logs
- Review Firestore rules in the "Rules" tab
- Check Authentication settings and enabled providers
