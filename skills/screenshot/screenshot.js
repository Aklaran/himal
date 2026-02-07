#!/usr/bin/env node
/**
 * Headless screenshot tool for Annapurna.
 * 
 * Usage: node screenshot.js <url> [output] [width] [height]
 * 
 * Examples:
 *   node screenshot.js http://localhost:7100/chat
 *   node screenshot.js http://localhost:7100/chat /tmp/mobile.png 375 812
 *   node screenshot.js http://localhost:7100/chat /tmp/desktop.png 1440 900
 */
const puppeteer = require('puppeteer-core');

const [,, url, output = '/tmp/screenshot.png', width = '375', height = '812'] = process.argv;

if (!url) {
  console.error('Usage: node screenshot.js <url> [output] [width] [height]');
  process.exit(1);
}

(async () => {
  const browser = await puppeteer.launch({
    executablePath: '/usr/bin/chromium',
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: parseInt(width), height: parseInt(height) });
    await page.goto(url, { waitUntil: 'networkidle0', timeout: 15000 });
    await page.screenshot({ path: output, fullPage: false });
    console.log(`Screenshot saved: ${output} (${width}x${height})`);
  } catch (err) {
    console.error('Screenshot failed:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
