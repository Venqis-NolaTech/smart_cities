package com.venqis.smartcities

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences

abstract class HomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.simple_app_widget).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                /*
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Swap Title Text by calling Dart Code in the Background
                setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                    ?: "No Title Set")
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidgetExample://titleClicked")
                )
                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

                val message = widgetData.getString("message", null)
                setTextViewText(R.id.widget_message, message
                    ?: "No Message Set")
                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("homeWidgetExample://message?message=$message"))
                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)*/
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    abstract fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences)
}