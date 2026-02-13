## Role-Based Authentication UI - Flutter Therapy App

This folder contains a clean, reusable authentication system for the Online Therapy App with role-based screens and widgets.

### Folder Structure

```
lib/screens/auth/
├── role_selection_screen.dart      # Role selection (Patient/Therapist)
├── login_screen.dart               # User login screen
├── signup_screen.dart              # User registration screen
└── widgets/
    ├── auth_text_field.dart        # Reusable text input field
    ├── auth_button.dart            # Reusable button widget
    └── role_card.dart              # Reusable role selection card
```

---

## Components Overview

### Screens

#### 1. **RoleSelectionScreen** (`role_selection_screen.dart`)
First screen users see when opening the app.

**Features:**
- App logo (psychology icon in purple circle)
- Title: "Continue as"
- Two selectable role cards (Patient / Therapist)
- Continue button (disabled until role selected)
- Soft, welcoming design

**Key Code Snippet:**
```dart
RoleCard(
  roleName: 'Patient',
  icon: Icons.favorite,
  description: 'Seeking therapy\nand mental health support',
  isSelected: selectedRole == 'patient',
  onTap: () {
    setState(() {
      selectedRole = 'patient';
    });
  },
),
```

---

#### 2. **LoginScreen** (`login_screen.dart`)
Users log in with existing credentials.

**Features:**
- Email field
- Password field with show/hide toggle
- Login button with loading state
- "Forgot Password?" link
- Link to Sign Up screen
- Back button

**Key Code Snippet:**
```dart
AuthTextField(
  label: 'Email',
  hintText: 'Enter your email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
),

AuthButton(
  label: 'Login',
  isLoading: isLoading,
  onPressed: () { /* login logic */ },
),
```

---

#### 3. **SignupScreen** (`signup_screen.dart`)
New users create an account.

**Features:**
- Full Name field
- Email field
- Password field with visibility toggle
- Confirm Password field
- Terms & Conditions checkbox
- Create Account button
- Link to Login screen
- Back button

**Key Code Snippet:**
```dart
AuthTextField(
  label: 'Full Name',
  hintText: 'Enter your full name',
  controller: fullNameController,
  keyboardType: TextInputType.name,
),

Checkbox(
  value: agreedToTerms,
  onChanged: (value) {
    setState(() {
      agreedToTerms = value ?? false;
    });
  },
  activeColor: const Color(0xFF7B68C0),
),
```

---

### Reusable Widgets

#### 1. **AuthTextField** (`widgets/auth_text_field.dart`)
Customizable text input field for all auth forms.

**Parameters:**
- `label` - Field label text
- `hintText` - Placeholder hint
- `controller` - TextEditingController
- `isPassword` - For password fields (adds show/hide toggle)
- `keyboardType` - Keyboard type (email, phone, etc.)

**Usage:**
```dart
AuthTextField(
  label: 'Email',
  hintText: 'Enter your email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
)
```

