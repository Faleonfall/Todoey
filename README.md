# Todoey ✓

A simple iOS to-do list app for keeping track of your tasks.
Organize todos into categories with persistent local storage, swipe-to-delete, and colorful UI.

---

## 🧭 Features

* Create categories and add todo items under each
* Mark items as done with a checkmark
* Swipe to delete categories and items
* Persistent local storage with Realm
* Color-coded categories and cells
* Search bar to filter items

---

## 🛠️ Tech Stack

* **Language:** Swift 6
* **Framework:** UIKit
* **Platform:** iOS 18+
* **Storage:** Realm
* **Dependencies:** RealmSwift, SwipeCellKit

---

## 🚀 Setup

```bash
pod install
git config core.hooksPath .githooks   # enable swift-format pre-commit hook
open Todoey.xcworkspace
```

---

## 📦 About

Built as a learning project to practice persisting data on iOS. Explores saving data with
UserDefaults, Core Data, and Realm, settling on Realm for the final implementation alongside
a clean category and item browsing flow.
