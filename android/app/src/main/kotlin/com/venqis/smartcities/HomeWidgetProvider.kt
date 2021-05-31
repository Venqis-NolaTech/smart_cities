package com.venqis.smartcities

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import io.flutter.embedding.android.FlutterActivity


const val FLUTTER_ENGINE_ID = "newLoginEngine"
const val HOME_WIDGET_LAUNCH_ACTION = "com.venqis.smartcities.action.LAUNCH"



abstract class HomeWidgetProvider : AppWidgetProvider() {


    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.simple_app_widget).apply {

                val intent = FlutterActivity
                    .withNewEngine()
                    .initialRoute("/home_widget_page")
                    .build(context)

                intent.action = HOME_WIDGET_LAUNCH_ACTION

                val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)


                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    abstract fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences)


}