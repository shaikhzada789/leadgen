# 🚀 LeadGen Connect MIS — Flutter App

## پروجیکٹ کیا ہے؟
LeadGen Connect ایک **پیشہ ورانہ Lead Management Information System** ہے جو Flutter میں بنا ہے۔ یہ 3-tier RBAC (Role-Based Access Control) system ہے جس میں Sales Agent, Manager اور Executive کے مختلف dashboards ہیں۔

---

## 📱 Screens (20 اسکرینز)

| Screen | نام | کیا ہوتا ہے |
|--------|-----|------------|
| 0 | Onboarding | Game جیسی tutorial — بتاتا ہے کہاں کیا دبانا ہے |
| 1 | Authentication | RBAC role select کرو |
| 2 | Agent Dashboard | Pipeline overview |
| 3 | Lead Form | نئی lead register کرو |
| 4 | Active Queue | Lead roster |
| 5 | Lead Profiler | Lead detail view |
| 6 | Status Update | Log calls, chats |
| 7 | Block Screen | Document کے بغیر BLOCKED |
| 8 | Document Upload | Contract upload |
| 9-10 | Pending State | Manager approval wait |
| 11 | Manager Dashboard | Approval queue |
| 12 | Pending Queue | Review file button |
| 13 | Contract Review | Document verify |
| 14 | Success/Reject | Deal close ya reject |
| 15 | Team Performance | Agent win rates |
| 16 | Executive Dashboard | Strategic DSS view |
| 17 | Analytics Charts | Bar + Pie charts |
| 18 | AI Predictions | Win probability model |
| 19 | Audit Trail | Immutable system logs |
| 20 | Session End | Logout |

---

## 🛠️ Setup — VS Code میں چلانے کا طریقہ

### Step 1: Flutter Install کرو
1. https://flutter.dev/docs/get-started/install سے Flutter SDK download کرو
2. Path set کرو:
   ```
   Windows: System Variables > PATH > flutter/bin add کرو
   Mac/Linux: export PATH="$PATH:/path/to/flutter/bin"
   ```
3. Check: `flutter doctor` — سب green ہونے چاہیے

### Step 2: VS Code Setup
1. VS Code open کرو
2. Extensions install کرو:
   - **Flutter** (by Dart Code)
   - **Dart** (by Dart Code)

### Step 3: Project Open کرو
1. VS Code میں: `File > Open Folder`
2. `leadgen_connect` folder select کرو

### Step 4: Packages Install کرو
VS Code terminal میں:
```bash
flutter pub get
```

### Step 5: Device Connect کرو
**Android:**
- Android Studio install کرو
- AVD Manager > Create Virtual Device
- یا real phone: Developer Options > USB Debugging ON

**iOS (Mac only):**
- Xcode install کرو
- Simulator open کرو

### Step 6: Run کرو!
```bash
flutter run
```
یا VS Code میں `F5` دباؤ

---

## 🎮 App کیسے Use کریں

### Tutorial (پہلی بار)
1. App کھلتے ہی **5 onboarding slides** آتی ہیں
2. ہر slide پر **سبز hint box** ہوتا ہے — وہ پڑھو
3. "Agla Step →" دباتے جاؤ
4. آخر میں "Shuru Karo 🚀" دباؤ

---

### 🔵 Sales Agent (Daniyal) کا Flow:
```
Login > Agent Dashboard > "New Lead" FAB دباؤ
> Form fill کرو > "Save to Database"
> Lead list میں lead آئے گی
> Lead tap کرو > "Log Call" > "Log Chat"
> "Mark Closed-Won" دباؤ
> ⚠️ BLOCKED ہوگا اگر document نہیں!
> "Upload Doc" دباؤ > دوبارہ "Mark Closed-Won"
> Status "Pending Verify" ہوجائے گا
```

---

### 🟣 Sales Manager کا Flow:
```
Login > Manager Dashboard > "Pending" tab
> Lead card پر "Review File" دباؤ
> Contract screen آئے گی
> "Approve & Close" > ✅ Success dialog
> یا "Reject Contract" > ❌ Lead lost
```

---

### 🟡 Executive کا Flow:
```
Login > Executive Dashboard
> "Strategic" tab — KPIs دیکھو
> "Analytics" tab — Bar chart + Pie chart
> "AI Forecast" tab — Win probability
> "Audit" tab — Immutable logs دیکھو
```

---

## 📁 Project Structure

```
leadgen_connect/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── theme/
│   │   └── app_theme.dart           # Dark glassmorphism theme
│   ├── models/
│   │   └── lead_model.dart          # Data models
│   ├── utils/
│   │   └── app_state.dart           # State management (Provider)
│   ├── widgets/
│   │   └── glass_widgets.dart       # Reusable glass components
│   └── screens/
│       ├── onboarding_screen.dart   # Tutorial (Screen 0)
│       ├── auth_screen.dart         # Login (Screen 1)
│       ├── agent_dashboard.dart     # Agent (Screens 2-4)
│       ├── lead_form_screen.dart    # New Lead (Screen 3)
│       ├── lead_detail_screen.dart  # Lead Detail (Screens 5-10)
│       ├── manager_dashboard.dart   # Manager (Screens 11-15)
│       ├── contract_review_screen.dart # Review (Screens 12-14)
│       └── executive_dashboard.dart # Executive (Screens 16-20)
├── pubspec.yaml
└── README.md
```

---

## ✨ Features

- 🌙 **Dark Glassmorphism UI** — professional look
- 🎮 **Interactive Onboarding** — step-by-step tutorial
- 🔒 **RBAC System** — 3 different role-based dashboards
- 📊 **Interactive Charts** — Bar charts, Pie charts (fl_chart)
- 🤖 **AI Predictions** — Mock ML model with win probabilities
- 📋 **Immutable Audit Trail** — Every action logged
- ⚡ **Business Rules** — Document required before closing
- 💾 **State Management** — Provider pattern

---

## ⚠️ Common Issues

**`flutter pub get` fail:**
→ Internet check کرو, VPN try کرو

**Black screen on device:**
→ `flutter clean && flutter pub get && flutter run`

**"No devices found":**
→ Android: USB debugging on کرو
→ iOS: Trust computer on iPhone

---

**Version:** 1.0.0  
**Flutter SDK:** ≥3.0.0  
**Built for:** LeadGen Connect MIS Academic Project
