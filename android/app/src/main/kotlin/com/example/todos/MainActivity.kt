package com.example.todos

import android.app.AlarmManager
import android.app.Notification
import android.app.PendingIntent
import android.content.Intent
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    companion object {
        private val FLUTTER_CHANNEL = "todos/notifications"
        val NOTIFICATION_CHANNEL_ID = "TODO_CHANNEL_ID"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLUTTER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleNotification" -> {
                    val todoId = call.argument<String>("todo_id")!!
                    val title = call.argument<String>("title")!!
                    val time = call.argument<Long>("time_millis")!!
                    val notification = getNotification(title)!!

                    val id = todoId.hashCode()
                    scheduleNotification(notification, id, time)
                    result.success(true)
                }
                "cancelNotification" -> {
                    val title = call.argument<String>("title")!!
                    val notification = getNotification(title)!!

                    val id = title.hashCode()
                    cancelNotification(notification, id)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun scheduleNotification(notification: Notification, id: Int, time_millis: Long) {
        val notificationIntent = Intent(this, NotificationPublisher::class.java)
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id)
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification)
        val pendingIntent = PendingIntent.getBroadcast(this, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT)
        val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
        alarmManager[AlarmManager.RTC_WAKEUP, time_millis] = pendingIntent
    }

    private fun cancelNotification(notification: Notification, id: Int) {
        val notificationIntent = Intent(this, NotificationPublisher::class.java)
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id)
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification)
        val pendingIntent = PendingIntent.getBroadcast(this, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT)
        val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
    }

    private fun getNotification(content: String): Notification? {
        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
        builder.setContentTitle("Напоминание о задаче")
        builder.setContentText(content)
        builder.setAutoCancel(true)
        builder.setSmallIcon(R.drawable.ic_stat_name)
        return builder.build()
    }

}
