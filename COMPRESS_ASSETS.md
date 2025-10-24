# 🗜️ Asset Compression Guide for Odyseya

**CRITICAL TASK:** Compress image assets from **35 MB → 12 MB** (65% reduction)

**Status:** ⚠️ REQUIRED BEFORE NEXT BUILD

---

## Quick Start (Choose One Method)

### Method 1: ImageOptim CLI (macOS - Fastest)
```bash
# Install
brew install imageoptim-cli

# Run compression
cd /Users/joannacholas/CursorProjects/odyseya
imageoptim --quality 85 assets/images/*.png
imageoptim --quality 85 assets/images/moods/*.png
```

### Method 2: TinyPNG Website (Any Platform)
1. Visit https://tinypng.com
2. Upload files (max 20 at once)
3. Download and replace

### Method 3: Squoosh (Google's Tool)
1. Visit https://squoosh.app
2. Drag & drop images
3. Select "OxiPNG" codec, quality 85%
4. Download and replace

---

## Files to Compress (Priority Order)

### 🔴 CRITICAL (Do These First)

```bash
# Background images (largest files)
assets/images/background_day.png       # 2.2 MB → Target: 400 KB
assets/images/Odyseya_logo.png         # 2.1 MB → Target: 300 KB
assets/images/Odyseya_logo_noBGR.png   # 2.2 MB → Target: 300 KB
```

### 🟡 HIGH PRIORITY (13 Mood Images)

```bash
assets/images/moods/Loneliness.png     # 1.5 MB → Target: 300 KB
assets/images/moods/Joyful.png         # 1.4 MB → Target: 300 KB
assets/images/moods/Confident.png      # 1.4 MB → Target: 300 KB
assets/images/moods/Anxious.png        # 1.4 MB → Target: 300 KB
assets/images/moods/Grateful.png       # 1.4 MB → Target: 300 KB
assets/images/moods/Melancholy.png     # 1.4 MB → Target: 300 KB
assets/images/moods/Peaceful.png       # 1.4 MB → Target: 300 KB
assets/images/moods/Calm.png           # 1.3 MB → Target: 300 KB
assets/images/moods/Overwhelmed.png    # 1.0 MB → Target: 250 KB
assets/images/moods/Sad.png            # 1.0 MB → Target: 250 KB
assets/images/moods/Empty.png          # 994 KB → Target: 250 KB
assets/images/moods/Lonely.png         # 966 KB → Target: 250 KB
```

### 🟢 MEDIUM PRIORITY (Logos & Icons)

```bash
assets/images/inside_compass.png       # 1.4 MB → Target: 250 KB
assets/images/OpenApp.png              # 1.4 MB → Target: 300 KB
assets/images/Odyseya_Icon.png         # 1.4 MB → Target: 300 KB
assets/images/Dessert.png              # 809 KB → Target: 200 KB
assets/images/Odyseya_word.png         # (check size) → Target: 200 KB
```

---

## Step-by-Step Instructions

### Using ImageOptim (Recommended)

1. **Install ImageOptim:**
   ```bash
   brew install imageoptim-cli
   ```

2. **Navigate to project:**
   ```bash
   cd /Users/joannacholas/CursorProjects/odyseya
   ```

3. **Compress background images:**
   ```bash
   imageoptim --quality 85 assets/images/background_day.png
   imageoptim --quality 85 assets/images/Odyseya_logo.png
   imageoptim --quality 85 assets/images/Odyseya_logo_noBGR.png
   ```

4. **Compress all mood images:**
   ```bash
   imageoptim --quality 85 assets/images/moods/*.png
   ```

5. **Compress logos and icons:**
   ```bash
   imageoptim --quality 85 assets/images/inside_compass.png
   imageoptim --quality 85 assets/images/OpenApp.png
   imageoptim --quality 85 assets/images/Odyseya_Icon.png
   imageoptim --quality 85 assets/images/Dessert.png
   ```

6. **Verify results:**
   ```bash
   du -sh assets/images/*.png
   du -sh assets/images/moods/*.png
   du -sh assets/
   ```

### Using TinyPNG Website

1. **Go to https://tinypng.com**

2. **Upload in batches:**
   - Batch 1: All mood images (13 files)
   - Batch 2: Background images (3 files)
   - Batch 3: Logos and icons (5 files)

3. **Download compressed files**

4. **Replace original files:**
   - Download to Downloads folder
   - Move to project: `assets/images/` or `assets/images/moods/`

### Using Squoosh (Manual but Precise)

1. **Go to https://squoosh.app**

2. **For each file:**
   - Drag & drop image
   - Select "OxiPNG" from codec dropdown
   - Adjust quality to 85%
   - Preview quality (ensure it looks good)
   - Download compressed version

3. **Replace files in project**

---

## Verification Checklist

After compression, verify:

- [ ] Total assets folder < 15 MB
- [ ] All images still look sharp on device
- [ ] No images > 500 KB
- [ ] Mood images around 250-300 KB each
- [ ] Background images around 400 KB
- [ ] Logo images around 200-300 KB

