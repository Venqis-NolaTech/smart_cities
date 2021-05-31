package com.venqis.smartcities

import android.graphics.drawable.ColorDrawable
import android.widget.ImageView
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import com.venqis.smartcities.R

class HomeWidgetActivity : FlutterActivity() {

    companion object {
        fun withCachedEngine(engineId: String) = CustomCachedEngineIntentBuilder(engineId)
    }

    class CustomCachedEngineIntentBuilder(engineId: String) :
        CachedEngineIntentBuilder(HomeWidgetActivity::class.java, engineId)

    override fun provideSplashScreen(): SplashScreen =
        DrawableSplashScreen(
            ColorDrawable(ContextCompat.getColor(this, R.color.colorPrimary)),
            ImageView.ScaleType.CENTER,
            0
        )
}