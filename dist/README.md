# Letting Experts Assistant - Executable Build

## Overview

The **LettingExpertsAssistant** executable has been successfully built using **cx_Freeze** (instead of PyInstaller, due to Python environment limitations).

## Build Details

- **Executable**: `LettingExpertsAssistant` (5.6 MB)
- **Platform**: Linux x86-64
- **Type**: Standalone application (includes all dependencies)
- **Location**: `/dist/` directory

## Files Included

```
dist/
├── LettingExpertsAssistant      # Main executable (64-bit ELF binary)
├── app.ico                       # Application icon
├── frozen_application_license.txt  # License information
├── lib/                          # Python libraries and dependencies
└── share/                        # Additional resources
```

## Running the Application

To run the application on Linux:

```bash
cd dist
./LettingExpertsAssistant
```

Or directly:
```bash
/path/to/dist/LettingExpertsAssistant
```

## Features

The Letting Experts Assistant includes:

- **Properties Management**: Manage property listings and details
- **Clients Management**: Track client information and history
- **Messaging**: Integrated messaging system for client communication
- **Analytics**: View business metrics and reports
- **Settings**: Configure application preferences

## Distribution

This executable folder can be:
- Packaged as a .tar.gz archive for distribution
- Deployed on Linux systems with glibc 2.6.32+
- Integrated into deployment pipelines

### Create Archive for Distribution

```bash
cd /path/to
tar -czf LettingExpertsAssistant.tar.gz dist/
```

## Notes

- The application uses **tkinter** for the GUI (standard Python library)
- All dependencies are included in the `lib/` directory
- The executable is self-contained and portable across Linux systems with compatible glibc versions
- Due to environment constraints, **cx_Freeze** was used instead of **PyInstaller**

## Requirements

- Linux x86-64 system
- glibc 2.6.32 or later (most modern Linux distributions have this)

## Build Information

- Built with: **cx_Freeze 8.6.3**
- Python version: **3.12.1**
- Build date: April 1, 2026
