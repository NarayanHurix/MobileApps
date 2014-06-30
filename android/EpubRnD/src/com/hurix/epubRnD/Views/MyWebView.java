package com.hurix.epubRnD.Views;

import java.lang.reflect.Method;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.R;
import com.hurix.epubRnD.Settings.GlobalSettings;
import com.hurix.epubRnD.VOs.WebViewDAO;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.ActionMode;
import android.view.ActionMode.Callback;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ScrollView;
import android.widget.Toast;

@SuppressLint("NewApi")
public class MyWebView extends WebView 
{
	
	private WebViewDAO _data;
	private boolean isURLLoaded = false;
	private MyWebViewLoadListener _mMyWebViewLoadListener;
	

	private static final int SWIPE_THRESHOLD = 100;
	private static final int SWIPE_VELOCITY_THRESHOLD = 100;
	private OnPageChangeListener _listener;
	private ViewGroup _currentView;
    private MyViewPager _viewpager;
    Object actionMode;
	public interface OnPageChangeListener
	{
		public abstract ViewGroup getPreviousView(ViewGroup oldView);
		public abstract ViewGroup getNextView(ViewGroup oldView);
	}
	GestureDetector gestureDetector = new GestureDetector(new MyGestureDetector());
	public MyWebView(Context context) {
		super(context);
	
		init(context);
				
	}

	public MyWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
		
		init(context);
	}

	public MyWebView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		
		init(context);
	}


	public interface MyWebViewLoadListener
	{
		public abstract void onLoadStart();
		public abstract void onLoadFinish();
		public abstract void onPageOutOfRange();
	}

	public void setMyWebViewLoadListener(MyWebViewLoadListener myWebViewLoadListener)
	{
		_mMyWebViewLoadListener = myWebViewLoadListener;
	}

	@Override
	public int computeHorizontalScrollRange() {
		// TODO Auto-generated method stub
		return super.computeHorizontalScrollRange();
	}

	public WebViewDAO getData() 
	{
		return _data;
	}
	public void setData(WebViewDAO _data) 
	{
		this._data = _data;
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		calculateNoOfPages();
	/*	gestureDetector.onTouchEvent(event);
        return super.onTouchEvent(event);*/
	//	return   super.onTouchEvent(event);
		if(GlobalSettings.HIGHLIGHT_SWITCH)
		{
			return super.onTouchEvent(event);
		}
		else
		{
			if(gestureDetector.onTouchEvent(event))
			{
				return true;
			}
			else
			{
				return super.onTouchEvent(event);
			}
		}
		
		
		/*//return false;
		if(GlobalConstants.ENABLE_WEB_VIEW_TOUCH)
		{
			//GlobalConstants.ENABLE_WEB_VIEW_TOUCH = false;
			return super.onTouchEvent(event);
		}
		else
		{
			return GlobalConstants.ENABLE_WEB_VIEW_TOUCH;
		}*/

	}
	

