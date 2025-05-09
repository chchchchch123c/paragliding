package com.example.paragliding

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.media.MediaPlayer
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val methodChannel = "paraglider"
    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null
    private var tiltData: List<Float> = listOf(0f, 0f, 0f)
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler { call, result  ->
            when (call.method) {
                "isToggled" -> {
                    vibratePhone()
                    result.success(null)
                }
                "getTilt" -> {
                    result.success(tiltData.map { it.toDouble() })
                }
                "playBeeping" -> {
                    val fileName = call.arguments as String
                    playBeeping(fileName)
                }
                "pauseBeeping" -> {
                    pauseBeeping()
                }
            }
        }
    }
    private fun vibratePhone() {
        val  vibrator = getSystemService(VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(300, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            vibrator.vibrate(300)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    }

    override fun onResume() {
        super.onResume()
        accelerometer?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }


    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
            tiltData = listOf(event.values[0], event.values[1], event.values[2])
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    }

    private fun playBeeping(fileName: String) {
        val resId = getRawResId(fileName)
        if (resId != 0) {
            mediaPlayer?.release()
            mediaPlayer = MediaPlayer.create(this, resId)
            mediaPlayer?.isLooping = true
            mediaPlayer?.start()
        }
    }

    private fun pauseBeeping() {
        mediaPlayer?.let {
            if (it.isPlaying) {
                it.pause()
            }
            else if (!it.isPlaying) {
                it.start()
            }
        }
    }

    private fun getRawResId(fileName: String): Int {
        return when (fileName) {
            "beeping" -> R.raw.beeping
            else -> 0
        }
    }

}