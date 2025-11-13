# 🥪 SANDWICH SHOP

A small Flutter demo app for building and previewing sandwich orders.
Users can choose sandwich size, select bread type, add a special-note, and increment/decrement the order quantity (bounded by a configurable maximum).

# ⭐ KEY FEATURES

    - Choose between footlong and six-inch sandwiches (toggle).
    - Pick bread type (white, wheat, wholemeal) via a DropdownMenu.
    - Add a free-form order note (e.g., "no onions", "extra pickles").
    - Add / Remove buttons to change quantity (enforced max quantity).
    - Visual sandwich emoji display and per-order note shown in the UI.
    - Widget tests covering basic UI flows.


# 🚀 GETTING STARTED

# Prerequisites:

    - Flutter SDK installed (stable channel). Use the latest stable release for best compatibility.
    - Dart (installed as part of Flutter).
    - A platform to run on (Android/iOS simulator or a connected device).
    - Recommended: Visual Studio Code or Android Studio.


# Clone and install

    git clone <repository-url>
    cd sandwich_shop
    flutter pub get


# Run the app (Windows example)

    # List devices
    flutter devices

    # Run on the default device
    flutter run


# Run tests

    flutter test


# 📱 USAGE

# App flow

    - Launch the app to see the current order display at the top.
    - Use the size control (a switch in the current code) to toggle between six-inch and footlong.
    - Use the bread dropdown to choose white, wheat, or wholemeal.
    - Type special instructions in the "Add a note" text field (key: notes_textfield). The note appears below the order display as "Note: <your note>".
    - Press Add to increment quantity (stops at a configured max — App currently instantiates - - OrderScreen with maxQuantity: 5).
    - Press Remove to decrement quantity (does not go below 0).
    - The order display shows sandwich emoji(s) equal to the quantity and a composed label like "1 white footlong sandwich(es): 🥪".


# UI elements to look for

    - App title: "Sandwich Counter".
    - Order display: created by OrderItemDisplay widget.
    - Notes TextField uses the key notes_textfield (useful for widget tests).
    - StyledButton is a reusable button widget used for Add and Remove.


# Screenshots / GIFs

    - Add screenshots to assets/ (or repo root) and reference them here:
        - Example Markdown:
            ![Main screen](assets/screenshot-main.png)

        - Or add an animated GIF assets/demo.gif.


# 📂 PROJECT STRUCTURE

-lib/
    - main.dart — main app UI and widgets (OrderScreen, OrderItemDisplay, StyledButton).
    - views/app_styles.dart — text styles used across the UI.
    -  repositories/order_repository.dart — business logic for quantity, max quantity, canIncrement/canDecrement, increment/decrement methods.

-test/
    - views/widget_test.dart — widget tests covering the app's UI and controls.

-README.md — this file.


# Key files and Responsibilities

-lib/main.dart
    - App — top-level MaterialApp, sets OrderScreen(maxQuantity: 5).
    - OrderScreen — stateful screen with controls for size, bread, notes, and quantity.
    - StyledButton — reusable elevated button with icon/label styling.
    - OrderItemDisplay — shows the composed order text and note.

-lib/repositories/order_repository.dart
    - Encapsulates quantity state and maxQuantity logic (prevents increment/decrement beyond bounds).

-test/views/widget_test.dart
    - Uses widget tests to validate UI text, buttons, dropdown, and notes behavior.

# Dependencies

    Flutter (Material)
    No external third-party packages are required in the current code.


# 🛠 KNOWN ISSUES / LIMITATIONS / ROADMAP

    Size selector is implemented with a Switch. A SegmentedButton (requested UX preference) would provide a clearer explicit selection UI — planned enhancement.
    Persistence: orders are in-memory only. Consider saving to local storage or a backend.
    Accessibility: make sure semantic labels and contrast are validated if shipping to production.
    Tests: add more unit tests for OrderRepository and additional widget tests for edge cases.


# Contributing

    Fork the repo, create a feature branch, open a pull request.
    Keep changes small and focused; add/update tests for new behavior.
    Follow existing code style and patterns.


# CONTACT

Name: Swayam S Patnaik
Email / Profile: swayampatnaik25@gmail.com
GitHub: https://github.com/swayampatnaik