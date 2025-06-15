# ML Kit language-specific recognizers
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Required for ML Kit to reflectively instantiate models
-keep class com.google.mlkit.common.model.RemoteModel { *; }
-keep class com.google.mlkit.common.sdkinternal.ModelResource { *; }
-keep class com.google.mlkit.common.sdkinternal.model.ModelValidator { *; }