//	@Override
//	public boolean onInterceptTouchEvent(MotionEvent event) {
//		/*switch (event.getAction()) {
//	        case MotionEvent.ACTION_DOWN:
//	            mLastX = event.getX();
//	            mLastY = event.getY();
//	            mStartY = mLastY;
//	            break;
//	        case MotionEvent.ACTION_CANCEL:
//	        case MotionEvent.ACTION_UP:
//	            mIsBeingDragged = false;
//	            break;
//	        case MotionEvent.ACTION_MOVE:
//	            float x = event.getX();
//	            float y = event.getY();
//	            float xDelta = Math.abs(x - mLastX);
//	            float yDelta = Math.abs(y - mLastY);
//
//	            float yDeltaTotal = y - mStartY;
//	            if (yDelta > xDelta && Math.abs(yDeltaTotal) > mTouchSlop) {
//	                mIsBeingDragged = true;
//	                mStartY = y;
//	                return true;
//	            }
//	            break;
//	    }
//		 */
//		return false;
//	}


	@SuppressLint({ "NewApi", "SetJavaScriptEnabled" })
	private void init(Context context)
	{
		isURLLoaded = false;

		if(android.os.Build.VERSION.SDK_INT>=android.os.Build.VERSION_CODES.HONEYCOMB)
		{
			getSettings().setAllowContentAccess(true);
		}
		
		setScrollBarStyle(View.SCROLLBARS_OUTSIDE_OVERLAY);
		getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
		getSettings().setMinimumFontSize(GlobalConstants.MIN_FONT_SIZE);
		getSettings().setJavaScriptEnabled(true);
		getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);
		getSettings().setAllowFileAccess(true);
		
		//		getSettings().setRenderPriority(RenderPriority.HIGH);
		//		getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		setHorizontalScrollBarEnabled(false);
		setVerticalScrollBarEnabled(false);
		//getSettings().setLayoutAlgorithm(LayoutAlgorithm.SINGLE_COLUMN);
		if(android.os.Build.VERSION.SDK_INT>=android.os.Build.VERSION_CODES.JELLY_BEAN)
		{
			getSettings().setAllowUniversalAccessFromFileURLs(true);
		}

		setWebViewClient(new MyWebClient());
		setWebChromeClient(new MyWebChromeClient());
		addJavascriptInterface(new JSLoadCallBack(), "jsInterface");
		addOnLayoutChangeListener(new OnLayoutChangeListener() {

			@Override
			public void onLayoutChange(View v, int left, int top, int right,
					int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) 
			{
				if(getMeasuredWidth()!=0 && getMeasuredHeight()!=0 && !isURLLoaded)
				{
					_mMyWebViewLoadListener.onLoadStart();
					getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);

					loadUrl(getData().getChapterVO().getChapterURL());
					isURLLoaded = true;

				}
			}
		});

		if(GlobalSettings.EPUB_TYPE == GlobalConstants.FIXED)
		{
			setFitsSystemWindows(true);
		}
		
		
	}

	private class MyWebClient extends WebViewClient
	{
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			// TODO Auto-generated method stub
			//	GlobalConstants.ENABLE_WEB_VIEW_TOUCH = false;
			super.onPageStarted(view, url, favicon);
		}
		@Override
		public void onPageFinished(WebView view, String url) 
		{
			super.onPageFinished(view, url);

			final MyWebView myWebView = (MyWebView) view;

			if(GlobalSettings.EPUB_TYPE==GlobalConstants.REFLOWABLE)
			{
				String varMySheet = "var mySheet = document.styleSheets[0];";

				String addCSSRule = "function addCSSRule(selector, newRule) {"
						+ "ruleIndex = mySheet.cssRules.length;"
						+ "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"

						+ "}";

				String insertRule1 = "addCSSRule('html', 'padding: 0px; height: "
						+ (myWebView.getMeasuredHeight() )
						+ "px; -webkit-column-gap: 0px; -webkit-column-width: "
						+ myWebView.getMeasuredWidth() + "px;')";

				String insertRule2 = "addCSSRule('p', 'text-align: justify;')";

				//String setImageRule = "addCSSRule('img', 'max-width: "+  (myWebView.getMeasuredWidth() -200)+"px; height:"+(myWebView.getMeasuredHeight() - 200)+"px')";

				myWebView.loadUrl("javascript:" + varMySheet);
				myWebView.loadUrl("javascript:" + addCSSRule);
				myWebView.loadUrl("javascript:" + insertRule1);
				myWebView.loadUrl("javascript:" + insertRule2);
				//myWebView.loadUrl("javascript:" + setImageRule);

				myWebView.loadUrl("javascript: jsInterface.paginationDone()");
			}
		}
	}

	private class MyWebChromeClient extends WebChromeClient
	{
		@Override
		public void onProgressChanged(WebView view, int newProgress) 
		{
			super.onProgressChanged(view, newProgress);
			//	GlobalConstants.ENABLE_WEB_VIEW_TOUCH = false;
			if(newProgress == 100)
			{
				postDelayed(new Runnable() 
				{
					@Override
					public void run() 
					{
						calculateNoOfPages();
						if(getData().getIndexOfPage()==-2)
						{
							getData().setIndexOfPage(getData().getPageCount()-1);
						}
						if(getData().getIndexOfPage()>=getData().getPageCount())
						{
							getData().setIndexOfPage(getData().getPageCount());
							_mMyWebViewLoadListener.onPageOutOfRange();
						}
						else
						{

							scrollTo(getMeasuredWidth()*getData().getIndexOfPage(), 0);
							_mMyWebViewLoadListener.onLoadFinish();
						}
					}
				},300);
			}
		}
	}

	class JSLoadCallBack 
	{
		@JavascriptInterface
		public void paginationDone()
		{
			((Activity)getContext()).runOnUiThread(new Runnable() {

				@Override
				public void run() {
					Log.d("here","JSLoadCallBack : "+computeHorizontalScrollRange()+" content height "+getContentHeight() +" "+computeHorizontalScrollExtent());
					//disable default webview text selection feature
					loadUrl("javascript: document.documentElement.style.webkitUserSelect='none'");
					addJQueryJS();
					
				}
				
			});
		}
		
		@JavascriptInterface
		public void onJQueryJSLoaded()
		{
			((Activity)getContext()).runOnUiThread(new Runnable() {

				@Override
				public void run() {
					addJS_Java_Utils_JS();
				}
				
			});
			
		}
		
		@JavascriptInterface
		public void onJSJavaUtilsLoaded()
		{
			((Activity)getContext()).runOnUiThread(new Runnable() {

				@Override
				public void run() {
					addWrapWordsWithSpansJS();
				}
				
			});
			
		}
		
		@JavascriptInterface
		public void log(String msg)
		{
			Log.d("From JS ", msg);
		}
		
		@JavascriptInterface
		public void onWrapWordsWithSpansJSLoaded()
		{
			((Activity)getContext()).runOnUiThread(new Runnable() {

				@Override
				public void run() {
					if(GlobalSettings.HIGHLIGHT_SWITCH)
					{
						loadUrl("javascript: bindDocumentTouch()");
					}
					else
					{
						loadUrl("javascript: unbindDocumentTouch()");
					}
					getAllHighlights();
				}
				
			});
			
		}
		
		@JavascriptInterface
		public void saveTextHighlight(String startWordID, String endWordID, String text)
		{
			SharedPreferences pref =  getContext().getSharedPreferences("UGCData", Context.MODE_PRIVATE);
			String jsonArrStr = pref.getString("Highlights", "[]");
			try {
				JSONArray allHighlightsArray = new JSONArray(jsonArrStr);
				
				JSONObject hRecord = new JSONObject();
				hRecord.put("startWordID", startWordID);
				hRecord.put("endWordID",endWordID);
				hRecord.put("chapterIndex", ""+_data.getIndexOfChapter());
				hRecord.put("highlightedText", text);
				allHighlightsArray.put(hRecord);
				
				SharedPreferences.Editor editor = pref.edit();
				editor.putString("Highlights", allHighlightsArray.toString());
				editor.commit();
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Log.d("save highlight :  ","swid : "+startWordID +" ewid : "+endWordID +" text : "+text);
		}
		
	}
	
	private void getAllHighlights() 
	{
		boolean foundHighlightsOnPage = false;
		
		SharedPreferences pref =  getContext().getSharedPreferences("UGCData", Context.MODE_PRIVATE);
		String jsonArrStr = pref.getString("Highlights", "[]");
		try {
			JSONArray allHighlightsArray = new JSONArray(jsonArrStr);
			for(int i =0 ;i<allHighlightsArray.length(); i++)
			{
				JSONObject hRecord = allHighlightsArray.getJSONObject(i);
				if(hRecord.getString("chapterIndex").equalsIgnoreCase(""+_data.getIndexOfChapter()))
				{
					loadUrl("javascript: addHightlight('"+hRecord.getString("startWordID")+"','"+hRecord.getString("endWordID")+"')");
					foundHighlightsOnPage = true;
				}
			}
		}
		catch(JSONException e)
		{
			e.printStackTrace();
		}
		//get all highlights from local storage
		if(foundHighlightsOnPage)
		{
			loadUrl("javascript: drawSavedHighlights()");
		}
	}
	
	private void addJQueryJS() 
	{
		String path = "file:///android_asset/JSLibraries/jquery.min.js";
		String script = "function includeJSFile()"
                               +"{"
                               +"function loadScript(url, callback)"
                               +"{"
                               +"var script = document.createElement('script');"
                               +"script.type = 'text/javascript';"
                               +"script.onload = function () {"
                               +"callback();"
                               +"};"
                               +"script.src = url;"
                               +"(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                               +"}"
                               +"loadScript('"+path+"', function ()"
                               +"{"
                               +"jsInterface.onJQueryJSLoaded()"
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	
	private void addJS_Java_Utils_JS() 
	{
		String path = "file:///android_asset/JSLibraries/js.java.utils.js";
		String script = "function includeJSFile()"
                               +"{"
                               +"function loadScript(url, callback)"
                               +"{"
                               +"var script = document.createElement('script');"
                               +"script.type = 'text/javascript';"
                               +"script.onload = function () {"
                               +"callback();"
                               +"};"
                               +"script.src = url;"
                               +"(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                               +"}"
                               +"loadScript('"+path+"', function ()"
                               +"{"
                               +"jsInterface.onJSJavaUtilsLoaded()"
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	
	private void addWrapWordsWithSpansJS() 
	{
		String path = "file:///android_asset/JSLibraries/wrap.spans.to.words.js";
		String script = "function includeJSFile()"
                               +"{"
                               +"function loadScript(url, callback)"
                               +"{"
                               +"var script = document.createElement('script');"
                               +"script.type = 'text/javascript';"
                               +"script.onload = function () {"
                               +"callback();"
                               +"};"
                               +"script.src = url;"
                               +"(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                               +"}"
                               +"loadScript('"+path+"', function ()"
                               +"{"
                               +"jsInterface.onWrapWordsWithSpansJSLoaded()"
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	

	@Override
	protected void onAttachedToWindow() {
		super.onAttachedToWindow();
	}

	private void calculateNoOfPages()
	{
		int newPageCount = computeHorizontalScrollRange()/getMeasuredWidth();
		getData().setPageCount(newPageCount);
		Log.d("here","total pages in Spine : "+newPageCount+" curr page : "+(getData().getIndexOfPage()+1));
	}

	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) 
	{
		Log.d("here","onScrollChanged : "+getData().getPageCount()+" curr page : "+(getData().getIndexOfPage()+1));
		super.onScrollChanged(l, t, oldl, oldt);
	}

	public void updateFontSize() 
	{
		isURLLoaded = false;
		requestLayout();
		
	}

	
	public void emulateShiftHeld(WebView view)
	{
		try
		{
			KeyEvent shiftPressEvent = new KeyEvent(0, 0, KeyEvent.ACTION_DOWN,
					KeyEvent.KEYCODE_SHIFT_LEFT, 0, 0);
			shiftPressEvent.dispatch(view);


			Toast.makeText(getContext(), "select_text_now", Toast.LENGTH_SHORT).show();
		}
		catch (Exception e)
		{
			Log.e("dd", "Exception in emulateShiftHeld()", e);
		}
	}
	public void selectAndCopyText() {
		try {
			Method m = WebView.class.getMethod("emulateShiftHeld", null);
			m.invoke(this, null);
		} catch (Exception e) {
			e.printStackTrace();

			KeyEvent shiftPressEvent = new KeyEvent(0,0,
					KeyEvent.ACTION_DOWN,KeyEvent.KEYCODE_SHIFT_LEFT,0,0);
			shiftPressEvent.dispatch(this);
		}
	}


	
	

	public void setOnPageChangeListener(OnPageChangeListener _listener) {
		this._listener = _listener;
	}
	public void initWithView(ViewGroup view) 
	{
		addView(view,0);
		_currentView = view;
	}
	/*@SuppressLint("NewApi")
	@Override
	public android.view.ActionMode startActionMode(android.view.ActionMode.Callback callback) {
		// this will start a new, custom Contextual Action Mode, in which you can control
		// the menu options available.
		String name = callback.getClass().toString();
		if (name.contains("SelectActionModeCallback")) {
			mActionModeCallback = callback;
		}
		mActionModeCallback = new CustomActionModeCallback();
		// We haven't actually done anything yet. Send our custom callback 
		// to the superclass so it will be shown on screen.
		return super.startActionModeForChild(this, mActionModeCallback);

	}
	//@SuppressLint("NewApi")
	@SuppressLint("NewApi")
	private class CustomActionModeCallback implements ActionMode.Callback {


		@SuppressLint("NewApi")
		@Override
		public boolean onCreateActionMode(ActionMode mode, Menu menu) {

			MenuInflater inflater = mode.getMenuInflater();
			inflater.inflate(R.menu.context_menu, menu);
			return true;
		}


		@Override
		public boolean onPrepareActionMode(ActionMode mode, Menu menu) {

			return false; // Return false if nothing is done
		}


		@SuppressWarnings("deprecation")
		@Override
		public boolean onActionItemClicked(ActionMode mode, MenuItem item) {

			switch (item.getItemId())
			{
			case R.id.copy:
				mode.finish();
				GlobalConstants.ENABLE_WEB_VIEW_TOUCH = false;
				//get the copied text and print to log
				int sdk = android.os.Build.VERSION.SDK_INT;
				if(sdk < android.os.Build.VERSION_CODES.HONEYCOMB) {
					android.text.ClipboardManager clipboard = (android.text.ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
					clipboard.setText("text to clip");
				} else {
					android.content.ClipboardManager clipboard = (android.content.ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE); 
					android.content.ClipData clip = android.content.ClipData.newPlainText("text label","text to clip");
					clipboard.setPrimaryClip(clip);
				}

				selectAndCopyText();
				return true;
			case R.id.button2:

				mode.finish();
				return true;


			default:
				mode.finish();
				return false;
			}
		}

		@Override
		public void onDestroyActionMode(ActionMode mode) {
			clearFocus();
			mActionModeCallback  = null;
		}


	}
	 */

	public void setViewPager(MyViewPager _viewpager) {
		this._viewpager = _viewpager;
	}


	class MyGestureDetector extends SimpleOnGestureListener implements OnTouchListener
	{
		Context context;
		GestureDetector gDetector;
		MyWebView _mWebView;
		static final int SWIPE_MIN_DISTANCE = 120;
		static final int SWIPE_MAX_OFF_PATH = 250;
		static final int SWIPE_THRESHOLD_VELOCITY = 200;

		public MyGestureDetector() {
			super();
		}

		public MyGestureDetector(Context context) {
			this(context, null);
		}

		public MyGestureDetector(Context context, GestureDetector gDetector) {

			if (gDetector == null)
				gDetector = new GestureDetector(context, this);

			this.context = context;
			this.gDetector = gDetector;
		}

		@Override
		public boolean onTouch(View v, MotionEvent event) 
		{
			return gDetector.onTouchEvent(event);
		}

		public GestureDetector getDetector() {
			return gDetector;
		}

		@Override
		public boolean onDown(MotionEvent e) {
			// TODO Auto-generated method stub
			return true;
		}

		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {

			if (Math.abs(velocityX) < SWIPE_THRESHOLD_VELOCITY)
			{
				return false;
			}
			if (e1.getX() - e2.getX() > SWIPE_MIN_DISTANCE) 
			{
				if(!GlobalSettings.HIGHLIGHT_SWITCH)
				{
					_viewpager.onSwipeLeft();
				}
				
			} else if (e2.getX() - e1.getX() > SWIPE_MIN_DISTANCE) 
			{
				if(!GlobalSettings.HIGHLIGHT_SWITCH)
				{
					_viewpager.onSwipeRight();
				}
			}


			return super.onFling(e1, e2, velocityX, velocityY);

		}
		@Override
		public void onLongPress(MotionEvent e) {
			// TODO Auto-generated method stub
			super.onLongPress(e);
			
			onLongClick(_mWebView);
		}
		public boolean onLongClick(View v) {
			
			if(actionMode == null)
		        actionMode =  startActionMode(new QuoteCallback());
		    return true;
			
		   
		}
	
		class QuoteCallback implements ActionMode.Callback {

		    @SuppressLint("NewApi")
			public boolean onCreateActionMode(ActionMode mode, Menu menu) {
		        MenuInflater inflater = mode.getMenuInflater();
		        inflater.inflate(R.menu.context_menu, menu);
		        return true;
		    }

		    public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
		        return false;
		    }

		    public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
		        switch(item.getItemId()) {

		        case R.id.copy:
		            Log.d("", "Selected menu");
		            mode.finish();
		            // here is where I would grab the selected text
		            return true;
		        }
		        return false;
		    }

		    public void onDestroyActionMode(ActionMode mode) {
		        actionMode = null;
		    }
		}
	}

	public void onClickHighlightSwitch() 
	{
		GlobalSettings.HIGHLIGHT_SWITCH = !GlobalSettings.HIGHLIGHT_SWITCH;
		if(GlobalSettings.HIGHLIGHT_SWITCH)
		{
			loadUrl("javascript: bindDocumentTouch()");
		}
		else
		{
			loadUrl("javascript: unbindDocumentTouch()");
		}
	}

}
