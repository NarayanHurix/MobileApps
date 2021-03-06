package com.hurix.epubRnD.widgets;
import com.hurix.epubRnD.R;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Interpolator;
import android.widget.ImageView;
import android.widget.RelativeLayout;


public class QuickAction implements android.content.DialogInterface.OnDismissListener
{
	private ImageView mArrowUp;
	private ImageView mArrowDown;
	private Animation mTrackAnim;
	private LayoutInflater inflater;
	private ViewGroup mTrack;
	private OnDismissListener mDismissListener;
	private boolean mDidAction;
	private boolean mAnimateTrack;
	private int mAnimStyle;
	public PopupWindows _popupWindows;
	private View mRootView;
	private WindowManager mWindowManager;
	private Dialog mWindow;
	private View _container;
	private int arrowHeight, arrowWidth;
	public static final int DEFAULT_ANIM = -1;
	public static final int NO_ANIM = 0;
	public static final int ANIM_GROW_FROM_LEFT = 1;
	public static final int ANIM_GROW_FROM_RIGHT = 2;
	public static final int ANIM_GROW_FROM_CENTER = 3;
	public static final int ANIM_AUTO = 4;
	private RelativeLayout body;

	public QuickAction(Context context)
	{
		_popupWindows = new PopupWindows(context);
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		mTrackAnim = AnimationUtils.loadAnimation(context, R.anim.rail);
		mTrackAnim.setInterpolator(new Interpolator()
		{
			@Override
			public float getInterpolation(float t)
			{
				// Pushes past the target area, then snaps back into place.
				// Equation for graphing: 1.2-((x*1.6)-1.1)^2
				final float inner = (t * 1.55f) - 1.1f;
				return 1.2f - inner * inner;
			}
		});
		mRootView = _popupWindows.mRootView;
		mWindowManager = _popupWindows.mWindowManager;
		mWindow = _popupWindows.mWindow;
		setRootViewId(R.layout.quickaction);
		mAnimStyle = ANIM_GROW_FROM_CENTER;
		mAnimateTrack = false;
	}

	public void setRootViewId(int id)
	{
		mRootView = inflater.inflate(id, null);
		mTrack = (ViewGroup) mRootView.findViewById(R.id.tracks);
		mArrowDown = (ImageView) mRootView.findViewById(R.id.arrow_down);
		mArrowUp = (ImageView) mRootView.findViewById(R.id.arrow_up);
		setArrowHeight(mArrowDown.getDrawable().getIntrinsicHeight());
		setArrowWidth(mArrowDown.getDrawable().getIntrinsicWidth());
		mRootView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
		_popupWindows.setContentView(mRootView);
	}

	public void mAnimateTrack(boolean mAnimateTrack)
	{
		this.mAnimateTrack = mAnimateTrack;
	}

	public void setAnimStyle(int mAnimStyle)
	{
		this.mAnimStyle = mAnimStyle;
	}

	public void setAlertLayout(int alertLayoutId)
	{
		_container = inflater.inflate(alertLayoutId, null);
		_container.setOnClickListener(new OnClickListener()
		{
			@Override
			public void onClick(View v)
			{
				/*
				 * if (mItemClickListener != null) {
				 * mItemClickListener.onItemClick(v); }
				 */
				// {
				// mDidAction = true;
				// v.post(new Runnable() {
				// @Override
				// public void run() {
				// dismiss();
				// }
				// });
				// }
				// Log.d("here","one");
			}
		});
		_container.setFocusable(true);
		body = (RelativeLayout) mTrack.findViewById(R.id.text_body);
		body.addView(_container);
	}
	
