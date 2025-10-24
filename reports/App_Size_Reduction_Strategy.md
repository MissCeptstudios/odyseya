# 📱 App Size Reduction Strategy - Complete Guide

**Goal:** Minimize download and installed size for Odyseya app
**Current Size:** ~60 MB (estimated)
**Target Size:** < 25 MB download, < 50 MB installed
**Priority:** CRITICAL for user acquisition

---

## 📊 Current Size Breakdown

```
Estimated App Size:
├── Assets (images): 35 MB ⚠️ TOO LARGE
├── Flutter framework: ~15 MB
├── App code: ~5 MB
├── Native libraries: ~5 MB
└── Total: ~60 MB
```

**Problem Areas:**
1. ⚠️ Assets are 58% of total size (35 MB / 60 MB)
2. ⚠️ No code shrinking enabled
3. ⚠️ No resource optimization
4. ⚠️ No split APKs configured (Android)

---

## 🎯 Optimization Strategy

### Phase 1: Asset Compression (CRITICAL) ✅ In Progress
**Target:** 35 MB → 12 MB (-65%)
**Status:** See [COMPRESS_ASSETS.md](../COMPRESS_ASSETS.md)

### Phase 2: Build Configuration (THIS DOCUMENT)
**Target:** 60 MB → 25-30 MB (-50%)
**Status:** Implementation instructions below

### Phase 3: Code Optimization (Future)
**Target:** Additional 2-3 MB savings
**Status:** Next sprint

---

## 🔧 Implementation Instructions

### A. Android Build Optimization

#### 1. Enable Code Shrinking & Obfuscation

**File:** `android/app/build.gradle`

<function_calls>
<invoke name="Read">
<parameter name="file_path">/Users/joannacholas/CursorProjects/odyseya/android/app/build.gradle