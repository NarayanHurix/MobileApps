package com.hurix.epubRnD.Views;

import com.hurix.epubRnD.Settings.GlobalSettings;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.RelativeLayout;

public class TopMostLayout extends RelativeLayout 
{
	
	private MyViewFlipper _myViewFlipper= null;

	public TopMostLayout(Context context) {
		super(context);
		init(context);
	}

	public TopMostLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public TopMostLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	private void init(Context context) 
	{
		
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) 
	{
		if(this._myViewFlipper != null && ((PageView)this._myViewFlipper.getCurrentPageView())!= null && ((PageView)this._myViewFlipper.getCurrentPageView()).getWebView() != null)
		{
			((PageView)this._myViewFlipper.getCurrentPageView()).getWebView().onTouchEvent(event);
		}
		if(GlobalSettings.HIGHLIGHT_SWITCH)
		{
			super.onTouchEvent(event);
			return false;
		}
		return true;
	}
	
	public void setMyViewFlipper(MyViewFlipper _myViewFlipper) 
	{
		this._myViewFlipper = _myViewFlipper;
	}
	
}