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
      // Allow reading other users' profiles for search functionality
      allow read: if request.auth != null;
      
      // Users can read and write their own items
      match /items/{itemId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // Users can read and write their own friends
      match /friends/{friendId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Friend requests collection
    match /friendRequests/{requestId} {
      // Users can create friend requests
      allow create: if request.auth != null && request.auth.uid == resource.data.fromUserId;
      // Users can read requests sent to them or by them
      allow read: if request.auth != null && 
        (request.auth.uid == resource.data.toUserId || request.auth.uid == resource.data.fromUserId);
      // Users can update requests sent to them (accept/reject)
      allow update: if request.auth != null && request.auth.uid == resource.data.toUserId;
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

### Friends Collection (`/users/{userId}/friends/{friendId}`)
```json
{
  "name": "string",
  "email": "string",
  "avatarUrl": "string",
  "isConfirmed": true
}
```

### Friend Requests Collection (`/friendRequests/{requestId}`)
```json
{
  "fromUserId": "string",
  "toUserId": "string",
  "fromUserName": "string",
  "fromUserEmail": "string",
  "fromUserProfileImageUrl": "string",
  "status": "pending|accepted|rejected",
  "createdAt": "timestamp",
  "respondedAt": "timestamp"
}
```

### Clothing Items Collection (`/users/{userId}/clothingItems/{itemId}`)
```json
{
  "name": "string",
  "description": "string (optional)",
  "imageUrl": "string (Firebase Storage URL)",
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
5. Test friends functionality:
   - Navigate to Friends tab
   - Tap the "+" button to add a new friend
   - Search for another user by email
   - Send a friend request
   - Accept/reject incoming friend requests
   - View your friends list
6. Test clothing items feature:
   - Navigate to Account Tab → My Wardrobe
   - Tap the floating action button to add clothing items
   - Select images, categories, and occasions

## Friends System Features

The new Firebase-based friends system includes:

### Real-time Updates
- Friends list updates automatically when requests are accepted
- Pending requests update in real-time
- No need to refresh the screen manually

### Search and Add Friends
- Search for users by email address
- Send friend requests to existing users
- Prevents duplicate requests and self-invites

### Request Management
- View incoming friend requests in "Pending Invites" tab
- Accept or reject friend requests
- See status updates with confirmation messages

### Security
- Users can only see other users' basic profile information
- Friend requests are protected by Firestore security rules
- Users can only manage their own friends and requests

## Clothing Items Integration

The app now includes a comprehensive clothing items management system integrated with Firebase:

### New Features Added

1. **Firebase Storage Integration**
   - Automatic image upload to Firebase Storage
   - Organized storage structure: `/users/{userId}/items/{filename}`
   - Automatic image deletion when items are removed

2. **Enhanced Firestore Schema**
   - Dedicated `clothingItems` collection under each user
   - Real-time data synchronization
   - Timestamps for creation and updates

3. **New Screens**
   - `AddClothingItemScreen`: Full-featured item creation with image upload
   - `ClothingWardrobeScreen`: Main wardrobe interface with categories
   - `ClothingCategoryItemsScreen`: View items by category

4. **Enhanced Data Models**
   - `ClothingItem` model with categories, occasions, and timestamps
   - Separate from the legacy `Item` model for better structure

### Updated Firestore Structure

#### Clothing Items Collection (`/users/{userId}/clothingItems/{itemId}`)
```json
{
  "name": "string",
  "description": "string (optional)",
  "imageUrl": "string (Firebase Storage URL)",
  "categories": ["string"],
  "occasions": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Firebase Storage Structure
```
/users/{userId}/items/
  ├── 1673456789000_item123.jpg
  ├── 1673456790000_item124.jpg
  └── ...
```

### Testing the Integration

To test the new clothing items feature:

1. **Run the test app:**
   ```bash
   cd /path/to/dressapp
   flutter run lib/clothing_test_main.dart
   ```

2. **Or navigate through the main app:**
   - Go to Account Tab → My Wardrobe
   - Tap the floating action button to add items
   - Select images, categories, and occasions

### Security Rules

Make sure your Firebase Storage rules include:

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

### Services Created

1. **FirebaseStorageService**: Handles image upload/download/deletion
2. **FirestoreClothingService**: CRUD operations for clothing items
3. **ClothingItemBloc**: State management with automatic loading

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
