package com.hurix.epubRnD.Constants;

import java.io.File;

import com.hurix.epubRnD.Utils.Constants;

import android.os.Environment;

public class GlobalConstants 
{
	public static final String ROOT_FOLDER = Environment.getExternalStorageDirectory()+File.separator+Constants.EPUBBOOK;

	public static int MIN_FONT_SIZE = 24;
	public static int MAX_FONT_SIZE = 36;
	public static int FONT_SIZE_STEP_SIZE = 2;

	public static int PAGE_COUNT = 0;
	//ePub type
	public static final int REFLOWABLE = 100;
	public static final int FIXED = 200;

	public static boolean ENABLE_WEB_VIEW_TOUCH = false;
	
	
	public static int NOTE_ICON_WIDTH = 40; //assuming base dpi as 160
	public static int NOTE_ICON_HEIGHT = 40; //assuming base dpi as 160
}
