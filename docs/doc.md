# Lingo Sign — Full Project Documentation

This document provides a complete guide to the **Lingo Sign** Flutter project, covering architecture, feature details, dependencies, call feature implementation, platform setup, running & testing instructions, known issues, and recommended improvements. This is intended as a developer-facing reference for working on the codebase.

---

## Table of Contents

1. [Project Summary](#project-summary)  
2. [High-Level Architecture](#high-level-architecture)  
3. [Tech Stack & Key Dependencies](#tech-stack--key-dependencies)  
4. [Folder Structure](#folder-structure)  
5. [Feature Catalogue](#feature-catalogue)  
6. [Call Feature — Deep Dive](#call-feature--deep-dive)  
7. [Dependency Injection & Service Locator](#dependency-injection--service-locator)  
8. [External Services & Credentials](#external-services--credentials)  
9. [Platform Setup](#platform-setup)  
    - [Android](#android)  
    - [iOS](#ios)  
10. [Run, Debug & Build](#run-debug--build)  
11. [Testing & Troubleshooting](#testing--troubleshooting)  
12. [Coding Conventions & Guidelines](#coding-conventions--guidelines)  
13. [Known Issues & Fixes](#known-issues--fixes)  
14. [Recommendations & Next Steps](#recommendations--next-steps)  
15. [CALLS Setup Guide (Android & iOS)](#calls-setup-guide-android--ios)  

---

## Project Summary

- **Repository:** `lingo_sign`  
- **Purpose:** A sign language-focused social / communication app that supports text, translation, video recording, and real-time audio/video calling with native incoming-call UI.  
- **Supported platforms:** Android and iOS (mobile) — some features (CallKit/VoIP require real devices).  
- **Flutter SDK:** `^3.8.1`  
- **Language:** Dart  

---

## High-Level Architecture

- Layered, feature-based architecture:

  - **Presentation:** BLoCs/Cubits, screens, widgets (`lib/features/<feature>/presentation`)  
  - **Domain:** Entities, repository interfaces, use-cases (`lib/features/<feature>/domain`)  
  - **Data:** Repository implementations, data sources (Firebase, REST) (`lib/features/<feature>/data`)  

- **Global/shared code:** `lib/core`  
  - Dependency injection (`get_it`)  
  - Constants, utilities, configuration (`zego_config.dart`)  
  - Shared widgets  

- **State management:** `flutter_bloc`  

---

## Tech Stack & Key Dependencies

- **Flutter & Dart:** Flutter 3.x/4.x, Dart 3.8.1+  
- **State & DI:** `flutter_bloc`, `equatable`, `get_it`, `dartz`  
- **Realtime / Calls:** `zego_uikit`, `zego_uikit_prebuilt_call`, `zego_callkit`, `zego_zpns`, `zego_plugin_adapter`  
- **CallKit / VoIP:** `flutter_callkit_incoming`, `firebase_messaging`  
- **Backend / Data:** `cloud_firestore`, `firebase_auth`, `supabase_flutter`, `http`  
- **Utilities:** `flutter_screenutil`, `shared_preferences`, `permission_handler`, `image_picker`, `intl`, `timeago`  

Refer to `pubspec.yaml` for exact versions.

---

## Folder Structure

**todo**!!!

---

## Feature Catalogue

- **Auth:** Email/password, Google/Facebook social flows  
- **Friends:** List, add/remove, favorites  
- **Calls:** Make, receive, accept, decline, history  
- **Recording:** Record videos, upload translations  
- **Translation:** Upload and translate videos, text translation  

---

## Call Feature — Deep Dive

### Data Model (`CallEntity`)

- `callId` (String)  
- `callerId`, `callerName` (String)  
- `receiverId`, `receiverName` (String)  
- `startTime` (DateTime)  
- `endTime` (DateTime?)  
- `status` (String) — `pending`, `accepted`, `declined`, `completed`  
- `duration` (int)  
- `isVideoCall` (bool)  

### Firestore Structure

- Collection: `calls`  
- Document ID: `callId`  
- Fields: `callerId`, `callerName`, `receiverId`, `receiverName`, `startTime`, `status`, `isVideoCall`, `extra` (map)  

### Call Bloc

- **Events:** `MakeCallEvent`, `GetCallHistoryEvent`, `AcceptCallEvent`, `DeclineCallEvent`, `ListenToIncomingCallsEvent`  
- **States:** `CallInitial`, `CallLoading`, `CallMade`, `CallIncoming`, `CallHistory`, `CallError`  

### Call Runtime Flow

1. Caller triggers `MakeCallEvent` → `CallBloc` creates Firestore document (`status: 'pending'`)  
2. Receiver listens via `ListenToIncomingCallsEvent` → stream filtered by `receiverId` and `status == pending`  
3. `CallBloc` emits `CallIncoming` → `MyApp` calls `showIncomingCall()`  
4. `FlutterCallkitIncoming.onEvent` receives Answer/Decline → mapped to `CallAction` → pushed to `callActionController`  
5. `CallActionListener` dispatches `AcceptCallEvent` or `DeclineCallEvent`  
6. On accept: update call status, initialize Zego session, navigate to `VideoCallScreen` after ready  
7. On decline: update status, end call UI  

**Implementation Notes**

- Ensure `extra` keys in `showCallkitIncoming()` match `onEvent` payload  
- Navigation to `VideoCallScreen` must occur after Zego initialization  
- Use `emit.forEach` to stream Firestore snapshots to `CallIncoming` state  

---

## Dependency Injection & Service Locator

- Implementations registered in `lib/core/get_it/get_it.dart`  
- To add a new feature:
  1. Create concrete class in `data/`  
  2. Register: `sl.registerLazySingleton<Interface>(() => Impl())`  

---

## External Services & Credentials

- **Firebase:** `google-services.json` (Android), `GoogleService-Info.plist` (iOS)  
- **Supabase:** `supabaseUrl`, `anonKey`  
- **Zego:** App ID / App Sign / token (`zego_config.dart`)  
- **Push notifications:** FCM (Android), APNs / VoIP (iOS)  
