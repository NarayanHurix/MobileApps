package com.hurix.epubRnD.Views;

import android.content.Context;
import android.graphics.Color;
import android.widget.ImageView;

public class EndStickView extends ImageView {

	public EndStickView(Context context) {
		super(context);
		init(context);
	}

	private void init(Context context)
	{
		setBackgroundColor(Color.GREEN);
	}

}
