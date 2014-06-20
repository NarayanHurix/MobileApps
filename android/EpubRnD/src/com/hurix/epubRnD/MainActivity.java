package com.hurix.epubRnD;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import net.hockeyapp.android.CrashManager;
import net.hockeyapp.android.FeedbackManager;
import net.hockeyapp.android.UpdateManager;

import org.w3c.dom.Document;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.PopupWindow;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Controllers.ViewPagerController;
import com.hurix.epubRnD.R;
import com.hurix.epubRnD.Parsers.EpubParser;
import com.hurix.epubRnD.Settings.GlobalSettings;
import com.hurix.epubRnD.Utils.Constants;
import com.hurix.epubRnD.Utils.Decompress;
import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.ManifestVO;
import com.hurix.epubRnD.VOs.PathVO;
import com.hurix.epubRnD.VOs.SpineVO;
import com.hurix.epubRnD.VOs.WebViewDAO;
import com.hurix.epubRnD.Views.MyViewPager;
import com.hurix.epubRnD.Views.MyWebView;
import com.hurix.epubRnD.Views.PageView;

@SuppressLint("SdCardPath")
public class MainActivity extends ActionBarActivity implements OnClickListener{

	private ArrayList<ChapterVO> chaptersColl = new ArrayList<ChapterVO>();
	private MyViewPager _mViewPager;
	private Button bookmark;
	private Button bookmark_add;
	private Button bookmark_cancel;
	private File file;
	private static String APP_ID = "664df65e4a2f90162d7a39b4ff295081";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		/*	requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);*/

		setContentView(R.layout.activity_main);
		checkForUpdates();
		File file = new File(Constants.SDCARD+"/epubBook/" );
		if (file.exists())
		{
			System.out.println("File Exist");
			CopyAssets();
		}
		else
		{
			file.mkdirs();
			CopyAssets();
			System.out.println("File NOT Exist");

		}




		/*String zipFile = Constants.SDCARD + "/epubBook.zip";

		String unzipLocation = Constants.SDCARD + "/epubBook/"; 
		File f = new File(unzipLocation);

		if(!f.exists())
		{
			f.mkdirs();
			Decompress d = new Decompress(); 
			d.unZipIt(zipFile,unzipLocation); 
		}else
		{
			Decompress d = new Decompress(); 
			d.unZipIt(zipFile,unzipLocation); 
		}*/

		file = new File(Constants.SDCARD,  Constants.CONTAINER);
		System.out.println("file is" + file);

		try
		{
			Document doc = EpubParser.getObject().getDocFromXmlFile(file);

			SpineVO objVo = EpubParser.getObject().getSpineFromXML(doc, Constants.SPINE);

			ManifestVO manif = EpubParser.getObject().getManifestXML(doc, Constants.MANIFEST,objVo);

			PathVO urlPaths = EpubParser.getObject().getUrlFromXML(manif);

			chaptersColl = EpubParser.getObject().setUrlFromPathVo(urlPaths);

		} catch (Exception e)
		{
			e.printStackTrace();
		}


		//	prepareData();
		_mViewPager = (MyViewPager) findViewById(R.id.myViewPager);
		bookmark = (Button)findViewById(R.id.bookmark_btn);
		bookmark.setOnClickListener(this);
		ViewPagerController controller = new ViewPagerController();
		controller.setData(chaptersColl,_mViewPager);
		//_mViewPager.setOnPageChangeListener((OnPageChangeListener) controller);
		_mViewPager.setOnPageChangeListener(controller);
		PageView pageView = new PageView(this,_mViewPager);
		MyWebView webView= pageView.getWebView();
		webView.setHorizontalScrollBarEnabled(false);
		webView.setVerticalScrollBarEnabled(false);
		webView.setLongClickable(true);

		/*webView.getSettings().setLayoutAlgorithm(LayoutAlgorithm.SINGLE_COLUMN);
		webView.setOnTouchListener(new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return (event.getAction() == MotionEvent.ACTION_MOVE);
			}
		});*/
		WebViewDAO data = new WebViewDAO();
		data.setChapterVO(chaptersColl.get(0));
		data.setIndexOfPage(0);
		data.setIndexOfChapter(0);
		data.setMaxScrollX(0);
		data.setScrollX(0);

		webView.setData(data);

