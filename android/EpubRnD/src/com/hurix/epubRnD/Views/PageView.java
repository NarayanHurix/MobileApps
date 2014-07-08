package com.hurix.epubRnD.Views;


import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
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
	}
	
	@Override
	public void onPageOutOfRange() 
	{
		_mMyViewPager.onPageOutOfRange();
	}
}