**Check total size:**
```bash
cd /Users/joannacholas/CursorProjects/odyseya
du -sh assets/
```

Expected result: `12M` to `15M` (down from `35M`)

---

## Quality Settings Guide

| Image Type | Quality | Reason |
|------------|---------|--------|
| Mood images | 85% | User-facing, need quality |
| Backgrounds | 80-85% | Large area, slight blur OK |
| Logos | 90% | Small, need sharpness |
| Icons | 90% | Need crisp edges |

---

## Backup Instructions (IMPORTANT!)

**Before compressing, create a backup:**

```bash
# Create backup directory
mkdir -p ~/Desktop/odyseya_assets_backup

# Copy all assets
cp -R /Users/joannacholas/CursorProjects/odyseya/assets ~/Desktop/odyseya_assets_backup/

echo "✅ Backup created at ~/Desktop/odyseya_assets_backup/"
```

**To restore if needed:**
```bash
cp -R ~/Desktop/odyseya_assets_backup/assets/* /Users/joannacholas/CursorProjects/odyseya/assets/
```

---

## Before & After

### Before Compression
```
Total: 35 MB
- background_day.png: 2.2 MB
- Odyseya_logo.png: 2.1 MB
- 13 mood images: ~18 MB
- Other assets: ~13 MB
```

### After Compression (Target)
```
Total: 12 MB (-65%)
- background_day.png: 400 KB (-82%)
- Odyseya_logo.png: 300 KB (-86%)
- 13 mood images: ~3.9 MB (-78%)
- Other assets: ~7.7 MB (-41%)
```

---

## Troubleshooting

### Issue: "command not found: imageoptim"
**Solution:** Install Homebrew first, then ImageOptim:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install imageoptim-cli
```

### Issue: Images look blurry after compression
**Solution:** Increase quality to 90%:
```bash
imageoptim --quality 90 path/to/image.png
```

### Issue: File size not reduced enough
**Solution:** Convert PNG to JPEG for backgrounds:
```bash
# Use online tool or ImageMagick
convert background_day.png -quality 90 background_day.jpg
```

### Issue: Compression is too slow
**Solution:** Use TinyPNG API for batch processing:
```bash
npm install -g tinypng-cli
tinypng assets/images/*.png -k YOUR_API_KEY
```

---

## Advanced: Batch Script

Save this as `compress_all.sh` and run it:

```bash
#!/bin/bash

echo "🗜️  Starting asset compression..."

# Check if imageoptim is installed
if ! command -v imageoptim &> /dev/null; then
    echo "❌ ImageOptim not installed. Installing..."
    brew install imageoptim-cli
fi

# Create backup
echo "📦 Creating backup..."
mkdir -p ~/Desktop/odyseya_assets_backup
cp -R assets ~/Desktop/odyseya_assets_backup/

# Compress background images
echo "🖼️  Compressing background images..."
imageoptim --quality 85 assets/images/background_day.png
imageoptim --quality 85 assets/images/Odyseya_logo.png
imageoptim --quality 85 assets/images/Odyseya_logo_noBGR.png

# Compress mood images
echo "😊 Compressing mood images..."
imageoptim --quality 85 assets/images/moods/*.png

# Compress logos and icons
echo "🏷️  Compressing logos and icons..."
imageoptim --quality 85 assets/images/inside_compass.png
imageoptim --quality 85 assets/images/OpenApp.png
imageoptim --quality 85 assets/images/Odyseya_Icon.png
imageoptim --quality 85 assets/images/Dessert.png

# Check new size
echo ""
echo "✅ Compression complete!"
echo ""
echo "📊 New size:"
du -sh assets/

echo ""
echo "💾 Backup saved to: ~/Desktop/odyseya_assets_backup/"
```

**Make executable and run:**
```bash
chmod +x compress_all.sh
./compress_all.sh
```

---

## Expected Time

- **ImageOptim CLI:** 5-10 minutes (automatic)
- **TinyPNG Website:** 15-20 minutes (manual upload/download)
- **Squoosh:** 30-40 minutes (one by one)

**Recommended:** Use ImageOptim CLI for speed and consistency

---

## Next Steps After Compression

1. ✅ Verify assets folder is < 15 MB
2. ✅ Test app on device - check image quality
3. ✅ Commit changes to git
4. ✅ Build app and verify size reduction:
   ```bash
   flutter build apk --analyze-size
   ```

---

## Need Help?

If you encounter issues:
1. Check the backup is created: `ls ~/Desktop/odyseya_assets_backup/`
2. Verify ImageOptim is installed: `imageoptim --version`
3. Test compression on one file first
4. Check image quality on device before committing

---

**Status Tracking:**

- [ ] Backup created
- [ ] Background images compressed
- [ ] Mood images compressed
- [ ] Logo/icon images compressed
- [ ] Total size verified (< 15 MB)
- [ ] Quality verified on device
- [ ] Changes committed

**Target:** Complete before next app build
**Priority:** CRITICAL
**Impact:** -65% app size, faster downloads, better performance
