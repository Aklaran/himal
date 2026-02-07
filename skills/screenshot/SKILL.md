---
name: screenshot
description: Take screenshots of web pages at various viewport sizes for visual debugging. Use when building or debugging frontend UI, especially mobile-responsive layouts.
---

# Screenshot Skill

Take headless browser screenshots to visually verify frontend work.

## ⚠️ Important: Chromium CLI --screenshot hangs on ARM

Do NOT use `chromium --headless --screenshot`. It hangs indefinitely on this ARM server.
Always use the Puppeteer script below.

## Screenshot Script

Located at: `~/.pi/agent/skills/screenshot/screenshot.js`

### Usage

```bash
node ~/.pi/agent/skills/screenshot/screenshot.js <url> [output] [width] [height]
```

### Examples

```bash
# Mobile (iPhone - default)
node ~/.pi/agent/skills/screenshot/screenshot.js http://localhost:7100/chat /tmp/mobile.png 375 812

# Desktop
node ~/.pi/agent/skills/screenshot/screenshot.js http://localhost:7100/chat /tmp/desktop.png 1440 900

# iPad
node ~/.pi/agent/skills/screenshot/screenshot.js http://localhost:7100/chat /tmp/tablet.png 768 1024
```

### Common Viewport Sizes

| Device | Width | Height |
|--------|-------|--------|
| iPhone SE | 375 | 667 |
| iPhone 14 | 390 | 844 |
| iPhone 14 Pro Max | 430 | 932 |
| iPad | 768 | 1024 |
| Desktop | 1440 | 900 |

### Viewing Screenshots

After taking a screenshot, view it with the `Read` tool:

```
Read /tmp/mobile.png
```

### Workflow

1. Take screenshots at mobile + desktop sizes
2. View them with Read
3. Fix issues in the code
4. Re-screenshot to verify

### Limitations

- No auth/cookie support — works for pages that don't require login, or apps where auth is bypassed (like Tailscale-only apps)
- If the page needs login, you'll need to add cookie injection to the script
- `waitUntil: 'networkidle0'` waits for network to be idle, with a 15s timeout
- `fullPage: false` — captures only the viewport. Change to `true` in the script if you need full-page captures
