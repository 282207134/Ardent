# Pigeon JNI resolves these methods and their argument types by name.
# Keep the bridge intact when R8 optimizes the release build.
-keep,includedescriptorclasses class io.flutter.plugins.sharedpreferences.** { *; }
# Kotlin suspend results are also looked up reflectively by package:jni.
-keep class kotlin.coroutines.intrinsics.** { *; }
-keep class kotlin.Result** { *; }
-keep class kotlin.Unit { *; }
