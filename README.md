# Learning Journey

A SwiftUI application that supports learners in developing consistent daily habits through progress tracking, streaks, and freeze days. Built following Apple's Human Interface Guidelines, the app combines motivation with simplicity to make learning both structured and engaging.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-lightgrey.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-blue.svg)

---

## Overview

Learning Journey empowers users to set learning goals and visualize their progress across flexible timeframes (week, month, or year). The interface integrates a clean calendar view, visual streak indicators, and a freeze-day system to help users stay consistent even during breaks.

---

## Key Features

### Goal Setting
- Create personalized learning goals by subject
- Choose learning duration: **Week** (7 days), **Month** (30 days), or **Year** (365 days)
- Automatic freeze allocation per duration (2, 8, or 96 days)

### Progress Tracking
- Weekly and monthly calendar views with smooth transitions
- Color-coded system for clear status visualization:
  - **Orange** – Current day
  - **Blue/Red** – Logged days
  - **Yellow** – Freeze days
  - **White** – Untracked days

### Streak & Freeze System
- Consecutive day tracking with a dynamic flame counter
- Auto-reset after 32 hours of inactivity
- Limited freeze use to promote balanced progress

### User Interface
- Glassmorphism-inspired design
- Optimized for dark mode
- Custom animations and transitions
- Reusable UI components for consistency


## Design System


<img width="1920" height="1080" alt="views" src="https://github.com/user-attachments/assets/d6fef570-d7d6-48c2-929a-3e85242cc84e" />

---

## Architecture

### MVVM Pattern
Organized into Model, ViewModel, and View layers for better scalability and clarity.

```
LearningJourney/
├── Model/
│   ├── LearnerModel.swift
│   └── DayModel.swift
├── ViewModel/
│   ├── ActivityViewModel.swift
│   ├── CalendarViewModel.swift
│   └── OnboardingViewModel.swift
├── Views/
│   ├── OnboardingView.swift
│   ├── ActivityView.swift
│   ├── CalendarView.swift
│   ├── CompactCalendarView.swift
│   ├── WeeklyCalendarView.swift
│   ├── MonthlyCalendarView.swift
│   ├── WelldoneView.swift
│   └── StreakFreezeView.swift
└── Assets.xcassets/
    └── Colors/
```

---

## Usage Flow

1. **Onboarding** – Define subject and learning duration
2. **Daily Logging** – Mark study or freeze days
3. **Progress Review** – Monitor weekly/monthly performance
4. **Completion** – Unlock "Well Done" screen
5. **Adjust Goals** – Edit learning focus anytime

---

## Learning Outcomes

Building this app strengthened my skills in:

- SwiftUI layout design and component structure
- State management using property wrappers (`@State`, `@Binding`, `@ObservedObject`)
- Implementing MVVM architecture for clarity and maintainability
- Applying Apple's Human Interface Guidelines for a consistent experience
- Developing reusable, scalable UI components
- Handling date logic and dynamic UI updates

---

## Author

**Farah Almozaini**  
Apple Developer Academy | Tuwaiq  
[LinkedIn](#) · [GitHub](#)

---

*Developed with SwiftUI, inspired by the journey of continuous learning.*