**Features:**
- Soft light background (#F5F7FA)
- Purple focus border (#7B68C0)
- Clear label above input
- Password visibility toggle (for password fields)
- Rounded corners (12px)

---

#### 2. **AuthButton** (`widgets/auth_button.dart`)
Consistent button widget used across all screens.

**Parameters:**
- `label` - Button text
- `onPressed` - Callback function
- `isLoading` - Show loading spinner
- `backgroundColor` - Optional custom color
- `textColor` - Optional custom text color
- `width` - Optional custom width (default: full width)

**Usage:**
```dart
AuthButton(
  label: 'Login',
  isLoading: isLoading,
  onPressed: () {
    // Handle login
  },
)
```

**Features:**
- Soft purple background (#7B68C0)
- Loading state with spinner
- 56px height (accessibility standard)
- Rounded corners (12px)
- Subtle shadow for depth

---

#### 3. **RoleCard** (`widgets/role_card.dart`)
Interactive card for selecting user role.

**Parameters:**
- `roleName` - Role name (Patient/Therapist)
- `icon` - Icon data
- `isSelected` - Selection state
- `onTap` - Callback when tapped
- `description` - Role description text

**Usage:**
```dart
RoleCard(
  roleName: 'Patient',
  icon: Icons.favorite,
  description: 'Seeking therapy support',
  isSelected: selectedRole == 'patient',
  onTap: () {
    setState(() {
      selectedRole = 'patient';
    });
  },
)
```

**Features:**
- Circular icon container (64x64)
- Selection visual feedback (purple border + light background)
- Smooth shadow effect on selection
- Light blue/gray icon when not selected
- Purple icon when selected

---

## Color Palette

The UI uses soft, calming colors suitable for a mental health app:

| Purpose | Color | Hex |
|---------|-------|-----|
| Primary (Purple) | Soft Purple | `#7B68C0` |
| Text (Dark) | Dark Blue-Gray | `#2C3E50` |
| Text (Light) | Medium Gray-Blue | `#5A6B7E` |
| Border | Light Gray | `#E0E6ED` |
| Background (Light) | Soft White | `#F5F7FA` |
| Background (Page) | Very Light Blue | `#FCFDFE` |
| Icon Background | Light Purple | `#D0C4E8` |
| Hover/Focus Background | Very Light Purple | `#F0EBF8` |

---

## Spacing Standards

Consistent spacing throughout the app:

- **Vertical spacing between sections**: 24-48px
- **Vertical spacing between form fields**: 16px
- **Padding (horizontal)**: 24px
- **Border radius**: 12-16px
- **Icon size**: 32-48px
- **Button height**: 56px

---

## How to Use

### 1. Basic Integration

```dart
import 'package:fyp_therapy/screens/auth/role_selection_screen.dart';

// In your main.dart or route definition
MaterialApp(
  home: RoleSelectionScreen(),
)
```

### 2. Navigation Between Screens

Update the TODO comments in each screen:

**RoleSelectionScreen:**
```dart
onPressed: selectedRole == null
    ? () {}
    : () {
        // Navigate based on role
        if (selectedRole == 'patient') {
          Navigator.push(context, 
            MaterialPageRoute(builder: (_) => PatientLoginScreen()));
        } else {
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => TherapistLoginScreen()));
        }
      },
```

**LoginScreen:**
```dart
// Sign up link
GestureDetector(
  onTap: () {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => SignupScreen()));
  },
  child: const Text('Sign Up'),
),
```

**SignupScreen:**
```dart
// Log in link
GestureDetector(
  onTap: () {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => LoginScreen()));
  },
  child: const Text('Log In'),
),
```

### 3. Add Form Validation (When Needed)

```dart
// In LoginScreen
AuthTextField(
  label: 'Email',
  hintText: 'Enter your email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
)

// Later: Validate before submitting
if (emailController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Email is required')),
  );
  return;
}
```

### 4. Connect to Backend (When Needed)

```dart
// In LoginScreen onPressed
setState(() => isLoading = true);

try {
  // Example Firebase call
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
  
  // Navigate to home screen
  Navigator.pop(context);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Login failed: $e')),
  );
} finally {
  setState(() => isLoading = false);
}
```

---

## Code Guidelines Followed

✅ **Clean & Simple**: Each file is focused and short (< 150 lines)  
✅ **Reusable**: Widgets are generic and used across multiple screens  
✅ **Beginner-Friendly**: Clear comments, simple logic, no complex patterns  
✅ **UI-Only**: No validation, no backend, no state management (yet)  
✅ **Mental Health Focused**: Soft colors, spacious layout, welcoming design  
✅ **Accessible**: Good contrast, 56px button height, clear text hierarchy  

---

## Next Steps

To complete the authentication system, add:

1. **Form Validation**: Email format, password strength
2. **Backend Integration**: Firebase/Django API calls
3. **State Management**: GetX/Provider for app-wide state
4. **Error Handling**: Better error messages and recovery
5. **Loading States**: More visual feedback during auth
6. **Remember Me**: Persistent login option
7. **Social Auth**: Google/Apple sign-in buttons

---

## File Sizes

| File | Lines | Purpose |
|------|-------|---------|
| `role_selection_screen.dart` | ~95 | Role selection UI |
| `login_screen.dart` | ~135 | Login form |
| `signup_screen.dart` | ~155 | Registration form |
| `auth_text_field.dart` | ~90 | Reusable input field |
| `auth_button.dart` | ~55 | Reusable button |
| `role_card.dart` | ~70 | Reusable role card |

**Total: ~600 lines** - Clean, maintainable, and easy to understand!

---

Enjoy building your therapy app! 💜
