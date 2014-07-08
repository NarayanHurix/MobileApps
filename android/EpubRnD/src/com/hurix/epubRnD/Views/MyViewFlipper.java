package com.hurix.epubRnD.Views;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.TranslateAnimation;
import android.widget.RelativeLayout;

public class MyViewFlipper extends RelativeLayout {//implements GestureDetector.OnGestureListener{

//	private final GestureDetector gestureDetector;
//	private static final int SWIPE_THRESHOLD = 100;
//    private static final int SWIPE_VELOCITY_THRESHOLD = 100;
    private OnPageChangeListener _listener;
    private PageView _currentView,_adjucentNext,_adjucentPrev;
    private int MIN_MOVE_TO_CHANGE_PAGE = 60;
    private int PAGE_ADJUST_ANIM_DURATION= 500;
    
    public interface OnPageChangeListener
    {
    	public abstract PageView getPreviousView(PageView oldView);
    	public abstract PageView getNextView(PageView oldView);
    }
    
	public MyViewFlipper(Context context) {
		super(context);
		//gestureDetector = new GestureDetector(context,this);
		init(context);
	}

	public MyViewFlipper(Context context, AttributeSet attrs) {
		super(context, attrs);
		//gestureDetector = new GestureDetector(context,this);
		init(context);
	}

