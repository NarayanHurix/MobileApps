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
    private PageView _currentView,_adjacentNext,_adjacentPrev;
    private int MIN_MOVE_TO_CHANGE_PAGE = 60;
    private int PAGE_ADJAST_ANIM_DURATION= 500;
    private int NO_OF_PIXELS_TO_MOVE_FOR_ANIM ;
    public interface OnPageChangeListener
    {
    	public abstract PageView getPreviousView(PageView oldView);
    	public abstract PageView getNextView(PageView oldView);
    	public abstract void onPageChanged(PageView currentPageView);
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
		NO_OF_PIXELS_TO_MOVE_FOR_ANIM = (int) (35 * context.getResources().getDisplayMetrics().density);
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
				
				break;
				
			case MotionEvent.ACTION_MOVE:
				
				if(startTouchPoint.x>e1.getX())
				{
					//moving to next page
					if(_adjacentNext != null)
					{
						offsetX = (int)(e1.getX() - startTouchPoint.x);
						positionPages(offsetX,offsetY);
					}
				}
				else if(startTouchPoint.x<e1.getX())
				{
					//moving to previous page
					if(_adjacentPrev != null)
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
	
	private void positionPages(final int offsetX,final int offsetY)
	{
		((Activity)getContext()).runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				
				if(_currentView != null)
				{
					RelativeLayout.LayoutParams paramsCurrentPage = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
					paramsCurrentPage.leftMargin= offsetX;
					paramsCurrentPage.rightMargin = -offsetX;
					_currentView.setLayoutParams(paramsCurrentPage);
				}
				
				if(_adjacentNext != null)
				{
					RelativeLayout.LayoutParams paramsAdjacentNext = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
					paramsAdjacentNext.leftMargin= getMeasuredWidth() + offsetX;
					paramsAdjacentNext.rightMargin = -(getMeasuredWidth() + offsetX);
					_adjacentNext.setLayoutParams(paramsAdjacentNext);
				}
				
				if(_adjacentPrev != null)
				{
					RelativeLayout.LayoutParams paramsAdjacentPrev = new RelativeLayout.LayoutParams(getMeasuredWidth(), getMeasuredHeight());
					paramsAdjacentPrev.leftMargin= -getMeasuredWidth() + offsetX;
					paramsAdjacentPrev.rightMargin = -(-getMeasuredWidth() + offsetX);
					_adjacentPrev.setLayoutParams(paramsAdjacentPrev);
				}
			}
		});
	}
	
	private void completeNextPageAnim()
	{
		offsetX = offsetX-NO_OF_PIXELS_TO_MOVE_FOR_ANIM;
		if(Math.abs(offsetX)>=getMeasuredWidth())
	    {
			//add next page remove previous page
			if(_adjacentPrev != null)
	        {
	            removeView(_adjacentPrev);
	            _adjacentPrev = null;
	        }
	        _adjacentPrev =_currentView;
	        _currentView = _adjacentNext;
	        _adjacentNext = _listener.getNextView(_currentView);
	        if(_adjacentNext != null)
	        {
	        	addView(_adjacentNext);
	        }
	        offsetX = offsetY = 0;
	        positionPages(0, 0);
	        _listener.onPageChanged(_currentView);
	    }
	    else
	    {
	    	//positionPages(offsetX,offsetY);
	    	
	    	Message msg = new Message();
	    	msg.arg1 = offsetX;
	    	msg.arg2 = offsetY;
	    	msg.what = 100;
	    	handler.sendMessage(msg);
	    	positionPages(offsetX, offsetY);
	    }
	}
	
	private void completePreviousPageAnim()
	{
		offsetX = offsetX+NO_OF_PIXELS_TO_MOVE_FOR_ANIM;
		if(Math.abs(offsetX)>=getMeasuredWidth())
	    {
	        //add previuos page remove next page
			if(_adjacentNext != null)
	        {
	            removeView(_adjacentNext);
	            _adjacentNext = null;
	        }
	        _adjacentNext = _currentView;
	        _currentView = _adjacentPrev;
	        _adjacentPrev = _listener.getPreviousView(_currentView);
	        if(_adjacentPrev != null)
	        {
	        	addView(_adjacentPrev);
	        }
	        offsetX = offsetY = 0;
        	positionPages(0, 0);
        	_listener.onPageChanged(_currentView);
	    }
	    else
	    {
	    	Message msg = new Message();
	    	msg.arg1 = offsetX;
	    	msg.arg2 = offsetY;
	    	msg.what = 200;
	    	handler.sendMessage(msg);
	    	positionPages(offsetX, offsetY);
	    }
	}
	
	

	
	Handler handler = new Handler(new Handler.Callback() {
		
		@Override
		public boolean handleMessage(Message msg) 
		{
			if(msg.what == 100)
			{
				int marginLeft = msg.arg1;
				int marginTop = msg.arg2;
				positionPages(marginLeft,marginTop);
				completeNextPageAnim();
			}
			else if(msg.what == 200)
			{
				int marginLeft = msg.arg1;
				int marginTop = msg.arg2;
				positionPages(marginLeft,marginTop);
				completePreviousPageAnim();
			}
			return false;
		}
	});
	public void setOnPageChangeListener(OnPageChangeListener _listener) {
		this._listener = _listener;
	}

	public void initWithView(PageView view) 
	{
		removeAllViews();
		removeAllViewsInLayout();
		_adjacentNext= null;
		_adjacentPrev = null;
		_currentView = null;
		 
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

	public void checkPageBuffer()
	{
		if(_adjacentNext == null)
		{
			_adjacentNext = _listener.getNextView(_currentView);
			if(_adjacentNext != null)
			{
				addView(_adjacentNext);
			}
		}
		if(_adjacentPrev == null)
		{
			_adjacentPrev = _listener.getPreviousView(_currentView);
	        if(_adjacentPrev != null)
	        {
	        	addView(_adjacentPrev);
	        }
		}
        offsetX = offsetY = 0;
    	positionPages(0, 0);
		
	}
	public void refreshAdjacentPages() 
	{
		if(_adjacentNext != null)
		{
			_adjacentNext.updateFontSize();
		}
		if(_adjacentPrev != null)
		{
			_adjacentPrev.updateFontSize();
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
	
//	private void completeNextPageAnim()
//	{
//		if(Math.abs(offsetX)>=getMeasuredWidth())
//	    {
//			//add next page remove previous page
//			
//	    }
//	    else
//	    {
//	    	//positionPages(offsetX,offsetY);
//	    	offsetX = -(offsetX + getMeasuredWidth());
//	    	TranslateAnimation animCurrPage = new TranslateAnimation(0, offsetX, 0, 0);
//	    	animCurrPage.setDuration(PAGE_ADJAST_ANIM_DURATION);
//	    	animCurrPage.setAnimationListener(new AnimationListener() {
//				
//				@Override
//				public void onAnimationStart(Animation animation) {}
//				
//				@Override
//				public void onAnimationRepeat(Animation animation) {}
//				
//				@Override
//				public void onAnimationEnd(Animation animation) {}
//					
//				
//			});
//	    	TranslateAnimation animNextPage = new TranslateAnimation(0, offsetX, 0, 0);
//	    	animNextPage.setDuration(PAGE_ADJAST_ANIM_DURATION);
//	    	animNextPage.setAnimationListener(new AnimationListener() {
//				
//				@Override
//				public void onAnimationStart(Animation animation) {
//					
//				}
//				
//				@Override
//				public void onAnimationRepeat(Animation animation) {
//					
//				}
//				
//				@Override
//				public void onAnimationEnd(Animation animation) {
//					if(_adjacentPrev != null)
//			        {
//			            removeView(_adjacentPrev);
//			            _adjacentPrev = null;
//			        }
//			        _adjacentPrev =_currentView;
//			        _currentView = _adjacentNext;
//			        _adjacentNext = _listener.getNextView(_currentView);
//			        if(_adjacentNext != null)
//			        {
//			        	addView(_adjacentNext);
//			        }
//			        offsetX = offsetY = 0;
//			        positionPages(0, 0);
//				}
//			});
//	    	_currentView.startAnimation(animCurrPage);
//	    	_adjacentNext.startAnimation(animNextPage);
//	    }
//	}
//	
//	private void completePreviousPageAnim()
//	{
//		
//		if(Math.abs(offsetX)>=getMeasuredWidth())
//	    {
//	        //add previuos page remove next page
//			
//	    }
//	    else
//	    {
//	    	offsetX = getMeasuredWidth()-offsetX;
//	    	TranslateAnimation animCurrPage = new TranslateAnimation(0, offsetX, 0, 0);
//	    	animCurrPage.setDuration(PAGE_ADJAST_ANIM_DURATION);
//	    	animCurrPage.setAnimationListener(new AnimationListener() {
//				
//				@Override
//				public void onAnimationStart(Animation animation) {}
//				
//				@Override
//				public void onAnimationRepeat(Animation animation) {}
//				
//				@Override
//				public void onAnimationEnd(Animation animation) {}
//					
//				
//			});
//	    	TranslateAnimation animPrevPage = new TranslateAnimation(0, offsetX, 0, 0);
//	    	animPrevPage.setDuration(PAGE_ADJAST_ANIM_DURATION);
//	    	animPrevPage.setAnimationListener(new AnimationListener() {
//				
//				@Override
//				public void onAnimationStart(Animation animation) {}
//				
//				@Override
//				public void onAnimationRepeat(Animation animation) {}
//				
//				@Override
//				public void onAnimationEnd(Animation animation) {
//					if(_adjacentNext != null)
//			        {
//			            removeView(_adjacentNext);
//			            _adjacentNext = null;
//			        }
//			        _adjacentNext = _currentView;
//			        _currentView = _adjacentPrev;
//			        _adjacentPrev = _listener.getPreviousView(_currentView);
//			        if(_adjacentPrev != null)
//			        {
//			        	addView(_adjacentPrev);
//			        }
//			        offsetX = offsetY = 0;
//		        	positionPages(0, 0);
//			        
//				}
//			});
//	    	_currentView.startAnimation(animCurrPage);
//	    	_adjacentPrev.startAnimation(animPrevPage);
//	    }
//	}
}
