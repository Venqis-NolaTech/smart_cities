package com.venqis.smartcities

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.widget.RemoteViews;
import android.widget.Toast;
import com.venqis.smartcities.R
import io.flutter.embedding.android.FlutterActivity;


class WidgetActivity : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (i in appWidgetIds.indices) {
            val appWidgetId = appWidgetIds[i]
            /*val url = "http://tutlane.com"
            val intent = Intent(Intent.ACTION_VIEW)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.setData(Uri.parse(url))*/

            val intent = FlutterActivity
                .withNewEngine()
                .initialRoute("help_line_page")
                .build(context)


            val pending: PendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
            val views = RemoteViews(context.getPackageName(), R.layout.activity_main)
            views.setOnClickPendingIntent(R.id.btnClick, pending)
            appWidgetManager.updateAppWidget(appWidgetId, views)
            Toast.makeText(context, "widget added", Toast.LENGTH_SHORT).show()
        }
    }
}