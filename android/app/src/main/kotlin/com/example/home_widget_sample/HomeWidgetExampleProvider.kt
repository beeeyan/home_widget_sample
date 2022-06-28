package com.example.home_widget_sample

import es.antonborri.home_widget.HomeWidgetProvider
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews

class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) { 
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout)
            .apply {
                setTextViewText(R.id.widget_text, widgetData.getString("text", null)
                ?: "No Text Set")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
         }
    }
}