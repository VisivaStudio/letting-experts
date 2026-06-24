# Letting Experts - Property Booking Management App

A mobile app for property letting experts to manage enquiries from Property24 and facilitate property viewings through integrated calendar-based booking management.

## 📱 Overview

Letting Experts automates the process of handling property enquiries:
- Parse incoming Property24 enquiries
- Look up properties and availability
- Offer booking slots from your calendar
- Confirm bookings and notify enquirers via WhatsApp and email

## ✨ Features

- **Enquiry Management**: View and process incoming property enquiries
- **Calendar Integration**: Sync with Outlook or Google Calendar
- **Booking Management**: Create, view, and cancel property viewings
- **Real-time Notifications**: WhatsApp and email confirmations
- **Availability Management**: Block time slots for availability control

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11.0 or higher
- iOS 12.0+ / Android API 21+
- Supabase account (backend)
- Google or Outlook account (for calendar sync)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/VisivaStudio/letting-experts.git
   cd letting-experts
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

Then edit `.env` and fill in your actual credentials:

| Variable | Description | Where to find it |
|---|---|---|
| `SUPABASE_URL` | Your Supabase project URL | Supabase Dashboard → Settings → API |
| `SUPABASE_ANON_KEY` | Your Supabase anonymous key | Supabase Dashboard → Settings → API |
| `GOOGLE_CALENDAR_API_KEY` | Google Calendar API key (optional) | Google Cloud Console → Credentials |
| `OUTLOOK_CLIENT_ID` | Microsoft OAuth client ID (optional) | Azure Portal → App registrations |
| `WHATSAPP_BUSINESS_API_TOKEN` | WhatsApp Business API token (optional) | Meta Developer Portal |
| `WHATSAPP_BUSINESS_ACCOUNT_ID` | WhatsApp Business Account ID (optional) | Meta Developer Portal |
| `EMAIL_PROVIDER_KEY` | Email provider API key (optional) | Your email provider dashboard |
| `SENTRY_DSN` | Sentry DSN for crash reporting (optional) | Sentry → Project Settings |

**Never commit the `.env` file to version control.** It is listed in `.gitignore`.

## 📁 Project Structure

```
lib/
├── core/              # Core utilities, theme, API client
├── features/          # Feature modules (enquiries, bookings, calendar)
└── main.dart          # App entry point

ios/                   # iOS native code
android/               # Android native code
web/                   # Web platform (optional)
```

## 🛠️ Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Building for Release

**iOS:**
```bash
flutter build ios --release
```

**Android:**
```bash
flutter build apk --release
# or for Play Store bundle:
flutter build appbundle --release
```

## 🔐 Security & Secret Management

### CI/CD Secrets (GitHub Actions)

The CI workflow reads credentials from GitHub repository secrets. Set the following secrets in your repository under **Settings → Secrets and variables → Actions**:

| Secret | Description |
|---|---|
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | Your Supabase anonymous API key |

Do **not** hard-code these values in any script, workflow file, or source code.

### Android Signing Setup

For production Android builds:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```
2. Store `release.keystore` **outside** the repository (never commit it).
3. Add these GitHub Secrets for CI signing:
   - `ANDROID_KEYSTORE_BASE64` — Base64-encoded keystore file (`base64 -i release.keystore`)
   - `ANDROID_KEY_ALIAS` — Key alias used above
   - `ANDROID_KEY_PASSWORD` — Key password
   - `ANDROID_STORE_PASSWORD` — Keystore password
4. Reference `android/key.properties` (gitignored) locally:
   ```
   storePassword=<your-store-password>
   keyPassword=<your-key-password>
   keyAlias=release
   storeFile=../../release.keystore
   ```

`.keystore` and `.jks` files are already listed in `.gitignore`.

### iOS Signing Setup

For production iOS builds:

1. Export your distribution certificate and provisioning profile from Xcode or Apple Developer Portal.
2. Store them **outside** the repository (never commit `.p12`, `.cer`, or `.mobileprovision` files).
3. For CI, use [Fastlane Match](https://docs.fastlane.tools/actions/match/) or add these GitHub Secrets:
   - `IOS_CERTIFICATE_BASE64` — Base64-encoded `.p12` distribution certificate
   - `IOS_CERTIFICATE_PASSWORD` — Certificate password
   - `IOS_PROVISIONING_PROFILE_BASE64` — Base64-encoded `.mobileprovision` file
4. For local development, manage certificates via **Xcode → Settings → Accounts → Manage Certificates**.

The CI workflow uses `--no-codesign` for build validation. Apply signing only in a dedicated release workflow using the secrets above.

### General Rules

- Never commit `.env`, signing keys, API tokens, or certificates to version control.
- Rotate any credentials that were accidentally exposed.
- Review privacy policies for all integrated third-party services.
- Use HTTPS for all API communication.

## 📦 Dependencies

Key dependencies managed in `pubspec.yaml`:
- **Supabase**: Backend database and authentication
- **GoRouter**: Navigation and routing
- **Riverpod**: State management
- **Dio**: HTTP client for API requests
- **Google Maps Flutter**: Location and mapping
- **Cached Network Image**: Image caching

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Follow Flutter style guide and best practices
3. Run `flutter analyze` before committing
4. Submit a pull request with a clear description

## 📋 Checklist for Production

- [ ] All tests passing locally and in CI
- [ ] Security audit completed
- [ ] Environment variables configured for production
- [ ] App signing certificates prepared (iOS & Android)
- [ ] Privacy policy and terms of service ready
- [ ] Crash reporting configured (Sentry/Crashlytics)
- [ ] Analytics configured with user opt-in
- [ ] App store listings prepared (metadata, screenshots, description)

## 🐛 Reporting Issues

Found a bug? Please open an issue with:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Device and OS information

## 📄 License

[Specify your license here]

## 📞 Support

For questions or support, contact: [support email or link]

## 🔗 Links

- [Design Documentation](./docs/design.md)
- [API Documentation](./docs/api.md)
- [App Requirements](./docs/app_requirements.md)
