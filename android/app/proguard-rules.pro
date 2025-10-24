# Odyseya ProGuard Rules
# Optimizes and obfuscates code for smaller app size

# ⚡ Performance: Keep Flutter and Dart code
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Keep RevenueCat classes
-keep class com.revenuecat.** { *; }
-dontwarn com.revenuecat.**

# Keep Google Sign-In
-keep class com.google.android.gms.auth.** { *; }

# Keep permissions handler
-keep class com.baseflow.permissionhandler.** { *; }

# Keep audio/recording libraries
-keep class com.dooboolab.audiorecorder.** { *; }
-keep class com.dooboolab.TauEngine.** { *; }

# Keep notification classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Remove logging for production
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimize code
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# Keep Parcelables
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
