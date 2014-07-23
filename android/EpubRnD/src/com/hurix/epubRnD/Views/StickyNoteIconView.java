package com.hurix.epubRnD.Views;

import android.content.Context;
import android.graphics.Color;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.widget.RelativeLayout;

import com.hurix.epubRnD.VOs.HighlightVO;

public class StickyNoteIconView extends RelativeLayout implements GestureDetector.OnGestureListener,GestureDetector.OnDoubleTapListener{

	private HighlightVO _highlightVO;
	private GestureDetector _detector;
	private StickyNoteIconViewListener _listener;
	
	public interface StickyNoteIconViewListener
	{
		public abstract void openNoteEditor(StickyNoteIconView noteIconView);
	}
	
	public StickyNoteIconView(Context context,StickyNoteIconViewListener listener) 
	{
		super(context);
		_listener = listener;
		init(context);
	}

	private void init(Context context)
	{
		setBackgroundColor(Color.RED);
		_detector = new GestureDetector(context, this);
	}
	
	public void setData(HighlightVO highlightVO)
	{
		_highlightVO = highlightVO;
	}
	
	public HighlightVO getData()
	{
		 return _highlightVO;
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) 
	{
		return _detector.onTouchEvent(event);
	}

	@Override
	public boolean onDoubleTap(MotionEvent e) {
		return false;
	}

	@Override
	public boolean onDoubleTapEvent(MotionEvent e) {
		return false;
	}

	@Override
	public boolean onSingleTapConfirmed(MotionEvent e) 
	{
		//open note editor
		_listener.openNoteEditor(this);
		return true;
	}

	@Override
	public boolean onDown(MotionEvent e) {
		return false;
	}

	@Override
	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY) {
		return false;
	}

	@Override
	public void onLongPress(MotionEvent e) {
	}

	@Override
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
			float distanceY) {
		return false;
	}

	@Override
	public void onShowPress(MotionEvent e) {
	}

	@Override
	public boolean onSingleTapUp(MotionEvent e) {
		return false;
	}
}
