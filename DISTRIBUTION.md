# Distribution Guide

This app cannot be distributed via the Mac App Store due to its requirement for sudo privileges and system-level access. Instead, distribute it directly with Apple notarization for Gatekeeper approval.

## Prerequisites

1. **Apple Developer Account** ($99/year) - https://developer.apple.com
2. **Developer ID Application certificate** - Created in Xcode or Apple Developer portal
3. **App-specific password** - Generated at https://appleid.apple.com (Security → App-Specific Passwords)

## One-Time Setup

### 1. Create Developer ID Certificate

In Xcode:
- Xcode → Settings → Accounts → Select your team → Manage Certificates
- Click `+` → "Developer ID Application"

Or via Apple Developer portal:
- Certificates, Identifiers & Profiles → Certificates → Create "Developer ID Application"

### 2. Store Credentials in Keychain

Store your app-specific password so scripts can use it:

```bash
xcrun notarytool store-credentials "notarytool-password" \
  --apple-id "your-email@example.com" \
  --team-id "Q3Z639YB49" \
  --password "xxxx-xxxx-xxxx-xxxx"
```

Find your Team ID at https://developer.apple.com/account → Membership Details.

## Manual Notarization Steps

### 1. Archive the App

```bash
xcodebuild -project LastDance.xcodeproj \
  -scheme "Last Dance" \
  -configuration Release \
  -archivePath "build/Last Dance.xcarchive" \
  archive
```

### 2. Export the App

```bash
xcodebuild -exportArchive \
  -archivePath "build/Last Dance.xcarchive" \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

### 3. Create ZIP for Notarization

```bash
ditto -c -k --keepParent "build/export/Last Dance.app" "build/Last Dance.zip"
```

### 4. Submit for Notarization

```bash
xcrun notarytool submit "build/Last Dance.zip" \
  --keychain-profile "notarytool-password" \
  --wait
```

### 5. Staple the Ticket

```bash
xcrun stapler staple "build/export/Last Dance.app"
```

### 6. Create Final DMG (Optional)

```bash
hdiutil create -volname "Last Dance" \
  -srcfolder "build/export/Last Dance.app" \
  -ov -format UDZO \
  "build/Last Dance.dmg"

xcrun stapler staple "build/Last Dance.dmg"
```

## Automated Script

Use the included `scripts/notarize.sh` script for automated builds:

```bash
./scripts/notarize.sh
```

## Verification

Verify the app is properly signed and notarized:

```bash
# Check code signature
codesign -dv --verbose=4 "build/export/Last Dance.app"

# Verify notarization
spctl -a -v "build/export/Last Dance.app"

# Check stapled ticket
xcrun stapler validate "build/export/Last Dance.app"
```

Expected output from `spctl`: `Last Dance.app: accepted source=Notarized Developer ID`

## Troubleshooting

### "The signature is invalid"
- Ensure Hardened Runtime is enabled in Xcode (Build Settings → Enable Hardened Runtime = YES)
- Check that your Developer ID certificate is valid and not expired

### Notarization fails with security issues
- Check the detailed log: `xcrun notarytool log <submission-id> --keychain-profile "notarytool-password"`
- Common issues: unsigned frameworks, invalid entitlements, missing secure timestamp

### "App is damaged and can't be opened"
- The app wasn't properly signed or notarization failed
- Try: `xattr -cr /path/to/Last Dance.app` (removes quarantine for testing only)

## ExportOptions.plist

Create this file in the project root if it doesn't exist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>Q3Z639YB49</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```
