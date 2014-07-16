package com.hurix.epubRnD.Views;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.util.Log;
import android.view.ActionMode;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;

import com.hurix.epubRnD.R;
import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Settings.GlobalSettings;
import com.hurix.epubRnD.VOs.WebViewDAO;
import com.hurix.epubRnD.widgets.QuickAction;
import com.hurix.epubRnD.widgets.QuickAction.OnDismissListener;

@SuppressLint("NewApi")
public class MyWebView extends WebView implements OnDismissListener,OnClickListener
{
	
	private WebViewDAO _data;
	private boolean isURLLoaded = false;
	private MyWebViewLoadListener _mMyWebViewLoadListener;
	

	private static final int SWIPE_THRESHOLD = 100;
	private static final int SWIPE_VELOCITY_THRESHOLD = 100;
	private OnPageChangeListener _listener;
	private ViewGroup _currentView;
    private MyViewFlipper _viewpager;
    Object actionMode;
    
    private float stickHeight;
    private float stickWidth;
	public interface OnPageChangeListener
	{
		public abstract ViewGroup getPreviousView(ViewGroup oldView);
		public abstract ViewGroup getNextView(ViewGroup oldView);
	}
	GestureDetector gestureDetector = new GestureDetector(new MyGestureDetector());
	private StartStickView startStick;
	private EndStickView endStick;
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
		public abstract void checkPageBuffer();
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
		if(event.getAction() == MotionEvent.ACTION_DOWN)
		{
			onScrollChanged(getScrollX(), getScrollY(), getScrollX(), getScrollY());
		}
	/*	gestureDetector.onTouchEvent(event);
        return super.onTouchEvent(event);*/
	//	return   super.onTouchEvent(event);
		if(GlobalSettings.HIGHLIGHT_SWITCH)
		{
			return super.onTouchEvent(event);
		}
		else
		{
			//if(gestureDetector.onTouchEvent(event))
			//enable it for build in zoom feature of webview
//			if(event.getPointerCount()>1)
//			{
//				return super.onTouchEvent(event);
//			}
			if(_viewpager.touch(event))
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

	@SuppressLint({ "NewApi", "SetJavaScriptEnabled" })
	private void init(Context context)
	{
		isURLLoaded = false;
		stickWidth = 20 *getContext().getResources().getDisplayMetrics().density;
		stickHeight = 40*getContext().getResources().getDisplayMetrics().density;
		if(android.os.Build.VERSION.SDK_INT>=android.os.Build.VERSION_CODES.HONEYCOMB)
		{
			getSettings().setAllowContentAccess(true);
		}
		
		getSettings().setJavaScriptEnabled(true);
		if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
		{
			if(android.os.Build.VERSION.SDK_INT>=android.os.Build.VERSION_CODES.ICE_CREAM_SANDWICH)
			{
				//setFitsSystemWindows(true);
			}
			getSettings().setUseWideViewPort(true);
			getSettings().setLoadWithOverviewMode(true);
//			setScrollBarStyle(View.SCROLLBARS_OUTSIDE_OVERLAY);
			getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
		}
		else
		{
			setScrollBarStyle(View.SCROLLBARS_OUTSIDE_OVERLAY);
			getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
			getSettings().setMinimumFontSize(GlobalConstants.MIN_FONT_SIZE);
			getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);
			setHorizontalScrollBarEnabled(false);
			setVerticalScrollBarEnabled(false);
		}
		
		getSettings().setAllowFileAccess(true);
		//		getSettings().setRenderPriority(RenderPriority.HIGH);
		//		getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		
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
					if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
					{
						
					}
					else
					{
						getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);
					}

