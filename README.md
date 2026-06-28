# Todoey ✓

A simple iOS to-do list app for keeping track of your tasks.
Organize todos into colorful categories with local persistence, swipe-to-delete, and search.

---

## 🧭 Features

* Create categories, each with its own color
* Add todo items under a category
* Tap an item to mark it done with a checkmark
* Swipe to delete categories and items
* Search items within a category
* Color-tinted rows with a gradient and auto-contrast text

---

## 🛠️ Tech Stack

* **Language:** Swift 6
* **UI:** SwiftUI
* **Platform:** iOS 18+
* **Storage:** SwiftData
* **Architecture:** MV with a thin services layer
* **Tests:** Swift Testing
* **Dependencies:** none

---

## 🚀 Setup

```bash
git config core.hooksPath .githooks   # enable swift-format pre-commit hook
open Todoey.xcodeproj
```

Build and run from Xcode, or use the CLI helper:

```bash
scripts/xc.sh build   # build for the pinned simulator
scripts/xc.sh test    # run the unit tests
```

---

## 📦 About

Built as a learning project, rewritten from a UIKit + Realm + CocoaPods app into a
pure SwiftUI app on SwiftData with no third-party dependencies. Logic lives in small
testable services covered by Swift Testing.