		_mViewPager.initWithView(pageView);


	}






	public void increaseFontSize(View view)
	{
		GlobalSettings.FONT_SIZE=GlobalSettings.FONT_SIZE+GlobalConstants.FONT_SIZE_STEP_SIZE;
		if(GlobalSettings.FONT_SIZE>GlobalConstants.MAX_FONT_SIZE)
		{
			GlobalSettings.FONT_SIZE = GlobalSettings.FONT_SIZE-GlobalConstants.FONT_SIZE_STEP_SIZE;
		}
		else
		{
			((PageView)_mViewPager.getCurrentPageView()).updateFontSize();

		}
	}

	public void decreaseFontSize(View view)
	{
		GlobalSettings.FONT_SIZE=GlobalSettings.FONT_SIZE-GlobalConstants.FONT_SIZE_STEP_SIZE;
		if(GlobalSettings.FONT_SIZE<GlobalConstants.MIN_FONT_SIZE)
		{
			GlobalSettings.FONT_SIZE = GlobalSettings.FONT_SIZE+GlobalConstants.FONT_SIZE_STEP_SIZE;
		}
		else
		{
			((PageView)_mViewPager.getCurrentPageView()).updateFontSize();
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.bookmark_btn:

			initiatePopupWindow();

			break;

		default:
			break;
		}

	}
	private PopupWindow pwindo;
	private void initiatePopupWindow() {
		LayoutInflater inflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View layout = inflater.inflate(R.layout.bookmark_popup,(ViewGroup) findViewById(R.id.bookmark_layout));
		pwindo = new PopupWindow(layout, android.view.ViewGroup.LayoutParams.WRAP_CONTENT, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
		pwindo.setOutsideTouchable(true);
		pwindo.setFocusable(true);
		pwindo.setBackgroundDrawable(new BitmapDrawable());
		//pwindo.showAtLocation(bookmark, Gravity.RIGHT, 0, 0);
		pwindo.showAsDropDown(bookmark, 50, -30);
		bookmark_add = (Button)layout.findViewById(R.id.add);
		bookmark_cancel = (Button)layout.findViewById(R.id.dismiss);

		bookmark_add.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		bookmark_cancel.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				pwindo.dismiss();
			}
		});
	}
	private void CopyAssets() {
		AssetManager assetManager = getAssets();
		String[] files = null;
		try {
			files = assetManager.list("Books");
		} catch (IOException e) {
			Log.e("tag", e.getMessage());
		}

		for(String filename : files) {
			System.out.println("File name => "+filename);
			InputStream in = null;
			OutputStream out = null;

			try {
				in = assetManager.open("Books/"+filename);  
				out = new FileOutputStream( Constants.SDCARD + "/epubBook/" + filename);

				copyFile(in, out);
				
				String str=  Constants.SDCARD + "/epubBook/" + filename;
				//File f = new File(out.toString());
				String unzipLocation = Constants.SDCARD + "/epubBook/"+"epubBook/";

				Decompress d = new Decompress(); 
				d.unZipIt(str,unzipLocation); 

				in.close();
				in = null;
				out.flush();
				out.close();
				out = null;
			} catch(Exception e) {
				Log.e("tag", e.getMessage());
			}
		}
	}
	/*public void copyAssets()
	{
	      AssetManager assetManager = getApplicationContext().getAssets();
	      String[] files = null;
	      InputStream in = null;
	      OutputStream out = null;
	      String filename = "epubBook.zip";
	      try
	      {
	            in = assetManager.open(filename);
	            String unzipLocation = Constants.SDCARD + "/epubBook/"; 
	    		File f = new File(unzipLocation);

	    		if(!f.exists())
	    		{
	    			f.mkdirs();
	    			Decompress d = new Decompress(); 
	    			d.unZipIt(in,unzipLocation); 
	    		}else
	    		{
	    			Decompress d = new Decompress(); 
	    			d.unZipIt(in,unzipLocation); 
	    		}
	            File file = new File(unzipLocation);
	            file.mkdirs();
	            out = new FileOutputStream(file);
	            copyFile(in, out);
	            in.close();
	            in = null;
	            out.flush();
	            out.close();
	            out = null;
	      }
	      catch(IOException e)
	      {
	            Log.e("tag", "Failed to copy asset file: " + filename, e);
	      }      
	}*/
	private void copyFile(InputStream in, OutputStream out) throws IOException
	{
		byte[] buffer = new byte[1024];
		int read;
		while((read = in.read(buffer)) != -1)
		{
			out.write(buffer, 0, read);
		}
	}
	
	
	public void crash(View view)
	{
		int a = 4/0;
	}
	/*private void prepareData()
	{
		ChapterVO sdao1 = new ChapterVO();
		//sdao1.setSpineURL("file://"+GlobalData.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"0-intro.xhtml");
		sdao1.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"0-intro.xhtml");

		chaptersColl.add(sdao1);

		ChapterVO sdao2 = new ChapterVO();
		//sdao2.setSpineURL("file://"+GlobalData.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"1a-childhood-text.xhtml");
		sdao2.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"1a-childhood-text.xhtml");
		chaptersColl.add(sdao2);

		ChapterVO sdao3 = new ChapterVO();
		sdao3.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"1b-childhood-painting.xhtml");
		chaptersColl.add(sdao3);

		ChapterVO sdao4 = new ChapterVO();
		sdao4.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"3a-manhood-text.xhtml");
		chaptersColl.add(sdao4);
		ChapterVO sdao5 = new ChapterVO();
		sdao5.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"2a-youth-text.xhtml");
		chaptersColl.add(sdao5);

		ChapterVO sdao6 = new ChapterVO();
		sdao6.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"4a-oldage-text.xhtml");
		chaptersColl.add(sdao6);

		ChapterVO sdao7 = new ChapterVO();
		sdao7.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"2b-youth-painting.xhtml");
		chaptersColl.add(sdao7);

		ChapterVO sdao8 = new ChapterVO();
		sdao8.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"3b-manhood-painting.xhtml");
		chaptersColl.add(sdao8);

		ChapterVO sdao9 = new ChapterVO();
		sdao9.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"4b-oldage-painting.xhtml");
		chaptersColl.add(sdao9);

		ChapterVO sdao10 = new ChapterVO();
		sdao10.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"cole-voyage-of-life-20120320/EPUB/xhtml/"+"5-significance.xhtml");
		chaptersColl.add(sdao10);
	}*/
	
	@Override
	 protected void onResume() {
	   super.onResume();
	   checkForCrashes();
	 }

	 private void checkForCrashes() {
	   CrashManager.register(this, APP_ID);
	 }

	 private void checkForUpdates() {
	   // Remove this for store builds!
	   UpdateManager.register(this, APP_ID);
	 }
	 
	 public void showFeedbackActivity() {
		  FeedbackManager.register(this, APP_ID, null);
		  FeedbackManager.showFeedbackActivity(this);
	}

}