	public MyViewFlipper(Context context, AttributeSet attrs, int defStyle) {
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

	Point startTouchPoint ,endTouchPoint;
	int offsetX,offsetY;
	
	
	public boolean touch(MotionEvent e1)
	{
		switch (e1.getAction()) 
		{
			case MotionEvent.ACTION_DOWN:
				offsetX = 0;
				offsetY = 0;
				startTouchPoint = new Point((int)e1.getX() , (int)e1.getY());
				if(_adjucentNext == null)
				{
					_adjucentNext = _listener.getNextView(_currentView);
					if(_adjucentNext != null)
					{
						addView(_adjucentNext);
						RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
						params.leftMargin = getMeasuredWidth();
						_adjucentNext.setLayoutParams(params);
					}
				}
				break;
				
			case MotionEvent.ACTION_MOVE:
				
				if(startTouchPoint.x>e1.getX())
				{
					//moving to next page
					if(_adjucentNext != null)
					{
						offsetX = (int)(e1.getX() - startTouchPoint.x);
						positionPages(offsetX,offsetY);
					}
				}
				else if(startTouchPoint.x<e1.getX())
				{
					//moving to previous page
					if(_adjucentPrev != null)
					{
						offsetX = (int)(e1.getX() - startTouchPoint.x);
						positionPages(offsetX,offsetY);
					}
				}
				
				break;
				
			case MotionEvent.ACTION_UP:
				endTouchPoint = new Point((int)e1.getX() , (int)e1.getY());
				
				if((startTouchPoint.x-endTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE )
				{
					//flip success
	                //moving forward direction
					if(_listener.getNextView(_currentView) != null)
					{
						//complete remaining page move animation
						((Activity)getContext()).runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								completeNextPageAnim();
							}
						});
						
					}
					
				}
				else if((endTouchPoint.x-startTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE)
				{
					//flip success
	                //moving backward direction
					if(_listener.getPreviousView(_currentView) != null)
					{
						//complete remaining page move animation
						((Activity)getContext()).runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								completePreviousPageAnim();
							}
						});
						
					}
				}
				else
				{
					offsetX = 0;
					positionPages(offsetX,offsetY);
				}
					
				break;
	
			default:
				break;
		}
		
		return true;
	}
	
	private void positionPages(int offsetX,int offsetY)
	{
		if(_currentView != null)
		{
			RelativeLayout.LayoutParams paramsCurrentPage = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
			paramsCurrentPage.leftMargin= offsetX;
			paramsCurrentPage.rightMargin = -offsetX;
			_currentView.setLayoutParams(paramsCurrentPage);
		}
		
		if(_adjucentNext != null)
		{
			RelativeLayout.LayoutParams paramsAdjucentNext = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
			paramsAdjucentNext.leftMargin= getMeasuredWidth() + offsetX;
			paramsAdjucentNext.rightMargin = -(getMeasuredWidth() + offsetX);
			_adjucentNext.setLayoutParams(paramsAdjucentNext);
		}
		
		if(_adjucentPrev != null)
		{
			RelativeLayout.LayoutParams paramsAdjucentPrev = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
			paramsAdjucentPrev.leftMargin= -getMeasuredWidth() + offsetX;
			paramsAdjucentPrev.rightMargin = -(-getMeasuredWidth() + offsetX);
			_adjucentPrev.setLayoutParams(paramsAdjucentPrev);
		}
	}
	
	
	
	private void completeNextPageAnim()
	{
		if(Math.abs(offsetX)>=getMeasuredWidth())
	    {
			//add next page remove previous page
			
	    }
	    else
	    {
	    	//positionPages(offsetX,offsetY);
	    	offsetX = -(offsetX + getMeasuredWidth());
	    	TranslateAnimation animCurrPage = new TranslateAnimation(0, offsetX, 0, 0);
	    	animCurrPage.setDuration(PAGE_ADJUST_ANIM_DURATION);
	    	animCurrPage.setAnimationListener(new AnimationListener() {
				
				@Override
				public void onAnimationStart(Animation animation) {}
				
				@Override
				public void onAnimationRepeat(Animation animation) {}
				
				@Override
				public void onAnimationEnd(Animation animation) {}
					
				
			});
	    	TranslateAnimation animNextPage = new TranslateAnimation(0, offsetX, 0, 0);
	    	animNextPage.setDuration(PAGE_ADJUST_ANIM_DURATION);
	    	animNextPage.setAnimationListener(new AnimationListener() {
				
				@Override
				public void onAnimationStart(Animation animation) {
					
				}
				
				@Override
				public void onAnimationRepeat(Animation animation) {
					
				}
				
				@Override
				public void onAnimationEnd(Animation animation) {
					if(_adjucentPrev != null)
			        {
			            removeView(_adjucentPrev);
			            _adjucentPrev = null;
			        }
			        _adjucentPrev =_currentView;
			        _currentView = _adjucentNext;
			        _adjucentNext = _listener.getNextView(_currentView);
			        if(_adjucentNext != null)
			        {
			        	addView(_adjucentNext);
			        }
			        offsetX = offsetY = 0;
			        positionPages(0, 0);
				}
			});
	    	_currentView.startAnimation(animCurrPage);
	    	_adjucentNext.startAnimation(animNextPage);
	    }
	}
	Handler handler = new Handler(new Handler.Callback() {
		
		@Override
		public boolean handleMessage(Message msg) 
		{
			int marginLeft = msg.arg1;
			int marginTop = msg.arg2;
			positionPages(marginLeft,marginTop);
			
			return false;
		}
	});
	private void completePreviousPageAnim()
	{
		
		if(Math.abs(offsetX)>=getMeasuredWidth())
	    {
	        //add previuos page remove next page
			
	    }
	    else
	    {
	    	offsetX = getMeasuredWidth()-offsetX;
	    	TranslateAnimation animCurrPage = new TranslateAnimation(0, offsetX, 0, 0);
	    	animCurrPage.setDuration(PAGE_ADJUST_ANIM_DURATION);
	    	animCurrPage.setAnimationListener(new AnimationListener() {
				
				@Override
				public void onAnimationStart(Animation animation) {}
				
				@Override
				public void onAnimationRepeat(Animation animation) {}
				
				@Override
				public void onAnimationEnd(Animation animation) {}
					
				
			});
	    	TranslateAnimation animPrevPage = new TranslateAnimation(0, offsetX, 0, 0);
	    	animPrevPage.setDuration(PAGE_ADJUST_ANIM_DURATION);
	    	animPrevPage.setAnimationListener(new AnimationListener() {
				
				@Override
				public void onAnimationStart(Animation animation) {}
				
				@Override
				public void onAnimationRepeat(Animation animation) {}
				
				@Override
				public void onAnimationEnd(Animation animation) {
					if(_adjucentNext != null)
			        {
			            removeView(_adjucentNext);
			            _adjucentNext = null;
			        }
			        _adjucentNext = _currentView;
			        _currentView = _adjucentPrev;
			        _adjucentPrev = _listener.getPreviousView(_currentView);
			        if(_adjucentPrev != null)
			        {
			        	addView(_adjucentPrev);
			        }
			        offsetX = offsetY = 0;
		        	positionPages(0, 0);
			        
				}
			});
	    	_currentView.startAnimation(animCurrPage);
	    	_adjucentPrev.startAnimation(animPrevPage);
	    }
	}
	
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
//		onSwipeRight();//load last page of same chapter
	}

	public void refreshAdjucentPages() 
	{
		if(_adjucentNext != null)
		{
			_adjucentNext.updateFontSize();
		}
		if(_adjucentPrev != null)
		{
			_adjucentPrev.updateFontSize();
		}
//		if(_adjucentNext != null)
//        {
//            removeView(_adjucentNext);
//            _adjucentNext = null;
//            _adjucentNext = _listener.getNextView(_currentView);
//            if(_adjucentNext != null)
//            {
//            	addView(_adjucentNext);
//            }
//        }
//		
//		if(_adjucentPrev != null)
//		{
//			removeView(_adjucentPrev);
//			_adjucentPrev =null;
//			_adjucentPrev = _listener.getPreviousView(_currentView);
//			if(_adjucentPrev != null)
//			{
//				addView(_adjucentPrev);
//			}
//		}
//		offsetX = offsetY = 0;
//        positionPages(0, 0);
	}
}
