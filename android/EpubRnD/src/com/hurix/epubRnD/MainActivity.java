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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.ToggleButton;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Controllers.ViewPagerController;
import com.hurix.epubRnD.Controllers.ViewPagerController.ViewPagerControllerCallBacks;
import com.hurix.epubRnD.Parsers.EpubParser;
import com.hurix.epubRnD.Settings.GlobalSettings;
import com.hurix.epubRnD.Utils.Constants;
import com.hurix.epubRnD.Utils.Decompress;
import com.hurix.epubRnD.Utils.Utils;
import com.hurix.epubRnD.VOs.BookmarkVO;
import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.ManifestVO;
import com.hurix.epubRnD.VOs.PathVO;
import com.hurix.epubRnD.VOs.SpineVO;
import com.hurix.epubRnD.VOs.PageVO;
import com.hurix.epubRnD.Views.FixedTopMostLayout;
import com.hurix.epubRnD.Views.HelperViewForPageCount;
import com.hurix.epubRnD.Views.HelperViewForPageCount.PageCountListener;
import com.hurix.epubRnD.Views.MyViewFlipper;
import com.hurix.epubRnD.Views.PageView;

@SuppressLint("SdCardPath")
public class MainActivity extends ActionBarActivity implements OnClickListener,PageCountListener,OnSeekBarChangeListener,ViewPagerControllerCallBacks{

	private ArrayList<ChapterVO> _chaptersColl = new ArrayList<ChapterVO>();
	private MyViewFlipper _mViewPager;
	private static String APP_ID = "664df65e4a2f90162d7a39b4ff295081";
	private ToggleButton _highlightSwitch;
	private FixedTopMostLayout _topMostLayout;
	private RelativeLayout _bookLoadingProg;
	private HelperViewForPageCount _helperViewForPageCount;
	private SeekBar _pageNavSeekBar;
	private TextView _pageNoTV;
	int currentPage = -1;
	private PageVO _currentPageVO;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_main);
		_highlightSwitch = (ToggleButton) findViewById(R.id.toggleButton1);
		_highlightSwitch.setOnClickListener(this);
		_topMostLayout = (FixedTopMostLayout) findViewById(R.id.topMostLayer);
		_bookLoadingProg = (RelativeLayout) findViewById(R.id.bookLoadingProg);
		_helperViewForPageCount = (HelperViewForPageCount) findViewById(R.id.helperViewForPageCount);
		_pageNavSeekBar = (SeekBar) findViewById(R.id.seekBar1);
		
		_pageNavSeekBar.setOnSeekBarChangeListener(this);
		_pageNoTV = (TextView) findViewById(R.id.pageNoTV);
		GlobalSettings.HIGHLIGHT_SWITCH = false;
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

			_chaptersColl = EpubParser.getObject().setUrlFromPathVo(urlPaths);

		} catch (Exception e)
		{
			e.printStackTrace();
		}


		//	prepareData();
		_mViewPager = (MyViewFlipper) findViewById(R.id.myViewPager);
		ViewPagerController controller = new ViewPagerController();
		_mViewPager.setController(controller);
		
		_topMostLayout.setMyViewFlipper(_mViewPager);
		controller.setData(_chaptersColl,this);
		restorePlayerToLastSavedState();
		_helperViewForPageCount.startPageCounting(this, _chaptersColl);
	}

	public void increaseFontSize(View view)
	{
		if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
		{
			
		}
		else 
		{
			GlobalSettings.FONT_SIZE=GlobalSettings.FONT_SIZE+GlobalConstants.FONT_SIZE_STEP_SIZE;
			if(GlobalSettings.FONT_SIZE>GlobalConstants.MAX_FONT_SIZE)
			{
				GlobalSettings.FONT_SIZE = GlobalSettings.FONT_SIZE-GlobalConstants.FONT_SIZE_STEP_SIZE;
			}
			else
			{
				//((PageView)_mViewPager.getCurrentPageView()).updateFontSize();
				_mViewPager.getCurrentPageView().onLoadStart();
				_helperViewForPageCount.startPageCounting(this, _chaptersColl);
	
			}
			_mViewPager.refreshAdjacentPages();
		}
	}

	public void decreaseFontSize(View view)
	{
		if(GlobalSettings.EPUB_LAYOUT_TYPE == GlobalConstants.FIXED)
		{
			
		}
		else 
		{
			GlobalSettings.FONT_SIZE=GlobalSettings.FONT_SIZE-GlobalConstants.FONT_SIZE_STEP_SIZE;
			if(GlobalSettings.FONT_SIZE<GlobalConstants.MIN_FONT_SIZE)
			{
				GlobalSettings.FONT_SIZE = GlobalSettings.FONT_SIZE+GlobalConstants.FONT_SIZE_STEP_SIZE;
			}
			else
			{
				//((PageView)_mViewPager.getCurrentPageView()).updateFontSize();
				_mViewPager.getCurrentPageView().onLoadStart();
				_helperViewForPageCount.startPageCounting(this, _chaptersColl);
			}
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
//		case R.id.bookmark_btn:
//
//			initiatePopupWindow();
//
//			break;
		case R.id.toggleButton1:
			
			_mViewPager.getCurrentPageView().onClickHighlightSwitch();
			
			break;
		default:
			break;
		}

	}
