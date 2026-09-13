package com.quran.app

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity() {
    private val lifecycleChannelName = "com.quran.app/lifecycle"

    // The audio_service foreground service (and the Flutter engine it keeps
    // alive) survives the user swiping this activity away from recents —
    // that's what lets qirath keep playing while merely backgrounded. To
    // also let a genuine "kill" (swipe away) stop playback, `isFinishing`
    // without `isChangingConfigurations` distinguishes that from a rotation/
    // config-change recreate, letting Dart decide to stop the audio.
    override fun onDestroy() {
        if (isFinishing && !isChangingConfigurations) {
            try {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, lifecycleChannelName)
                    .invokeMethod("onTaskRemoved", null)
            } catch (e: Exception) {
                // Engine already gone — nothing left to notify.
            }
        }
        super.onDestroy()
    }
}
