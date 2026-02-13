## Quick Reference - Auth System

### 📁 Folder Structure Created

```
lib/screens/auth/
├── README.md                       ← Full documentation
├── examples_usage.dart             ← Integration examples
├── role_selection_screen.dart      ← First screen (role choice)
├── login_screen.dart               ← Login form
├── signup_screen.dart              ← Registration form
└── widgets/
    ├── auth_text_field.dart        ← Text input field
    ├── auth_button.dart            ← Action button
    └── role_card.dart              ← Role selection card
```

---

### 🎨 Design System

**Color Palette:**
- Primary: `#7B68C0` (Soft Purple)
- Dark Text: `#2C3E50`
- Light Text: `#5A6B7E`
- Backgrounds: `#FCFDFE`, `#F5F7FA`

**Spacing:**
- Page padding: 24px
- Section gap: 24-48px
- Field gap: 16px
- Border radius: 12-16px

**Typography:**
- Headline: 28px bold (#2C3E50)
- Body: 16px regular (#5A6B7E)
- Labels: 14px semi-bold (#5A6B7E)

---

### 🚀 Quick Start

1. **Import any screen:**
   ```dart
   import 'package:fyp_therapy/screens/auth/role_selection_screen.dart';
   ```

2. **Set as home screen:**
   ```dart
   MaterialApp(
     home: const RoleSelectionScreen(),
   )
   ```

3. **Add navigation between screens** (see examples_usage.dart)

---

### 📦 Reusable Widgets

#### AuthTextField
```dart
AuthTextField(
  label: 'Email',
  hintText: 'Enter your email',
  controller: emailController,
  isPassword: false,  // Set true for password fields
  keyboardType: TextInputType.emailAddress,
)
```

#### AuthButton
```dart
AuthButton(
  label: 'Login',
  isLoading: isLoading,
  onPressed: () { /* action */ },
)
```

#### RoleCard
```dart
RoleCard(
  roleName: 'Patient',
  icon: Icons.favorite,
  description: 'Seeking therapy support',
  isSelected: isSelected,
  onTap: () { /* select role */ },
)
```

---

### ✅ Features Included

**RoleSelectionScreen:**
- Logo display
- Two role options (Patient/Therapist)
- Selection state management
- Continue button (disabled until selection)

**LoginScreen:**
- Email & password fields
- Show/hide password toggle
- Forgot password link
- Sign up navigation
- Loading state

**SignupScreen:**
- Full name, email, password fields
- Password confirmation
- Terms & conditions checkbox
- Loading state
- Login navigation

**Reusable Components:**
- Text fields with focus states
- Buttons with loading spinners
- Role selection cards with visual feedback

---

### 📝 Total Code Breakdown

| Component | Lines | Status |
|-----------|-------|--------|
| Role Selection | 95 | ✅ Complete |
| Login | 135 | ✅ Complete |
| Signup | 155 | ✅ Complete |
| AuthTextField | 90 | ✅ Complete |
| AuthButton | 55 | ✅ Complete |
| RoleCard | 70 | ✅ Complete |
| **Total** | **~600** | **✅ Ready** |

---

### 🔧 None Yet - These Are UI Only

- ❌ Backend integration
- ❌ Form validation
- ❌ State management
- ❌ Authentication logic
- ❌ Error handling

**Add these next!** See examples_usage.dart for how.

---

### 🎯 Next Steps

1. ✅ **Auth UI Created** - You are here!
2. ⏭️ Connect to Firebase/Backend
3. ⏭️ Add form validation
4. ⏭️ Add state management (GetX/Provider)
5. ⏭️ Create patient dashboard
6. ⏭️ Create therapist dashboard

---

### 🔗 File Import Reference

```dart
// Import individual screens
import 'package:fyp_therapy/screens/auth/role_selection_screen.dart';
import 'package:fyp_therapy/screens/auth/login_screen.dart';
import 'package:fyp_therapy/screens/auth/signup_screen.dart';

// Import reusable widgets
import 'package:fyp_therapy/screens/auth/widgets/auth_text_field.dart';
import 'package:fyp_therapy/screens/auth/widgets/auth_button.dart';
import 'package:fyp_therapy/screens/auth/widgets/role_card.dart';
```

---

### 💡 Code Quality Checklist

- ✅ Clean code - short, focused files
- ✅ Reusable - widgets used across screens
- ✅ Beginner-friendly - simple patterns
- ✅ Commented - clear sections
- ✅ UI-only - no complex logic
- ✅ Accessible - good spacing, contrast
- ✅ Mental health focused - soft colors

---

### 🎨 Customization Tips

**Change primary color:**
Replace `#7B68C0` with your color hex

**Change text color:**
Update `Color(0xFF2C3E50)` values

**Adjust spacing:**
Modify `EdgeInsets` and `SizedBox` values

**Update fonts:**
Add to pubspec.yaml and use `fontFamily`

**Add animations:**
Wrap widgets in `AnimatedContainer`, `ScaleTransition`, etc.

---

### ❓ Troubleshooting

**TextField not showing?**
- Ensure TextEditingController is initialized in initState

**Button too big/small?**
- Adjust `height: 56` in AuthButton

**Colors don't match design?**
- Check hex codes in ColorS - RGB conversion

**Navigation not working?**
- Verify imports are correct
- Use Navigator.push/pop properly

---

### 📖 Full Documentation

See **README.md** for:
- Detailed component explanations
- Parameter descriptions
- Integration examples
- Backend integration samples
- Design guidelines
- File organization

---

### 🎉 You're Ready to Build!

All auth screens + widgets are ready to use. 
Next: Add navigation & backend integration! 💜
