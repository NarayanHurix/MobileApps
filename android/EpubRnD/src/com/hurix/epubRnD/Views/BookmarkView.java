package com.hurix.epubRnD.Views;

import android.content.Context;
import android.view.MotionEvent;
import android.widget.RelativeLayout;

import com.hurix.epubRnD.R;

public class BookmarkView extends RelativeLayout
{
	private Context mContext;
	private BookmarkViewListener mListener;
	private boolean currentStatus;
	
	public interface BookmarkViewListener
	{
		public abstract void onBookMarkStatusChanged(boolean status,boolean byUser);
	}
	
	
	public BookmarkView(Context context)
	{
		super(context);
		mContext = context;
		init();
	}
	
	public void setListener(BookmarkViewListener listener)
	{
		mListener = listener;
	}
	
	private void init()
	{
		changeBookMarkStatus(false, false);
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		// TODO Auto-generated method stub
		return super.onTouchEvent(event);
	}
	
	public void changeBookMarkStatus(boolean status,boolean byUser)
	{
		currentStatus = status;
		if(currentStatus)
		{
			setBackgroundResource(R.drawable.bookmarkbutton_selected);
		}
		else
		{
			setBackgroundResource(R.drawable.bookmark);
		}
		
		if(mListener != null)
		{
			mListener.onBookMarkStatusChanged(status, byUser);
		}
	}

	public void onSingleTapConfirmed(MotionEvent e) 
	{
		changeBookMarkStatus(!currentStatus, true);
	}
	
}
