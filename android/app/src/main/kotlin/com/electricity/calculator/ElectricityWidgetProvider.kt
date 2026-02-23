package com.electricity.calculator

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ElectricityWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout)

            val calculationName = widgetData.getString("calculation_name", "No data")
            val calculationCost = widgetData.getString("calculation_cost", "0")
            val calculationKwh = widgetData.getString("calculation_kwh", "0")

            views.setTextViewText(R.id.calculation_name, calculationName)
            views.setTextViewText(R.id.calculation_cost, "$calculationCost دینار")
            views.setTextViewText(R.id.calculation_kwh, "$calculationKwh kWh")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}