package com.example.fitpagewebviewex;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBarActivity;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.webkit.WebSettings.ZoomDensity;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends ActionBarActivity {

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		if (savedInstanceState == null) {
			getSupportFragmentManager().beginTransaction()
					.add(R.id.container, new PlaceholderFragment()).commit();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	/**
	 * A placeholder fragment containing a simple view.
	 */
	public static class PlaceholderFragment extends Fragment {

		WebView webView;
		
		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_main, container,
					false);
			webView = (WebView) rootView.findViewById(R.id.webView1);
//			webView.getSettings().setDefaultZoom(ZoomDensity.FAR);
			webView.getSettings().setUseWideViewPort(true);
			webView.getSettings().setLoadWithOverviewMode(true);
			webView.getSettings().setBuiltInZoomControls(true);
			webView.getSettings().setSupportZoom(true);
			webView.setWebViewClient(new WebViewClient()
			{
				@Override
				public void onPageFinished(WebView view, String url) 
				{
					super.onPageFinished(view, url);
					WindowManager manager = (WindowManager) view.getContext().getSystemService(Context.WINDOW_SERVICE);

				    DisplayMetrics metrics = new DisplayMetrics();
				    manager.getDefaultDisplay().getMetrics(metrics);

				    metrics.widthPixels /= metrics.density;
				    //view.loadUrl("javascript:var scale = " + 500 + " ; document.body.style.zoom = scale;");
				    view.loadUrl("javascript:document.body.style.zoom = "+String.valueOf(0.5)+";");
				}
			});
			webView.loadUrl("file:///mnt/sdcard//epubBook/epubBook//EPUB/xhtml/0-intro.xhtml");
			return rootView;
		}
		
		
	}

}
