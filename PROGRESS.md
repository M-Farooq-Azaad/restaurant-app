# Restaurant App — Development Progress

## Overview
Flutter frontend-only app with mock data. Design: glassmorphism, gold accent, DM Serif Display + DM Sans fonts.

---

## Completed

### ✅ Session 1 — Project Setup + Auth Screens

#### Project Setup
- `pubspec.yaml` — dependencies: `flutter_riverpod`, `go_router`, `google_fonts`, `flutter_animate`, `pinput`, `shared_preferences`, `shimmer`, `smooth_page_indicator`, `intl`, `uuid`, `equatable`
- `assets/` folder structure: `images/`, `icons/`, `mock/`

#### Core / Foundation
| File | Description |
|---|---|
| `lib/core/constants/app_colors.dart` | All color tokens — light mode, dark mode, gold gradient |
| `lib/core/constants/app_spacing.dart` | `Sp` spacing constants + `Rd` radius constants |
| `lib/core/constants/app_text_styles.dart` | Full type scale using GoogleFonts DM Serif Display + DM Sans |
| `lib/core/theme/app_theme_extension.dart` | `AppColorsExtension` ThemeExtension (light + dark), `context.colors` shorthand |
| `lib/core/theme/app_theme.dart` | `ThemeData` for light and dark modes |
| `lib/core/theme/theme_provider.dart` | Riverpod `ThemeNotifier` — persists to SharedPreferences |
| `lib/core/routing/app_router.dart` | GoRouter with splash → login/register/otp → home flow |
| `lib/main.dart` | App entry — `ProviderScope`, `MaterialApp.router`, theme binding |

#### Shared Widgets
| File | Description |
|---|---|
| `lib/core/widgets/buttons/primary_button.dart` | Gold gradient button, 56dp, loading state, disabled state |
| `lib/core/widgets/inputs/app_text_field.dart` | Animated label, focus border, error border, password toggle |

#### Mock Layer
| File | Description |
|---|---|
| `lib/mock/mock_data.dart` | `MockUser` model + `MockData.currentUser` (Hassan Ali, Gold tier) |

#### Auth Feature
| File | Description |
|---|---|
| `lib/features/auth/providers/auth_provider.dart` | `AuthNotifier` — login (email + phone), OTP verify, register, logout. All mock. |
| `lib/features/auth/screens/splash_screen.dart` | Logo fade+scale in, redirects after 2s (logged-in → home, else → login) |
| `lib/features/auth/screens/login_screen.dart` | Email + Phone tabs, form validation, social buttons, forgot password link |
| `lib/features/auth/screens/register_screen.dart` | Full registration form, optional section toggle, referral code, terms |
| `lib/features/auth/screens/otp_screen.dart` | Pinput 6-digit, countdown timer (60s), resend OTP, auto-submit on 6th digit |

#### Home Placeholder
| File | Description |
|---|---|
| `lib/features/home/screens/home_screen.dart` | Placeholder — "coming soon" (full Home Screen is next) |

---

## In Progress / Next Up

### 🔲 Home Screen (next)
- Loyalty summary card (glass, gold gradient)
- Quick actions grid
- Promo carousel (auto-scroll)
- Today's Picks & Best Sellers horizontal scrolls
- Gamification nudge card
- Bottom navigation bar shell

### 🔲 Menu Screen
### 🔲 Cart Screen
### 🔲 Order Tracking Screen
### 🔲 Loyalty Screen
### 🔲 Profile Screen
### 🔲 Wallet Screen
### 🔲 All other screens (see blueprint)

---

## Mock Behavior Notes
- Login: any email + password (min 6 chars) → success
- Phone OTP: any 6-digit code → success
- Register: any valid form → success
- Auth state persisted via `SharedPreferences` key `logged_in`

---

## Git Workflow
- Push after each screen is completed
- Branch: `main`
- Repo: https://github.com/mfaju/restaurant_app *(update if different)*
