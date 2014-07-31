package com.hurix.epubRnD.Views;

import android.content.Context;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.GestureDetector.OnGestureListener;
import android.view.MotionEvent;
import android.widget.RelativeLayout;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Settings.GlobalSettings;

public class FixedTopMostLayout extends RelativeLayout implements OnGestureListener
{
	
	private MyViewFlipper _myViewFlipper= null;
	private GestureDetector _gestureDetector;
	
	public FixedTopMostLayout(Context context) {
		super(context);
		init(context);
	}

	public FixedTopMostLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public FixedTopMostLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	private void init(Context context) 
	{
		_gestureDetector = new GestureDetector(getContext(), this);
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
		_gestureDetector.onTouchEvent(event);
		return true;
	}
	
	public void setMyViewFlipper(MyViewFlipper _myViewFlipper) 
	{
		this._myViewFlipper = _myViewFlipper;
	}

	@Override
	public boolean onDown(MotionEvent e) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void onLongPress(MotionEvent e) 
	{
		if(!GlobalSettings.HIGHLIGHT_SWITCH)
		{
			((PageView)this._myViewFlipper.getCurrentPageView()).onClickHighlightSwitch();
			MyWebView webView = ((PageView)this._myViewFlipper.getCurrentPageView()).getWebView();
			int pageX = (int) (e.getX()/getContext().getResources().getDisplayMetrics().density);
			pageX = pageX + (webView.getMeasuredWidth()*webView.getData().getIndexOfPage());
			int pageY = (int) (e.getY()/getContext().getResources().getDisplayMetrics().density);
			webView.triggerNewHighlight(pageX,pageY);
		}
	}

	@Override
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
			float distanceY) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void onShowPress(MotionEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean onSingleTapUp(MotionEvent e) {
		((PageView)this._myViewFlipper.getCurrentPageView()).validateSingleTap(e);
		return false;
	}
	
}