	public void setAlertLayout(View view)
	{
		_container = view;
		_container.setFocusable(true);
		body = (RelativeLayout) mTrack.findViewById(R.id.text_body);
		body.addView(_container);
	}
	public void show(RectF rect ) throws Exception
	{
		setArrowHeight(mArrowDown.getDrawable().getIntrinsicHeight());
		setArrowWidth(mArrowDown.getDrawable().getIntrinsicWidth());
		final int anchorLeft = (int) rect.left;
		final int anchorTop = (int) rect.top;
		final int anchorWidth = (int) rect.right;
		final int anchorHeight = (int) rect.bottom;
		openPopup(anchorLeft, anchorTop, anchorWidth, anchorHeight);
	}
	public void show(View anchor) throws Exception
	{
		setArrowHeight(mArrowDown.getDrawable().getIntrinsicHeight());
		setArrowWidth(mArrowDown.getDrawable().getIntrinsicWidth());
		_popupWindows.preShow();
		int[] location = new int[2];
		anchor.getLocationOnScreen(location);
		final int anchorLeft = location[0];
		final int anchorTop = location[1];
		final int anchorWidth = anchor.getMeasuredWidth();
		final int anchorHeight = anchor.getMeasuredHeight();
		
		openPopup(anchorLeft, anchorTop, anchorWidth, anchorHeight);
	}
	private void openPopup(int anchorLeft, int anchorTop, int anchorWidth, int anchorHeight) throws Exception
	{
		final int screenWidth = mWindowManager.getDefaultDisplay().getWidth();
		mDidAction = false;
		Rect anchorRect = new Rect(anchorLeft, anchorTop, anchorLeft + anchorWidth, anchorTop + anchorHeight);
		// mRootView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,
		// LayoutParams.WRAP_CONTENT));
		mRootView.measure(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		final int rootWidth = mRootView.getMeasuredWidth();
		final int rootHeight = mRootView.getMeasuredHeight();
		//display on left
		int xPos = anchorRect.left + (anchorWidth / 2) - (rootWidth/2);
		if(xPos<0)
		{
			xPos = 5;
		}
		int yPos = anchorRect.top - rootHeight-anchorHeight;
		int arrowLeftMargin = anchorLeft+(anchorWidth/2)-xPos- (arrowWidth / 2);
		boolean onTop = true;
		// display on bottom
		if (rootHeight > anchorTop)
		{
			yPos = anchorRect.bottom;
			onTop = false;
		}
		// display on right
		if (rootWidth/2 > (screenWidth - (anchorRect.left + (anchorWidth / 2))))
		{
			xPos = screenWidth - rootWidth-5;
			arrowLeftMargin = anchorLeft+(anchorWidth/2)-xPos - (arrowWidth / 2);
		}
		
//		int xPos = anchorRect.left + (anchorWidth / 2) - (arrowWidth);
//		int yPos = anchorRect.top - rootHeight;
//		int arrowLeftMargin = arrowWidth / 2;
//		boolean onTop = true;
//		// display on bottom
//		if (rootHeight > anchorTop)
//		{
//			yPos = anchorRect.bottom;
//			onTop = false;
//		}
//		// display on right
//		if (rootWidth - (anchorWidth / 2) > screenWidth - xPos)
//		{
//			xPos = (anchorRect.left + (anchorWidth / 2)) - rootWidth + arrowWidth;
//			arrowLeftMargin = rootWidth - arrowWidth - arrowWidth / 2;
//		}
		showArrow(((onTop) ? R.id.arrow_down : R.id.arrow_up), arrowLeftMargin);
		// setAnimationStyle(screenWidth, anchorRect.centerX(), onTop);
		// mWindow.showAtLocation(anchor, Gravity.NO_GRAVITY, xPos, yPos);
		// if (mAnimateTrack)
		// mTrack.startAnimation(mTrackAnim);
		WindowManager.LayoutParams params = mWindow.getWindow().getAttributes();
		params.softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE;
		params.x = xPos;
		params.y = yPos;
		params.gravity = Gravity.TOP + Gravity.LEFT;
		mWindow.getWindow().setAttributes(params);
		mWindow.show();
	}

	private void showArrow(int whichArrow, int requestedX)
	{
		final View showArrow = (whichArrow == R.id.arrow_up) ? mArrowUp : mArrowDown;
		final View hideArrow = (whichArrow == R.id.arrow_up) ? mArrowDown : mArrowUp;
		showArrow.setVisibility(View.VISIBLE);
		(showArrow.getLayoutParams()).width = arrowWidth;
		ViewGroup.MarginLayoutParams param = (ViewGroup.MarginLayoutParams) showArrow.getLayoutParams();
		param.leftMargin = requestedX;
		hideArrow.setVisibility(View.INVISIBLE);
	}

	// private void setAnimationStyle(int screenWidth, int requestedX, boolean
	// onTop)
	// {
	// int arrowPos = requestedX - mArrowUp.getMeasuredWidth() / 2;
	// switch (mAnimStyle)
	// {
	// case DEFAULT_ANIM :
	// mWindow.setAnimationStyle(DEFAULT_ANIM);
	// break;
	// case NO_ANIM :
	// mWindow.setAnimationStyle(NO_ANIM);
	// break;
	// case ANIM_GROW_FROM_LEFT :
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopUpMenu_Left :
	// R.style.Animations_PopDownMenu_Left);
	// break;
	// case ANIM_GROW_FROM_RIGHT :
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopUpMenu_Right :
	// R.style.Animations_PopDownMenu_Right);
	// break;
	// case ANIM_GROW_FROM_CENTER :
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopUpMenu_Center :
	// R.style.Animations_PopDownMenu_Center);
	// break;
	// case ANIM_AUTO :
	// if (arrowPos <= screenWidth / 4)
	// {
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopUpMenu_Left :
	// R.style.Animations_PopDownMenu_Left);
	// }
	// else if (arrowPos > screenWidth / 4 && arrowPos < 3 * (screenWidth / 4))
	// {
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopUpMenu_Center :
	// R.style.Animations_PopDownMenu_Center);
	// }
	// else
	// {
	// mWindow.setAnimationStyle((onTop) ? R.style.Animations_PopDownMenu_Right
	// : R.style.Animations_PopDownMenu_Right);
	// }
	// break;
	// }
	// }
	public void setOnDismissListener(QuickAction.OnDismissListener listener)
	{
		_popupWindows.setOnDismissListener(this);
		mDismissListener = listener;
	}

	@Override
	public void onDismiss(DialogInterface dialog)
	// @Override
	// public void onDismiss()
	{
		if (!mDidAction && mDismissListener != null)
		{
			mDismissListener.onDismiss();
		}
	}
	public interface OnDismissListener
	{
		public abstract void onDismiss();
	}
	class PopupWindows
	{
		protected Context mContext;
		protected Dialog mWindow;
		protected View mRootView;
		protected Drawable mBackground = null;
		protected WindowManager mWindowManager;

		PopupWindows(Context context)
		{
			mContext = context;
			mWindow = new Dialog(context, R.style.MyDialogTheme);
			// mWindow.setOnShowListener(
			// new DialogInterface.OnShowListener(){
			// public void onShow(DialogInterface d){
			// //_edittext.requestFocus();
			// InputMethodManager input_manager = (InputMethodManager)
			// _context.getSystemService(Context.INPUT_METHOD_SERVICE);
			// input_manager.showSoftInput(_edittext,
			// InputMethodManager.SHOW_IMPLICIT);
			// }
			// }
			// );
			//
			DialogInterface.OnDismissListener listener = new DialogInterface.OnDismissListener()
			{
				@Override
				public void onDismiss(DialogInterface dialog)
				{
					// hideKeySoftKeyBoard();
				}
			};
			mWindow.setOnDismissListener(listener);
			mWindowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		}

		protected void onDismiss()
		{
		}

		protected void onShow()
		{
		}

		protected void preShow()
		{
			if (mRootView == null)
				throw new IllegalStateException("setContentView was not called with a view to display.");
			onShow();
			// if (mBackground == null)
			// mWindow.setBackgroundDrawable(new BitmapDrawable());
			// else
			// mWindow.setBackgroundDrawable(mBackground);
			// mWindow.setWidth(LayoutParams.WRAP_CONTENT);
			// mWindow.setHeight(LayoutParams.WRAP_CONTENT);
			// mWindow.setOutsideTouchable(true);
			// mWindow.setTouchable(true);
			// mWindow.setFocusable(true);
			// mWindow.setContentView(mRootView);
//			mWindow.setCanceledOnTouchOutside(false);
			mWindow.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
			mWindow.setContentView(mRootView);
		}

		protected void setBackgroundDrawable(Drawable background)
		{
			mBackground = background;
		}

		protected void setContentView(View root)
		{
			mRootView = root;
			mWindow.setContentView(root);
		}

		protected void setContentView(int layoutResID)
		{
			LayoutInflater inflator = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			setContentView(inflator.inflate(layoutResID, null));
		}

		protected void setOnDismissListener(DialogInterface.OnDismissListener listener)
		{
			mWindow.setOnDismissListener(listener);
		}

		protected void dismiss()
		{
			mWindow.dismiss();
		}
	}

	public View findViewById(int id)
	{
		return _container.findViewById(id);
	}

	public void dismiss()
	{
		mWindow.dismiss();
	}

	public void setArrowHeight(int arrowHeight)
	{
		this.arrowHeight = arrowHeight;
	}

	public void setArrowWidth(int arrowWidth)
	{
		this.arrowWidth = arrowWidth;
	}
//
//	public int getArrowHeight()
//	{
//		return arrowHeight;
//	}
//
//	public int getArrowWidth()
//	{
//		return arrowWidth;
//	}
	public Dialog getDialog()
	{
		return mWindow;
	}
	
//	public void setBackground(int resid)
//	{
//		body.setBackgroundResource(resid);
//	}
	
	public RelativeLayout getBodyContainer()
	{
		return body;
	}
	
//	public void setUpArrowBackgroudn(int resid)
//	{
//		mArrowUp.setImageResource(resid);
//	}
//	
//	public void setDownArrowBackgroudn(int resid)
//	{
//		mArrowDown.setImageResource(resid);
//	}
	public ImageView getArrowDown()
	{
		return mArrowDown;
	}
	
	public ImageView getArrowUp()
	{
		return mArrowUp;
	}
}