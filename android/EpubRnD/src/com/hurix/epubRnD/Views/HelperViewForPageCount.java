package com.hurix.epubRnD.Views;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Settings.GlobalSettings;
import com.hurix.epubRnD.VOs.ChapterVO;

public class HelperViewForPageCount extends WebView {
	private PageCountListener _listener;

	public HelperViewForPageCount(Context context) {
		super(context);
		init(context);
	}

	public HelperViewForPageCount(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public HelperViewForPageCount(Context context, AttributeSet attrs,
			int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	public interface PageCountListener {
		public abstract void onPageCountComplete(int count);
	}
	
	@SuppressLint({ "NewApi", "SetJavaScriptEnabled" })
	private void init(Context context) {
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
		
		setWebViewClient(new MyWebClient());
		setWebChromeClient(new MyWebChromeClient());
		
		setHorizontalScrollBarEnabled(false);
		setVerticalScrollBarEnabled(false);
		if(android.os.Build.VERSION.SDK_INT>=android.os.Build.VERSION_CODES.JELLY_BEAN)
		{
			getSettings().setAllowUniversalAccessFromFileURLs(true);
		}
	}

	public boolean startPageCounting(PageCountListener listener, ArrayList<ChapterVO> chaptersColl) 
	{
		_chaptersColl = null;
		_currChapterIndex = -1;
		totalPageCountInBook= 0;
		
		_listener = listener;
		_chaptersColl = chaptersColl;
		if(_chaptersColl != null && _listener != null)
		{
			countPagesInChapter();
			return true;
		}
		return false;
	}

	ArrayList<ChapterVO> _chaptersColl;
	private int _currChapterIndex = -1;
	private ChapterVO _currChapterVO = null;
	private int totalPageCountInBook;
	
	private void countPagesInChapter()
	{
		
		if(_currChapterIndex == -1 && _currChapterVO == null)
		{
			_currChapterIndex = 0;
			totalPageCountInBook= 0;
			_currChapterVO = _chaptersColl.get(_currChapterIndex);
			
			if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
			{
				totalPageCountInBook = 1;
				_currChapterVO.setPageCount(1);
				countPagesInChapter();
			}
			else
			{
				getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);
				loadUrl(_currChapterVO.getChapterURL());
			}
			
		}
		else if(_currChapterIndex == _chaptersColl.size()-1)
		{
			_listener.onPageCountComplete(totalPageCountInBook);
		}
		else
		{
			_currChapterIndex++;
			_currChapterVO = _chaptersColl.get(_currChapterIndex);
			if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
			{
				totalPageCountInBook +=1;
				_currChapterVO.setPageCount(1);
				countPagesInChapter();
			}
			else
			{
				getSettings().setDefaultFontSize(GlobalSettings.FONT_SIZE);
				loadUrl(_currChapterVO.getChapterURL());
			}
		}
	}
	
	private class MyWebClient extends WebViewClient
	{
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
		}
		@Override
		public void onPageFinished(WebView view, String url) 
		{
			super.onPageFinished(view, url);


			if(GlobalSettings.EPUB_LAYOUT_TYPE==GlobalConstants.FIXED)
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
						+ (view.getMeasuredHeight()/getContext().getResources().getDisplayMetrics().density )
						+ "px; -webkit-column-gap: 0px; -webkit-column-width: "
						+ view.getMeasuredWidth() + "px;')";

				String insertRule2 = "addCSSRule('p', 'text-align: justify;')";

				view.loadUrl("javascript:" + varMySheet);
				view.loadUrl("javascript:" + addCSSRule);
				view.loadUrl("javascript:" + insertRule1);
				view.loadUrl("javascript:" + insertRule2);
			}
		}
	}
	private int delayBeforeFirstChapterPageCount = 300;
	private class MyWebChromeClient extends WebChromeClient
	{
		@Override
		public void onProgressChanged(WebView view, int newProgress) 
		{
			super.onProgressChanged(view, newProgress);
			if(newProgress == 100)
			{
				postDelayed(new Runnable() 
				{
					@Override
					public void run() 
					{
						if(GlobalSettings.EPUB_LAYOUT_TYPE==GlobalConstants.FIXED)
						{
							
						}
						else
						{
							if(getMeasuredWidth() != 0)
							{
								if(totalPageCountInBook == 0)
								{
									delayBeforeFirstChapterPageCount = 100;
								}
								int newPageCount = computeHorizontalScrollRange()/getMeasuredWidth();
								totalPageCountInBook = totalPageCountInBook + newPageCount;
								_currChapterVO.setPageCount(newPageCount);
								countPagesInChapter();
							}
						}
					}
				},delayBeforeFirstChapterPageCount);
			}
		}
	}
}
