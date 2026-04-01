"""
Setup script for Letting Experts Assistant using cx_Freeze
"""

from cx_Freeze import setup, Executable
import sys

# Determine the build directory
build_exe_options = {
    "packages": ["tkinter"],
    "include_files": ["app.ico"],
    "excludes": [],
    "zip_include_packages": ["*"],
    "zip_exclude_packages": [],
}

# Target executable
base = None
if sys.platform == "win32":
    base = "Win32GUI"

executables = [
    Executable(
        script="letting_experts_app_v2.py",
        base=base,
        target_name="LettingExpertsAssistant",
        icon="app.ico",
        copyright="Letting Experts 2026",
    )
]

setup(
    name="Letting Experts Assistant",
    version="2.0.0",
    description="Assistant application for managing properties and clients",
    author="Letting Experts",
    options={"build_exe": build_exe_options},
    executables=executables,
)