					loadUrl(getData().getChapterVO().getChapterURL());
					isURLLoaded = true;

				}
			}
		});

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

			if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
			{
				
			}
			else
			{
				String varMySheet = "var mySheet = document.styleSheets[0];";

				String addCSSRule = "function addCSSRule(selector, newRule) {"
						+ "ruleIndex = mySheet.cssRules.length;"
						+ "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"

						+ "}";

				String insertRule1 = "addCSSRule('html', 'padding: 0px; height: "
						+ (myWebView.getMeasuredHeight()/getContext().getResources().getDisplayMetrics().density )
						+ "px; -webkit-column-gap: 0px; -webkit-column-width: "
						+ myWebView.getMeasuredWidth() + "px;')";

				//String insertRule2 = "addCSSRule('p', 'text-align: justify;')";

				//String setImageRule = "addCSSRule('img', 'max-width: "+  (myWebView.getMeasuredWidth() -200)+"px; height:"+(myWebView.getMeasuredHeight() - 200)+"px')";

				myWebView.loadUrl("javascript:" + varMySheet);
				myWebView.loadUrl("javascript:" + addCSSRule);
				myWebView.loadUrl("javascript:" + insertRule1);
//				myWebView.loadUrl("javascript:" + insertRule2);
				//myWebView.loadUrl("javascript:" + setImageRule);
				
			}
			String data = "{\"MethodName\":\"paginationDone\",\"MethodArguments\":{}}";
			String callBackToNative  = "jsInterface.callNativeMethod('jstoobjc:"+data+"');";
			
			myWebView.loadUrl("javascript: "+callBackToNative);
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
						
						if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
						{
							_mMyWebViewLoadListener.onLoadFinish();
						}
						else
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
					}
				},300);
			}
		}
	}

	class JSLoadCallBack 
	{
		
		@JavascriptInterface
		public void callNativeMethod(String text)
		{
			String jsonData = text.replace("jstoobjc:", "");
			try
			{
				JSONObject jObj= new JSONObject(jsonData);
				final String methodName = jObj.getString("MethodName");
				final JSONObject argsJsonObj = jObj.getJSONObject("MethodArguments");
				((Activity)getContext()).runOnUiThread(new Runnable() 
				{
					@Override
					public void run() 
					{
						try
						{
							if(methodName.equals("paginationDone"))
							{
								paginationDone();
							}
							else if(methodName.equals("onJQueryJSLoaded"))
							{
								onJQueryJSLoaded();
							}
							else if(methodName.equals("onJSJavaUtilsLoaded"))
							{
								onJSJavaUtilsLoaded();
							}
							else if(methodName.equals("onWrapWordsWithSpansJSLoaded"))
							{
								onWrapWordsWithSpansJSLoaded();
							}
							else if(methodName.equals("onWordHighlightManagerJS"))
							{
								onWordHighlightManagerJS();
							}
							else if(methodName.equals("saveTextHighlight"))
							{
								saveTextHighlight(argsJsonObj.getString("arg1"),argsJsonObj.getString("arg2"),argsJsonObj.getString("arg3"));
							}
							else if(methodName.equals("onTouchStart"))
							{
								highlightActionDown();
							}
							else if(methodName.equals("onTouchEnd"))
							{
								highlightActionUp();
							}
							else if(methodName.equals("updateHighlightSticksPositions"))
							{
								float sX = Float.parseFloat(argsJsonObj.getString("arg1"));
								float sY = Float.parseFloat(argsJsonObj.getString("arg2"));
								float sW = Float.parseFloat(argsJsonObj.getString("arg3"));
								float sH = Float.parseFloat(argsJsonObj.getString("arg4"));
								float eX = Float.parseFloat(argsJsonObj.getString("arg5"));
								float eY = Float.parseFloat(argsJsonObj.getString("arg6"));
								float eW = Float.parseFloat(argsJsonObj.getString("arg7"));
								float eH = Float.parseFloat(argsJsonObj.getString("arg8"));
								updateHighlightSticksPosition(sX,sY,sW,sH,eX,eY,eW,eH);
								
							}
							else if(methodName.equals(""))
							{
								
							}
							else if(methodName.equals(""))
							{
								
							}
							
						}
						catch(JSONException e)
						{
							e.printStackTrace();
						}
					}
				});
			}
			catch(JSONException e)
			{
				e.printStackTrace();
			}
		}
		
		@JavascriptInterface
		public void log(String msg)
		{
			Log.d("From JS ", msg);
		}
		
		private void paginationDone()
		{
			//disable default webview text selection feature
			loadUrl("javascript: document.documentElement.style.webkitUserSelect='none'");
			addJQueryJS();
			_mMyWebViewLoadListener.checkPageBuffer();
		}
		
		private void onJQueryJSLoaded()
		{
			addJS_Java_Utils_JS();
		}
		
		private void onJSJavaUtilsLoaded()
		{
			addWrapWordsWithSpansJS();
		}
		
		private void onWrapWordsWithSpansJSLoaded()
		{
			addWordHighlightManagerJS();
		}
		
		private void onWordHighlightManagerJS()
		{
			try
			{
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
			catch(Exception e)
			{
				//webview has already been destroyed
				e.printStackTrace();
			}
		}
		
		private void saveTextHighlight(String startWordID, String endWordID, String text)
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
		String data = "{\"MethodName\":\"onJQueryJSLoaded\",\"MethodArguments\":{}}";
		String callBackToNative  = " jsInterface.callNativeMethod('jstoobjc:"+data+"');";
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
                               +callBackToNative
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	
	private void addJS_Java_Utils_JS() 
	{
		String path = "file:///android_asset/JSLibraries/js.java.utils.js";
		String data = "{\"MethodName\":\"onJSJavaUtilsLoaded\",\"MethodArguments\":{}}";
		String callBackToNative  = " jsInterface.callNativeMethod('jstoobjc:"+data+"');";
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
                               +callBackToNative
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	
	private void addWrapWordsWithSpansJS() 
	{
		String path = "file:///android_asset/JSLibraries/wrap.spans.to.words.js";
		String data = "{\"MethodName\":\"onWrapWordsWithSpansJSLoaded\",\"MethodArguments\":{}}";
		String callBackToNative  = " jsInterface.callNativeMethod('jstoobjc:"+data+"');";
		
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
                               +callBackToNative
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	
	private void addWordHighlightManagerJS() 
	{
		String path = "file:///android_asset/JSLibraries/word.highlights.manager.js";
		String data = "{\"MethodName\":\"onWordHighlightManagerJS\",\"MethodArguments\":{}}";
		String callBackToNative  = " jsInterface.callNativeMethod('jstoobjc:"+data+"');";
		
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
                               +callBackToNative
                               +"});"
                               +"} ; includeJSFile();";
		loadUrl("javascript: "+script);
	}
	

	private void calculateNoOfPages()
	{
		if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
		{
			
		}
		else
		{
			if(getMeasuredWidth() != 0)
			{
				int newPageCount = computeHorizontalScrollRange()/getMeasuredWidth();
				getData().setPageCount(newPageCount);
				//Log.d("here","total pages in Spine : "+newPageCount+" curr page : "+(getData().getIndexOfPage()+1));
			}
		}
	}

	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) 
	{
		super.onScrollChanged(l, t, oldl, oldt);
	}

	public void updateFontSize() 
	{
		isURLLoaded = false;
		requestLayout();
	}

	
	

	public void setOnPageChangeListener(OnPageChangeListener _listener) {
		this._listener = _listener;
	}
	private void initWithView(ViewGroup view) 
	{
		addView(view,0);
		_currentView = view;
	}
	public void setViewPager(MyViewFlipper _viewpager) {
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
			_viewpager.touch(event);
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
			loadUrl("javascript: clearCurrentHighlight()");
			closeHighlight();
			
		}
	}
	private QuickAction _popUp;
	
	private void updateHighlightSticksPosition(float sX, float sY, float sW, float sH, float eX, float eY, float eW, float eH)
	{
		stickHeight = sH;
		sX = sX * getContext().getResources().getDisplayMetrics().density;
		sY = sY * getContext().getResources().getDisplayMetrics().density;
		sW = sW * getContext().getResources().getDisplayMetrics().density;
		sH = sH * getContext().getResources().getDisplayMetrics().density;
		eX = eX * getContext().getResources().getDisplayMetrics().density;
		eY = eY * getContext().getResources().getDisplayMetrics().density;
		eW = eW * getContext().getResources().getDisplayMetrics().density;
		eH = eH * getContext().getResources().getDisplayMetrics().density;
		float modifiedX, modifiedY;
		
	    if(startStick == null)
	    {
	        startStick = new StartStickView(getContext());
	        ((PageView)getParent().getParent()).addView(startStick);
	    }
	    modifiedX = sX-stickWidth - (getMeasuredWidth()*_data.getIndexOfPage());
        modifiedY = sY-stickHeight/2;
	    RelativeLayout.LayoutParams params1 = new RelativeLayout.LayoutParams((int)stickWidth, (int)stickHeight);
        params1.leftMargin = (int)(modifiedX+3);
        params1.topMargin = (int)(modifiedY);
        startStick.setLayoutParams(params1);
        
	    stickHeight = eH;
	    if(endStick == null)
	    {
	        endStick = new EndStickView(getContext());
	        ((PageView)getParent().getParent()).addView(endStick);
	    }
	    modifiedX = eX - (getMeasuredWidth()*_data.getIndexOfPage());
    	modifiedY = eY-stickHeight/2;
	    RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)stickWidth, (int)stickHeight);
        params2.leftMargin = (int)(modifiedX-3);
        params2.topMargin = (int)(modifiedY);
        endStick.setLayoutParams(params2);
        
	    startStick.bringToFront();
	    endStick.bringToFront();
	    if(_popUp == null)
	    {
	    	_popUp = new QuickAction(getContext());
	    	_popUp.setAlertLayout(R.layout.highlight_popup);
	    	_popUp.setOnDismissListener(this);
	    	_popUp.getDialog().setCanceledOnTouchOutside(false);
	    	Window window = _popUp.getDialog().getWindow();
	        window.setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
	                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
	        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
	        
	        _popUp.findViewById(R.id.highlightSaveBtn).setOnClickListener(this);
	        _popUp.findViewById(R.id.highlightClearBtn).setOnClickListener(this);
	    }
	}
	
	

	private void highlightActionDown()
	{
		if(_popUp != null)
		{
			_popUp.dismiss();
		}
	}
	
	private void highlightActionUp()
	{
		if(_popUp != null)
		{
			if(startStick != null)
			{
				startStick.post(new Runnable() 
		    	{
					@Override
					public void run() {
						try {
							_popUp.show(startStick);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				});
			}
		}
	}
	
	@Override
	public void onDismiss() 
	{
		
	}
	
	private void closeHighlight()
	{
		if(_popUp != null)
		{
			_popUp.dismiss();
			_popUp = null;
		}
		
		if(startStick != null)
		{
			((ViewGroup)startStick.getParent()).removeView(startStick);
			startStick = null;
		}
		if(endStick != null)
		{
			((ViewGroup)endStick.getParent()).removeView(endStick);
			endStick = null;
		}
		if(GlobalSettings.HIGHLIGHT_SWITCH)
		{
			onClickHighlightSwitch();
		}
	}

	@Override
	public void onClick(View v) 
	{
		switch (v.getId()) 
		{
			case R.id.highlightSaveBtn:
				loadUrl("javascript: saveCurrentHighlight()");
				closeHighlight();
				break;
			case R.id.highlightClearBtn:
				loadUrl("javascript: clearCurrentHighlight()");
				closeHighlight();
				break;
			default:
				break;
		}
	}
}
