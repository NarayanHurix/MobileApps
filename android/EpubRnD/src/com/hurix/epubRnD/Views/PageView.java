package com.hurix.epubRnD.Views;


import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.hurix.epubRnD.R;
import com.hurix.epubRnD.Views.MyWebView.MyWebViewLoadListener;

public class PageView extends RelativeLayout implements MyWebViewLoadListener
{
	private MyWebView _mWebView;
	private ProgressBar _mProgressBar;
	private MyViewFlipper _mMyViewPager;
	private BookmarkView _bookMarkView;
	
	public PageView(Context context,MyViewFlipper myViewPager) {
		super(context);
		_mMyViewPager = myViewPager;
		init(context);
	}

	public PageView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public PageView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}
	
	private void init(Context context)
	{
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.page_view, this);
		_mWebView = (MyWebView) findViewById(R.id.myWebView);
		_mWebView.setViewPager(_mMyViewPager);
		_mWebView.setMyWebViewLoadListener(this);
		_mProgressBar = (ProgressBar)findViewById(R.id.pageLoadingProgressWheel);
		_bookMarkView = new BookmarkView(context);
		_bookMarkView.setListener(_mWebView);
		RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		params.addRule(RelativeLayout.ALIGN_PARENT_TOP);
		params.rightMargin = 20;
		_bookMarkView.setLayoutParams(params);
		addView(_bookMarkView);
		_mWebView.setBookmarkView(_bookMarkView);
	}

	public MyWebView getWebView()
	{
		return _mWebView;
	}
	
	public ProgressBar getProgressBar()
	{
		return _mProgressBar;
	}

	@Override
	public void onLoadFinish() 
	{
		_mWebView.setVisibility(View.VISIBLE);
		_mProgressBar.setVisibility(View.INVISIBLE);
		_bookMarkView.bringToFront();
	}
	
	public void updateFontSize()
	{
		_mWebView.updateFontSize();
	}

	public void onClickHighlightSwitch()
	{
		_mWebView.onClickHighlightSwitch();
	}
	
	@Override
	public void onLoadStart() {
		_mWebView.setVisibility(View.INVISIBLE);
		_mProgressBar.setVisibility(View.VISIBLE);
		cleanPageMarkups();
	}
	
	@Override
	public void onPageOutOfRange() 
	{
		_mMyViewPager.onPageOutOfRange();
	}
	
	@Override
	public void checkPageBuffer()
	{
		_mMyViewPager.checkPageBuffer();
	}

	public void validateSingleTap(MotionEvent e) 
	{
		for(int i=0;i<getChildCount();i++)
		{
			View v = getChildAt(i);
			Rect r = new Rect(v.getLeft(),v.getTop(),v.getRight(),v.getBottom());
			if(r.contains((int)e.getX(),(int) e.getY()))
			{
				if(v.getClass() == StickyNoteIconView.class)
				{
					((StickyNoteIconView)v).onSingleTapConfirmed(e);
					break;
				}
				else if(v.getClass() == BookmarkView.class)
				{
					((BookmarkView)v).onSingleTapConfirmed(e);
				}
			}
		}
	}
	
	public BookmarkView getBookmarkView()
	{
		return _bookMarkView;
	}
	
	private void cleanPageMarkups()
	{
		for(int i=0; i<getChildCount();i++)
		{
			View view = getChildAt(i);
			if(view.getClass().equals(StickyNoteIconView.class))
			{
				removeView(view);
			}
		}
	}
}
