-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-keep class com.google.android.libraries.places.** { *; }
-keep interface com.google.android.libraries.places.** { *; }
-keep class com.google.maps.android.clustering.** { *; }
-keep class dev.flutter.plugins.googlemaps.** { *; }

# Flutter utility classes and plugins
-keep class io.flutter.util.PathUtils { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.connectivity.** { *; }
-keep class io.flutter.plugins.deviceinfo.** { *; }
-dontwarn io.flutter.util.PathUtils
