#!/usr/bin/env python3
"""
Apple App Store Deployment AI Agent
Interactive assistant that guides you through the entire deployment process.
"""

import os
import sys
import json
import subprocess
from datetime import datetime
from pathlib import Path

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class DeploymentAgent:
    def __init__(self):
        self.project_root = Path.cwd()
        self.state_file = self.project_root / '.deployment_state.json'
        self.state = self.load_state()

    def load_state(self):
        """Load deployment progress state"""
        if self.state_file.exists():
            with open(self.state_file, 'r') as f:
                return json.load(f)
        return {
            'current_stage': 0,
            'completed_tasks': [],
            'version': None,
            'build_number': None,
            'bundle_id': None,
            'started_at': None
        }

    def save_state(self):
        """Save deployment progress state"""
        with open(self.state_file, 'w') as f:
            json.dump(self.state, f, indent=2)

    def print_header(self, text):
        """Print section header"""
        print(f"\n{Colors.BOLD}{Colors.CYAN}{'=' * 60}{Colors.END}")
        print(f"{Colors.BOLD}{Colors.CYAN}{text}{Colors.END}")
        print(f"{Colors.BOLD}{Colors.CYAN}{'=' * 60}{Colors.END}\n")

    def print_success(self, text):
        """Print success message"""
        print(f"{Colors.GREEN}✅ {text}{Colors.END}")

    def print_error(self, text):
        """Print error message"""
        print(f"{Colors.RED}❌ {text}{Colors.END}")

    def print_warning(self, text):
        """Print warning message"""
        print(f"{Colors.YELLOW}⚠️  {text}{Colors.END}")

    def print_info(self, text):
        """Print info message"""
        print(f"{Colors.BLUE}ℹ️  {text}{Colors.END}")

    def ask_yes_no(self, question):
        """Ask yes/no question"""
        while True:
            response = input(f"{Colors.CYAN}❓ {question} (y/n): {Colors.END}").lower()
            if response in ['y', 'yes']:
                return True
            elif response in ['n', 'no']:
                return False
            else:
                print("Please answer 'y' or 'n'")

    def ask_input(self, question, default=None):
        """Ask for text input"""
        if default:
            prompt = f"{Colors.CYAN}❓ {question} [{default}]: {Colors.END}"
        else:
            prompt = f"{Colors.CYAN}❓ {question}: {Colors.END}"

        response = input(prompt).strip()
        return response if response else default

    def run_command(self, command, capture=True):
        """Run shell command"""
        try:
            if capture:
                result = subprocess.run(
                    command,
                    shell=True,
                    capture_output=True,
                    text=True,
                    cwd=self.project_root
                )
                return result.returncode == 0, result.stdout, result.stderr
            else:
                result = subprocess.run(
                    command,
                    shell=True,
                    cwd=self.project_root
                )
                return result.returncode == 0, "", ""
        except Exception as e:
            return False, "", str(e)

    def check_file_exists(self, path):
        """Check if file exists"""
        full_path = self.project_root / path
        return full_path.exists()

    def read_file(self, path):
        """Read file content"""
        full_path = self.project_root / path
        if full_path.exists():
            with open(full_path, 'r') as f:
                return f.read()
        return None

    def get_version_from_pubspec(self):
        """Extract version from pubspec.yaml"""
        content = self.read_file('pubspec.yaml')
        if content:
            for line in content.split('\n'):
                if line.startswith('version:'):
                    version_str = line.split('version:')[1].strip()
                    parts = version_str.split('+')
                    if len(parts) == 2:
                        return parts[0], parts[1]
        return None, None

    def stage_1_welcome(self):
        """Stage 1: Welcome and prerequisites"""
        self.print_header("🚀 Apple App Store Deployment AI Agent")

        print("Welcome! I'll guide you through deploying Odyseya to the Apple App Store.")
        print("This interactive process will take approximately 4-6 hours for first deployment.\n")

        if self.state['started_at']:
            print(f"You started this deployment on: {self.state['started_at']}")
            if not self.ask_yes_no("Do you want to continue from where you left off?"):
                self.state = {
                    'current_stage': 0,
                    'completed_tasks': [],
                    'version': None,
                    'build_number': None,
                    'bundle_id': None,
                    'started_at': datetime.now().isoformat()
                }
                self.save_state()
        else:
            self.state['started_at'] = datetime.now().isoformat()
            self.save_state()

        print("\n📋 Prerequisites Check:")
        print("="  * 60)

        # Check Apple Developer Account
        if self.ask_yes_no("Do you have an active Apple Developer Account ($99/year)?"):
            self.print_success("Apple Developer Account confirmed")
        else:
            self.print_error("You need an Apple Developer Account to continue")
            self.print_info("Sign up at: https://developer.apple.com/programs/enroll/")
            return False

        # Check 2FA
        if self.ask_yes_no("Is Two-Factor Authentication (2FA) enabled on your Apple ID?"):
            self.print_success("2FA confirmed")
        else:
            self.print_warning("You need to enable 2FA")
            self.print_info("Enable at: https://appleid.apple.com")
            return False

        # Check Xcode
        success, stdout, _ = self.run_command("xcodebuild -version")
        if success:
            version = stdout.split('\n')[0] if stdout else "Unknown"
            self.print_success(f"Xcode installed: {version}")
        else:
            self.print_error("Xcode not found")
            return False

        # Check Flutter
        success, stdout, _ = self.run_command("flutter --version")
        if success:
            version = stdout.split('\n')[0] if stdout else "Unknown"
            self.print_success(f"Flutter installed: {version}")
        else:
            self.print_error("Flutter not found")
            return False

        print("\n✅ All prerequisites met! Ready to continue.\n")
        return True

    def stage_2_assets_preparation(self):
        """Stage 2: Assets and configuration"""
        self.print_header("📱 Stage 2: Assets & Configuration")

        print("Let's check your app assets and configuration.\n")

        # Check App Icon
        print("1️⃣  App Icon Check:")
        icon_path = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
        if self.check_file_exists(icon_path):
            # Count PNG files
            icon_dir = self.project_root / icon_path
            png_count = len(list(icon_dir.glob("*.png")))

            if png_count >= 10:
                self.print_success(f"App Icon found ({png_count} images)")
            else:
                self.print_warning(f"Only {png_count} icon images found (need ~15)")
                self.print_info("Generate all sizes at: https://appicon.co/")
                if not self.ask_yes_no("Continue anyway?"):
                    return False
        else:
            self.print_error("AppIcon.appiconset not found")
            self.print_info("Create app icons at: https://appicon.co/")
            return False

        # Check Screenshots
        print("\n2️⃣  Screenshots:")
        self.print_info("You need at least 3 screenshots for:")
        self.print_info("  • iPhone 6.7\" (1290 x 2796 pixels)")
        self.print_info("  • iPhone 6.5\" (1242 x 2688 pixels)")
        self.print_info("  • iPad Pro 12.9\" (2048 x 2732 pixels) - optional")

        if self.ask_yes_no("Have you prepared screenshots?"):
            self.print_success("Screenshots confirmed")
        else:
            self.print_warning("You'll need screenshots before final submission")
            self.print_info("Tip: Run app on simulator, press Cmd+S to save screenshot")

        # Check Version
        print("\n3️⃣  Version Configuration:")
        version, build = self.get_version_from_pubspec()

        if version and build:
            self.print_success(f"Current version: {version} (build {build})")
            self.state['version'] = version
            self.state['build_number'] = build
            self.save_state()

            if not self.ask_yes_no(f"Is version {version}+{build} correct for this release?"):
                new_version = self.ask_input("Enter new version (e.g., 1.0.0)", version)
                new_build = self.ask_input("Enter new build number (e.g., 1)", build)

                self.print_info(f"Please update pubspec.yaml to: version: {new_version}+{new_build}")
                input("Press Enter after updating pubspec.yaml...")
        else:
            self.print_error("Could not read version from pubspec.yaml")
            return False

        # Check Bundle ID
        print("\n4️⃣  Bundle Identifier:")
        default_bundle = "com.odyseya.app"
        bundle_id = self.ask_input("Enter your Bundle ID", default_bundle)
        self.state['bundle_id'] = bundle_id
        self.save_state()

        self.print_success(f"Bundle ID: {bundle_id}")

        # Check Info.plist
        print("\n5️⃣  Info.plist Privacy Descriptions:")
        info_plist_path = "ios/Runner/Info.plist"

        if self.check_file_exists(info_plist_path):
            content = self.read_file(info_plist_path)

            required_keys = [
                ("NSMicrophoneUsageDescription", "Microphone"),
                ("NSUserNotificationsUsageDescription", "Notifications"),
            ]

            all_found = True
            for key, name in required_keys:
                if key in content:
                    self.print_success(f"{name} description found")
                else:
                    self.print_error(f"{name} description missing: {key}")
                    all_found = False

            if not all_found:
                self.print_warning("Add missing descriptions to ios/Runner/Info.plist")
                if not self.ask_yes_no("Continue anyway?"):
                    return False
        else:
            self.print_error("Info.plist not found")
            return False

        # Check Privacy Policy
        print("\n6️⃣  Privacy Policy:")
        privacy_url = self.ask_input(
            "Enter your Privacy Policy URL (required by Apple)",
            "https://yoursite.com/privacy"
        )

        if "yoursite.com" in privacy_url or not privacy_url.startswith("http"):
            self.print_warning("You need a real Privacy Policy URL before submission")
            self.print_info("Use generator: https://www.privacypolicygenerator.info/")
        else:
            self.print_success(f"Privacy Policy: {privacy_url}")

        print("\n✅ Assets and configuration check complete!")
        return True

    def stage_3_build_preparation(self):
        """Stage 3: Build preparation"""
        self.print_header("🔨 Stage 3: Build Preparation")

        print("Let's prepare your app for building.\n")

        if self.ask_yes_no("Run automated build preparation script?"):
            self.print_info("Running flutter clean...")
            success, _, _ = self.run_command("flutter clean", capture=False)
            if success:
                self.print_success("Clean complete")

            self.print_info("Running flutter pub get...")
            success, _, _ = self.run_command("flutter pub get", capture=False)
            if success:
                self.print_success("Dependencies updated")

            self.print_info("Updating iOS CocoaPods...")
            success, _, _ = self.run_command("cd ios && pod install", capture=False)
            if success:
                self.print_success("CocoaPods updated")

            self.print_info("Building iOS release (this may take 5-10 minutes)...")
            success, _, stderr = self.run_command(
                "flutter build ios --release --no-codesign",
                capture=False
            )

            if success:
                self.print_success("iOS release build complete!")
            else:
                self.print_error("Build failed")
                print(f"Error: {stderr}")
                return False

        print("\n✅ Build preparation complete!")
        return True

    def stage_4_xcode_configuration(self):
        """Stage 4: Xcode configuration"""
        self.print_header("⚙️  Stage 4: Xcode Configuration")

        print("Now we need to configure Xcode for App Store distribution.\n")

        self.print_info("Opening Xcode workspace...")
        self.run_command("open ios/Runner.xcworkspace", capture=False)

        print("\n📝 In Xcode, please complete these steps:\n")

        steps = [
            "1. Select 'Runner' target (not RunnerTests)",
            "2. Go to 'Signing & Capabilities' tab",
            "3. Select your Team from dropdown",
            f"4. Verify Bundle Identifier: {self.state.get('bundle_id', 'com.odyseya.app')}",
            "5. Enable 'Automatically manage signing'",
            "6. Add capability: Sign in with Apple (+ Capability button)",
            "7. Go to 'General' tab",
            f"8. Set Version: {self.state.get('version', '1.0.0')}",
            f"9. Set Build: {self.state.get('build_number', '1')}",
            "10. Set Deployment Target: iOS 13.0 or higher"
        ]

        for step in steps:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.YELLOW}Take your time to complete these steps in Xcode.{Colors.END}")

        if not self.ask_yes_no("Have you completed all Xcode configuration steps?"):
            self.print_warning("Please complete Xcode configuration before continuing")
            return False

        print("\n✅ Xcode configuration complete!")
        return True

    def stage_5_archive_upload(self):
        """Stage 5: Archive and Upload"""
        self.print_header("📦 Stage 5: Archive & Upload to App Store Connect")

        print("Now we'll create an archive and upload to App Store Connect.\n")

        print("📝 In Xcode:\n")
        steps = [
            "1. Product → Scheme → Select 'Runner'",
            "2. Product → Destination → Select 'Any iOS Device (arm64)'",
            "3. Product → Archive",
            "4. Wait 5-10 minutes for archive to complete",
            "5. Organizer window will open automatically",
            "6. Select your archive",
            "7. Click 'Distribute App'",
            "8. Select 'App Store Connect' → Next",
            "9. Select 'Upload' → Next",
            "10. Distribution options:",
            "    • Include bitcode: NO",
            "    • Upload symbols: YES",
            "    • Manage version: NO",
            "11. Next → Automatic signing → Next",
            "12. Review → Upload",
            "13. Wait 10-15 minutes for upload to complete"
        ]

        for step in steps:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.YELLOW}This process may take 20-30 minutes total.{Colors.END}")

        if not self.ask_yes_no("Have you successfully uploaded the build?"):
            self.print_warning("Please complete the upload before continuing")
            return False

        self.print_success("Build uploaded to App Store Connect!")

        print("\n⏳ Now you need to wait 10-15 minutes for Apple to process your build.")
        self.print_info("You can check status at: https://appstoreconnect.apple.com")
        self.print_info("Go to: My Apps → Odyseya → TestFlight")
        self.print_info("Status will change from 'Processing' to 'Ready to Submit'")

        return True

    def stage_6_app_store_connect(self):
        """Stage 6: App Store Connect setup"""
        self.print_header("🏪 Stage 6: App Store Connect Configuration")

        print("Let's set up your app in App Store Connect.\n")

        self.print_info("Opening App Store Connect...")
        self.run_command("open https://appstoreconnect.apple.com", capture=False)

        print("\n📝 Complete these steps in App Store Connect:\n")

        print(f"{Colors.BOLD}A. Create App (if first time):{Colors.END}")
        steps_create = [
            "1. Click 'My Apps' → '+' → 'New App'",
            "2. Platforms: iOS",
            "3. Name: Odyseya",
            "4. Primary Language: Polish (or English)",
            f"5. Bundle ID: {self.state.get('bundle_id', 'com.odyseya.app')}",
            "6. SKU: odyseya-001 (or any unique ID)",
            "7. User Access: Full Access",
            "8. Click 'Create'"
        ]
        for step in steps_create:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.BOLD}B. Fill App Information:{Colors.END}")
        steps_info = [
            "1. Go to 'App Information'",
            "2. Subtitle: 'Inner Peace Through Voice Journaling'",
            "3. Privacy Policy URL: [your URL]",
            "4. Category: Health & Fitness",
            "5. Save"
        ]
        for step in steps_info:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.BOLD}C. Set Pricing:{Colors.END}")
        steps_pricing = [
            "1. Go to 'Pricing and Availability'",
            "2. Price: Free (or select tier)",
            "3. Availability: All Countries",
            "4. Save"
        ]
        for step in steps_pricing:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.BOLD}D. App Privacy:{Colors.END}")
        steps_privacy = [
            "1. Go to 'App Privacy'",
            "2. Answer questions about data collection",
            "3. For Odyseya: Yes, we collect:",
            "   • Email (for authentication)",
            "   • Audio recordings (for journaling)",
            "   • Usage data (optional, if analytics)",
            "4. Save"
        ]
        for step in steps_privacy:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.BOLD}E. Age Rating:{Colors.END}")
        steps_age = [
            "1. Complete questionnaire",
            "2. All answers should be 'None' for Odyseya",
            "3. Rating should be: 4+",
            "4. Save"
        ]
        for step in steps_age:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        if not self.ask_yes_no("Have you completed App Store Connect basic setup?"):
            self.print_warning("Please complete setup before continuing")
            return False

        print("\n✅ App Store Connect setup complete!")
        return True

    def stage_7_prepare_submission(self):
        """Stage 7: Prepare for submission"""
        self.print_header("📝 Stage 7: Prepare Submission")

        print("Final step: Prepare your app for review submission.\n")

        print(f"{Colors.BOLD}In App Store Connect, for your app version:{Colors.END}\n")

        steps = [
            "1. Create new version (if needed): '+' → 'iOS App'",
            f"2. Version number: {self.state.get('version', '1.0.0')}",
            "3. What's New in This Version:",
            "   Write release notes (what's new/changed)",
            "",
            "4. Description (4000 char max):",
            "   Write compelling app description",
            "",
            "5. Keywords (100 char):",
            "   journal,voice,diary,mood,wellness,mindfulness",
            "",
            "6. Support URL: [your support page]",
            "7. Marketing URL: [optional]",
            "",
            "8. Screenshots:",
            "   Upload for iPhone 6.7\", 6.5\", iPad (min 3 each)",
            "",
            "9. Build section:",
            f"   Click '+' and select build {self.state.get('build_number', '1')}",
            "",
            "10. App Review Information:",
            "    • Contact: Your name, email, phone",
            "    • Demo Account (if login required)",
            "    • Notes for reviewer",
            "",
            "11. Version Release:",
            "    Select 'Automatically' or 'Manually'",
            "",
            "12. Save all changes"
        ]

        for step in steps:
            if step:
                print(f"   {Colors.CYAN}{step}{Colors.END}")
            else:
                print()

        if not self.ask_yes_no("Have you completed all submission preparation?"):
            self.print_warning("Please complete preparation before submission")
            return False

        print("\n✅ Submission preparation complete!")
        return True

    def stage_8_submit(self):
        """Stage 8: Final submission"""
        self.print_header("🚀 Stage 8: Submit for Review")

        print("You're ready to submit to Apple for review!\n")

        print(f"{Colors.BOLD}Final Checklist:{Colors.END}\n")

        checklist = [
            ("App Icon (all sizes)", "✓"),
            ("Screenshots (all required sizes)", "✓"),
            ("Privacy Policy URL", "✓"),
            ("App Description & Keywords", "✓"),
            ("Build selected", "✓"),
            ("App Review Information", "✓"),
            ("Age Rating completed", "✓"),
            ("All sections have green checkmarks", "?")
        ]

        for item, status in checklist:
            print(f"   {Colors.GREEN if status == '✓' else Colors.YELLOW}{status} {item}{Colors.END}")

        print(f"\n{Colors.BOLD}To Submit:{Colors.END}\n")
        steps = [
            "1. Review all sections - ensure all have ✅",
            "2. Click 'Add for Review' (top right)",
            "3. Answer Export Compliance questions:",
            "   • Does app use encryption? → NO (if only HTTPS)",
            "4. Click 'Submit to App Review'",
            "5. Status will change to 'Waiting for Review'"
        ]

        for step in steps:
            print(f"   {Colors.CYAN}{step}{Colors.END}")

        print(f"\n{Colors.YELLOW}⏱️  Review Timeline:{Colors.END}")
        print(f"   • First submission: 24-48 hours")
        print(f"   • Updates: 12-24 hours")
        print(f"   • You'll receive email updates")

        if self.ask_yes_no("Have you submitted your app for review?"):
            self.print_success("🎉 Congratulations! Your app is submitted!")

            print(f"\n{Colors.BOLD}What happens next:{Colors.END}")
            print(f"   1. Apple reviews your app (24-48 hours)")
            print(f"   2. You receive approval/rejection email")
            print(f"   3. If approved: App goes live automatically (or on schedule)")
            print(f"   4. If rejected: Fix issues and resubmit")

            print(f"\n{Colors.BOLD}Monitoring:{Colors.END}")
            print(f"   • Check App Store Connect for status updates")
            print(f"   • Monitor email for notifications")
            print(f"   • Check Analytics after launch")

            # Clear deployment state
            if self.ask_yes_no("Clear deployment progress tracking?"):
                if self.state_file.exists():
                    self.state_file.unlink()
                self.print_success("Deployment state cleared")

            return True
        else:
            self.print_info("Complete submission when ready")
            return False

    def run(self):
        """Run the deployment agent"""
        stages = [
            ("Welcome & Prerequisites", self.stage_1_welcome),
            ("Assets & Configuration", self.stage_2_assets_preparation),
            ("Build Preparation", self.stage_3_build_preparation),
            ("Xcode Configuration", self.stage_4_xcode_configuration),
            ("Archive & Upload", self.stage_5_archive_upload),
            ("App Store Connect Setup", self.stage_6_app_store_connect),
            ("Prepare Submission", self.stage_7_prepare_submission),
            ("Submit for Review", self.stage_8_submit),
        ]

        current_stage = self.state.get('current_stage', 0)

        for idx, (stage_name, stage_func) in enumerate(stages):
            if idx < current_stage:
                continue

            success = stage_func()

            if success:
                self.state['current_stage'] = idx + 1
                self.state['completed_tasks'].append(stage_name)
                self.save_state()

                if idx < len(stages) - 1:
                    if not self.ask_yes_no(f"\nContinue to next stage: {stages[idx + 1][0]}?"):
                        self.print_info("Progress saved. Run this script again to continue.")
                        sys.exit(0)
            else:
                self.print_error(f"Stage {idx + 1} incomplete. Please address issues and try again.")
                self.save_state()
                sys.exit(1)

        # All stages complete
        self.print_header("🎉 DEPLOYMENT COMPLETE!")
        print("\nYour app is now submitted to the Apple App Store!")
        print("Check your email and App Store Connect for updates.\n")
        print("Good luck! 🚀\n")

if __name__ == "__main__":
    try:
        agent = DeploymentAgent()
        agent.run()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}Deployment paused. Run this script again to continue.{Colors.END}\n")
        sys.exit(0)
    except Exception as e:
        print(f"\n{Colors.RED}Error: {e}{Colors.END}\n")
        sys.exit(1)
