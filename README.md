# My News App

# A new Flutter project.

# Flutter News App

## Project Description

This is a news application built with Flutter, implementing the features required for the Aibuzz Technoventures task.
It includes user login (simulated), displaying news from an API, bookmarking articles, and navigation.

## Features Implemented

*   **Core Features:**
    *   Login Page (UI, basic validation, session persistence)
    *   News Feed (Fetch from API, display list)
    *   Bookmarks (Save/Remove, persistence)
    *   Tab Navigation (News & Bookmarks)
    *   Article Detail (View full article in WebView)

*   **Optional Features:**
    *   Dark Mode (Toggle and preference saving)
    *   Web Search (Search web using Serper API)

## Technology Used

*   **Framework:** Flutter (Latest Stable)
*   **Language:** Dart
*   **State Management:** `provider`
*   **HTTP Client:** `dio`
*   **Local Storage:** `shared_preferences` (Login/Theme), `hive` (Bookmarks)
*   **WebView:** `webview_flutter`
*   **Date Formatting:** `intl`
*   **Image Caching:** `cached_network_image`
*   **App Icons:** `flutter_launcher_icons` (Dev Dependency)

## Architecture Summary

The app follows a layered architecture:
*   **UI:** Widgets and Screens display data and handle user interaction.
*   **State Management:** `provider` manages application state (news list, bookmarks, theme, search results) and notifies the UI of changes.
*   **Services:** Handle external interactions like API calls (`NewsService`, `SearchService`) and local storage details (`BookmarkProvider` interacts with Hive, `ThemeProvider`/Login logic interact with `shared_preferences`).
*   **Models:** Dart classes define data structures (Article, SearchResult).

## Key Packages Used & Why

*   `provider`: Manage application state efficiently and reactively.
*   `dio`: Perform HTTP requests to fetch data from APIs.
*   `shared_preferences`: Simple storage for user preferences (login status, theme).
*   `hive`: Fast and easy-to-use local database for persisting bookmarks.
*   `webview_flutter`: Display web pages (full articles, search links) inside the app.
*   `intl`: Format dates correctly.
*   `cached_network_image`: Improve list performance by caching downloaded images.

## Setup Instructions

1.  Clone the repository: `git clone [Your GitHub Repo URL]`
2.  Navigate to the project: `cd news_app`
3.  Get dependencies: `flutter pub get`
4.  Add API Keys: Replace placeholders in `lib/services/news_service.dart` (News API) and `lib/services/search_service.dart` (Serper API).
5.  Generate Hive adapter: `flutter pub run build_runner build`
6.  Run the app: `flutter run` (on a connected device/emulator)

## Screenshots

Link : https://github.com/SAfsehEhsani/My-News-App/tree/main/assets/icons

## Submission

*   **APK File:** https://drive.google.com/file/d/1yrtGSHFv6y76ZXVE8I0UQiuJ8NtsfVp-/view?usp=sharing


## Developer
*Syed Afseh Ehsani*
