

# 🚀 LeadGen Connect MIS (Flutter)

LeadGen Connect is a **role-based Lead Management Information System (MIS)** built using Flutter.  
It implements a **3-tier RBAC system** (Sales Agent, Manager, Executive) with separate dashboards, workflows, and permissions.

---

## 📱 Application Overview

This system simulates a real-world sales pipeline where leads move through multiple stages:  
creation → tracking → verification → approval → analytics.

The app includes:
- Interactive onboarding experience
- Role-based dashboards
- Lead lifecycle management
- Contract verification flow
- Analytics and performance tracking

---

## 🎯 User Roles

### 🔵 Sales Agent
- Create and manage leads
- Log calls and chats
- Track lead status
- Upload required documents
- Move leads to closure stage

⚠️ Cannot close deals without required documents

---

### 🟣 Sales Manager
- Review submitted leads
- Verify contracts
- Approve or reject deals
- Manage team pipeline

---

### 🟡 Executive
- View strategic KPIs
- Analyze performance charts
- Access AI-based win predictions
- Review system audit logs

---

## 📱 Screens Overview (20 Screens)

| # | Screen | Purpose |
|---|--------|--------|
| 0 | Onboarding | Interactive tutorial flow |
| 1 | Authentication | Role-based login |
| 2 | Agent Dashboard | Lead pipeline overview |
| 3 | Lead Form | Create new lead |
| 4 | Active Queue | Lead list management |
| 5 | Lead Profile | Detailed lead view |
| 6 | Activity Logging | Calls & chats |
| 7 | Block Screen | Restricted access handling |
| 8 | Document Upload | Contract uploads |
| 9–10 | Pending State | Waiting for approval |
| 11 | Manager Dashboard | Review queue |
| 12 | Pending Queue | Contract review list |
| 13 | Contract Review | Verification screen |
| 14 | Decision Screen | Approve / Reject |
| 15 | Team Analytics | Performance metrics |
| 16 | Executive Dashboard | Strategic overview |
| 17 | Analytics Charts | Visual reports |
| 18 | AI Predictions | Win probability model |
| 19 | Audit Trail | System logs |
| 20 | Session End | Logout flow |

---

## 🛠️ Installation & Setup

### 1. Install Flutter
Download SDK: https://flutter.dev/docs/get-started/install

Then verify:
```bash
flutter doctor
````

---

### 2. Open Project in VS Code

Install extensions:

* Flutter
* Dart

Open folder:

```
leadgen_connect
```

---

### 3. Install Dependencies

```bash
flutter pub get
```

---

### 4. Run App

```bash
flutter run
```

Or press:

```
F5 (VS Code)
```

---

## 📂 Project Structure

```
lib/
├── main.dart
├── theme/
├── models/
├── utils/
├── widgets/
└── screens/
```

---

## ✨ Key Features

* 🌙 Glassmorphism UI
* 🎮 Interactive onboarding
* 🔐 Role-Based Access Control (RBAC)
* 📊 Charts & analytics (fl_chart)
* 🤖 AI-based win prediction (mock model)
* 📋 Audit logging system
* ⚡ Business rule enforcement
* 💾 Provider state management

---

## ⚠️ Common Issues

### Flutter pub get fails

```bash
flutter clean
flutter pub get
```

### Device not detected

```bash
flutter devices
```

### Black screen issue

```bash
flutter clean
flutter pub get
flutter run
```

---

## 📌 Tech Stack

* Flutter
* Dart
* Provider
* fl_chart
* Material Design 3

---

## 📄 Version

* v1.0.0
* Academic MIS Project
* Flutter SDK ≥ 3.0



