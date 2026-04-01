#!/usr/bin/env python3
"""
Letting Experts Assistant - Desktop Application
A GUI application for managing property listings and client communications.
"""

import tkinter as tk
from tkinter import ttk, messagebox
import sys
from pathlib import Path

class LettingExpertsAssistant:
    """Main application class for Letting Experts Assistant."""
    
    def __init__(self, root):
        self.root = root
        self.root.title("Letting Experts Assistant")
        self.root.geometry("800x600")
        self.root.resizable(True, True)
        
        # Configure style
        style = ttk.Style()
        style.theme_use('clam')
        
        # Create main frame
        self.main_frame = ttk.Frame(root, padding="10")
        self.main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        root.columnconfigure(0, weight=1)
        root.rowconfigure(0, weight=1)
        self.main_frame.columnconfigure(0, weight=1)
        self.main_frame.rowconfigure(1, weight=1)
        
        # Header
        header_frame = ttk.Frame(self.main_frame)
        header_frame.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        
        title_label = ttk.Label(
            header_frame,
            text="Letting Experts Assistant",
            font=("Helvetica", 16, "bold")
        )
        title_label.pack(side=tk.LEFT)
        
        # Menu buttons frame
        menu_frame = ttk.Frame(self.main_frame)
        menu_frame.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        
        # Create menu buttons
        buttons = [
            ("Properties", self.show_properties),
            ("Clients", self.show_clients),
            ("Messages", self.show_messages),
            ("Analytics", self.show_analytics),
            ("Settings", self.show_settings),
        ]
        
        for idx, (text, cmd) in enumerate(buttons):
            btn = ttk.Button(
                menu_frame,
                text=text,
                command=cmd,
                width=20
            )
            btn.grid(row=idx, column=0, sticky=(tk.W, tk.E), pady=5)
        
        # Content frame
        self.content_frame = ttk.Frame(self.main_frame)
        self.content_frame.grid(row=2, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        
        # Status bar
        status_frame = ttk.Frame(self.main_frame)
        status_frame.grid(row=3, column=0, sticky=(tk.W, tk.E), pady=(10, 0))
        
        self.status_var = tk.StringVar(value="Ready")
        status_label = ttk.Label(status_frame, textvariable=self.status_var, relief=tk.SUNKEN)
        status_label.pack(side=tk.LEFT, fill=tk.X, expand=True)
    
    def clear_content(self):
        """Clear the content frame."""
        for widget in self.content_frame.winfo_children():
            widget.destroy()
    
    def show_properties(self):
        """Show properties management section."""
        self.clear_content()
        self.status_var.set("Viewing Properties")
        
        label = ttk.Label(
            self.content_frame,
            text="Property Management",
            font=("Helvetica", 12, "bold")
        )
        label.pack(pady=10)
        
        text = ttk.Label(
            self.content_frame,
            text="Manage your property listings here.\nView, edit, and create new property entries."
        )
        text.pack(pady=5)
    
    def show_clients(self):
        """Show clients management section."""
        self.clear_content()
        self.status_var.set("Viewing Clients")
        
        label = ttk.Label(
            self.content_frame,
            text="Client Management",
            font=("Helvetica", 12, "bold")
        )
        label.pack(pady=10)
        
        text = ttk.Label(
            self.content_frame,
            text="Manage your clients and their information.\nTrack contact details and communication history."
        )
        text.pack(pady=5)
    
    def show_messages(self):
        """Show messaging section."""
        self.clear_content()
        self.status_var.set("Viewing Messages")
        
        label = ttk.Label(
            self.content_frame,
            text="Messaging",
            font=("Helvetica", 12, "bold")
        )
        label.pack(pady=10)
        
        text = ttk.Label(
            self.content_frame,
            text="View and send messages to clients and colleagues.\nIntegrated communication platform."
        )
        text.pack(pady=5)
    
    def show_analytics(self):
        """Show analytics section."""
        self.clear_content()
        self.status_var.set("Viewing Analytics")
        
        label = ttk.Label(
            self.content_frame,
            text="Analytics & Reports",
            font=("Helvetica", 12, "bold")
        )
        label.pack(pady=10)
        
        text = ttk.Label(
            self.content_frame,
            text="View analytics, reports, and performance metrics.\nTrack key business indicators."
        )
        text.pack(pady=5)
    
    def show_settings(self):
        """Show settings section."""
        self.clear_content()
        self.status_var.set("Viewing Settings")
        
        label = ttk.Label(
            self.content_frame,
            text="Settings",
            font=("Helvetica", 12, "bold")
        )
        label.pack(pady=10)
        
        text = ttk.Label(
            self.content_frame,
            text="Configure application settings and preferences.\nManage user account and notifications."
        )
        text.pack(pady=5)


def main():
    """Main entry point for the application."""
    root = tk.Tk()
    app = LettingExpertsAssistant(root)
    
    # Show welcome message
    root.after(500, lambda: messagebox.showinfo(
        "Welcome",
        "Welcome to Letting Experts Assistant!\n\nSelect an option from the menu to get started."
    ))
    
    root.mainloop()


if __name__ == "__main__":
    main()