//	private PopupWindow pwindo;
//	private void initiatePopupWindow() {
//		LayoutInflater inflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//		View layout = inflater.inflate(R.layout.bookmark_popup,(ViewGroup) findViewById(R.id.bookmark_layout));
//		pwindo = new PopupWindow(layout, android.view.ViewGroup.LayoutParams.WRAP_CONTENT, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
//		pwindo.setOutsideTouchable(true);
//		pwindo.setFocusable(true);
//		pwindo.setBackgroundDrawable(new BitmapDrawable());
//		//pwindo.showAtLocation(bookmark, Gravity.RIGHT, 0, 0);
//		pwindo.showAsDropDown(bookmark, 50, -30);
//		bookmark_add = (Button)layout.findViewById(R.id.add);
//		bookmark_cancel = (Button)layout.findViewById(R.id.dismiss);
//
//		bookmark_add.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//
//			}
//		});
//		bookmark_cancel.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				pwindo.dismiss();
//			}
//		});
//	}
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
	 
	 public void showFeedbackActivity() 
	 {
		  FeedbackManager.register(this, APP_ID, null);
		  FeedbackManager.showFeedbackActivity(this);
	 }
 
	@Override
	public void onPageCountComplete(int count) 
	{
		GlobalConstants.PAGE_COUNT = count;
		
		_bookLoadingProg.setVisibility(View.GONE);
		PageView pageView = new PageView(this,_mViewPager);
		int pageNo = 1;
		if(_currentPageVO != null)
		{
			_currentPageVO.setChapterVO(_chaptersColl.get(_currentPageVO.getIndexOfChapter()));
			if(_currentPageVO.getIndexOfPage()>=_currentPageVO.getChapterVO().getPageCount())
			{
				_currentPageVO.setIndexOfPage(_currentPageVO.getChapterVO().getPageCount()-1);
			}
			
			//data.setPageCount(data.getChapterVO().getPageCount());
			
			pageView.getWebView().setData(_currentPageVO);
	
			_mViewPager.initWithView(pageView);
			pageNo = Utils.getPageNo(_currentPageVO,_chaptersColl);
		}
		else
		{
			PageVO data = new PageVO();
			data.setChapterVO(_chaptersColl.get(0));
			data.setIndexOfPage(0);
			data.setIndexOfChapter(0);
			//data.setPageCount(_chaptersColl.get(0).getPageCount());
			
			pageView.getWebView().setData(data);
	
			_mViewPager.initWithView(pageView);
		}
		_pageNoTV.setText(pageNo+"/"+count);
		_pageNavSeekBar.setMax(count);
		currentPage = pageNo;
		_pageNavSeekBar.setProgress(pageNo);
	}

	@Override
	public void onStartTrackingTouch(SeekBar seekBar) 
	{
		
	}

	@Override
	public void onStopTrackingTouch(SeekBar seekBar) 
	{
		int progress = seekBar.getProgress();
		progress = progress==0?1:progress;
		seekBar.setProgress(progress);
		if(currentPage != progress)
		{
			currentPage = progress;
			PageView pageView = new PageView(this,_mViewPager);
			PageVO data = new PageVO();
			PageVO dao = Utils.getPageVO(progress, _chaptersColl);
			data.setChapterVO(_chaptersColl.get(dao.getIndexOfChapter()));
			data.setIndexOfPage(dao.getIndexOfPage());
			data.setIndexOfChapter(dao.getIndexOfChapter());
			//data.setPageCount(_chaptersColl.get(dao.getIndexOfChapter()).getPageCount());
			
			pageView.getWebView().setData(data);
			_pageNoTV.setText(progress+"/"+GlobalConstants.PAGE_COUNT);
			_mViewPager.initWithView(pageView);
			
		}
	}
	
	@Override
	public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) 
	{
		progress = progress==0?1:progress;
		_pageNoTV.setText(progress+"/"+GlobalConstants.PAGE_COUNT);
//		progress = progress==0?1:progress;
//		seekBar.setProgress(progress);
//		if(fromUser && currentPage != progress)
//		{
//			currentPage = progress;
//			PageView pageView = new PageView(this,_mViewPager);
//			WebViewDAO data = new WebViewDAO();
//			WebViewDAO dao = Utils.getPageWebViewDAO(progress, _chaptersColl);
//			data.setChapterVO(_chaptersColl.get(dao.getIndexOfChapter()));
//			data.setIndexOfPage(dao.getIndexOfPage());
//			data.setIndexOfChapter(dao.getIndexOfChapter());
//			data.setPageCount(_chaptersColl.get(dao.getIndexOfChapter()).getPageCount());
//			
//			pageView.getWebView().setData(data);
//			_pageNoTV.setText(progress+"/"+GlobalConstants.PAGE_COUNT);
//			_mViewPager.initWithView(pageView);
//			
//		}
	}

	@Override
	public void onPageChanged(PageView currentPageView) 
	{
		int pageNo = Utils.getPageNo(currentPageView.getWebView().getData(),_chaptersColl);
		_pageNoTV.setText(pageNo+"/"+GlobalConstants.PAGE_COUNT);
		_pageNavSeekBar.setProgress(pageNo);
		_currentPageVO = currentPageView.getWebView().getData();
		savePlayerState(currentPageView);
	}
	
	private void savePlayerState(PageView currentPageView)
	{
		SharedPreferences pref =  getSharedPreferences("EpubPlayer", Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = pref.edit();
		editor.putInt("IndexOfPage",currentPageView.getWebView().getData().getIndexOfPage());
		editor.putInt("IndexOfChapter",currentPageView.getWebView().getData().getIndexOfChapter());
		editor.putInt("FirstWordID",currentPageView.getWebView().getData().getFirstWordID());
		editor.putInt("LastWordID",currentPageView.getWebView().getData().getLastWordID());
		editor.putInt("FontSize",GlobalSettings.FONT_SIZE);
		editor.commit();
	}
	
	private void restorePlayerToLastSavedState()
	{
		SharedPreferences pref =  getSharedPreferences("EpubPlayer", Context.MODE_PRIVATE);
		_currentPageVO = new PageVO();
		_currentPageVO.setFirstWordID(pref.getInt("FirstWordID", 0));
		_currentPageVO.setLastWordID(pref.getInt("LastWordID", 0));
		_currentPageVO.setIndexOfPage(pref.getInt("IndexOfPage", 0));
		_currentPageVO.setIndexOfChapter(pref.getInt("IndexOfChapter", 0));
		GlobalSettings.FONT_SIZE = pref.getInt("FontSize", GlobalConstants.MIN_FONT_SIZE);
	}
	
	/**
	 * For successful navigation , PageVO must have index of chapter and index of page.
	 * In case of unknown page index ,word id must be given and index of page should set to GlobalConstants.GET_PAGE_INDEX_USING_WORD_ID 
	 * @param pageVO
	 */
	
	public void contentsList(View button)
	{
		_mViewPager.getController().toggleBookmarksListDlg();
	}
}
