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

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

**Never commit the `.env` file to version control.**

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

## 🔐 Security

- Store sensitive credentials in GitHub Secrets for CI/CD
- Never commit `.env` files or signing keys
- Review privacy policies for all integrated services
- Use HTTPS for all API communication

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
