package com.hurix.epubRnD.Views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

public class MyViewPager extends RelativeLayout {//implements GestureDetector.OnGestureListener{

//	private final GestureDetector gestureDetector;
//	private static final int SWIPE_THRESHOLD = 100;
//    private static final int SWIPE_VELOCITY_THRESHOLD = 100;
    private OnPageChangeListener _listener;
    private PageView _currentView;
    
    public interface OnPageChangeListener
    {
    	public abstract PageView getPreviousView(PageView oldView);
    	public abstract PageView getNextView(PageView oldView);
    }
    
	public MyViewPager(Context context) {
		super(context);
		//gestureDetector = new GestureDetector(context,this);
		init(context);
	}

	public MyViewPager(Context context, AttributeSet attrs) {
		super(context, attrs);
		//gestureDetector = new GestureDetector(context,this);
		init(context);
	}

	public MyViewPager(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		//gestureDetector = new GestureDetector(context,this);
		init(context);
	}

	/*@Override
	public boolean onTouchEvent(MotionEvent event) {
		//return gestureDetector.onTouchEvent(event);
		return false;
	}*/
	private void init(Context context)
	{
		
	}
	/*@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		// TODO Auto-generated method stub
		GlobalConstants.ENABLE_WEB_VIEW_TOUCH = false;
		return super.onInterceptTouchEvent(ev);
	}*/
	public void onSwipeLeft() 
	{
		if(_listener != null)
		{
			PageView currentView =_listener.getNextView(_currentView);
			removeAllViews();
			addView(currentView,0);
			_currentView = currentView;
		}
	}
	public void onSwipeRight() 
	{
		if(_listener != null)
		{
			PageView currentView =_listener.getPreviousView(_currentView);
			removeAllViews();
			addView(currentView,0);
			_currentView = currentView;
		}
		
	}
	
//	@Override
//	public boolean onDown(MotionEvent e) {
//		// TODO Auto-generated method stub
//		return true;
//	}
//	@Override
//	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
//			float velocityY) {
//		 boolean result = false;
//	     try {
//	         float diffY = e2.getY() - e1.getY();
//	         float diffX = e2.getX() - e1.getX();
//	         if (Math.abs(diffX) > Math.abs(diffY)) {
//	             if (Math.abs(diffX) > SWIPE_THRESHOLD && Math.abs(velocityX) > SWIPE_VELOCITY_THRESHOLD) {
//	                 if (diffX > 0) {
//	                     onSwipeRight();
//	                 } else {
//	                     onSwipeLeft();
//	                 }
//	             }
//	         } else {
//	             if (Math.abs(diffY) > SWIPE_THRESHOLD && Math.abs(velocityY) > SWIPE_VELOCITY_THRESHOLD) {
//	                 if (diffY > 0) {
//	                     //onSwipeBottom();
//	                 } else {
//	                    // onSwipeTop();
//	                 }
//	             }
//	         }
//	     } catch (Exception exception) {
//	         exception.printStackTrace();
//	     }
//	     return result;
//	}
//	@Override
//	public void onLongPress(MotionEvent e) {
//		
//		//GlobalConstants.ENABLE_WEB_VIEW_TOUCH = true;
//	}
//	@Override
//	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
//			float distanceY) {
//		// TODO Auto-generated method stub
//		return false;
//	}
//	@Override
//	public void onShowPress(MotionEvent e) {
//		// TODO Auto-generated method stub
//		
//	}
//	@Override
//	public boolean onSingleTapUp(MotionEvent e) {
//		// TODO Auto-generated method stub
//		return false;
//	}



	public void setOnPageChangeListener(OnPageChangeListener _listener) {
		this._listener = _listener;
	}

	public void initWithView(PageView view) 
	{
		addView(view,0);
		_currentView = view;
	}
	
	public ViewGroup getCurrentPageView()
	{
		return _currentView;
	}
	
	public void onPageOutOfRange()
	{
		onSwipeRight();//load last page of same chapter
	}
}