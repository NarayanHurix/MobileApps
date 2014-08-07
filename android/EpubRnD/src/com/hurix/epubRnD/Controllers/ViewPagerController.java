package com.hurix.epubRnD.Controllers;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hurix.epubRnD.Utils.Utils;
import com.hurix.epubRnD.VOs.BookmarkVO;
import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.PageVO;
import com.hurix.epubRnD.Views.MyViewFlipper;
import com.hurix.epubRnD.Views.MyViewFlipper.BaseViewFlipperController;
import com.hurix.epubRnD.Views.MyWebView;
import com.hurix.epubRnD.Views.PageView;

public class ViewPagerController extends BaseViewFlipperController
{

	private ArrayList<ChapterVO> _chaptersColl;
	private MyViewFlipper _mViewPager;
	private ViewPagerControllerCallBacks _callBackListener;
	
	public void setData(ArrayList<ChapterVO> chaptersColl,ViewPagerControllerCallBacks callBackListener)
	{
		this._chaptersColl = chaptersColl;
		_callBackListener = callBackListener;
	}
	
	public void viewFlipperInitiated(MyViewFlipper viewFlipper)
	{
		_mViewPager = viewFlipper;
	}
	
	private Context getContext()
	{
		return _mViewPager.getContext();
	}
	
	public interface ViewPagerControllerCallBacks
	{
		public void onPageChanged(PageView currentPageView); 
	}
	/*public void setData(ArrayList<ChapterVO> chaptersColl,MyWebView myView)
	{
		this.chaptersColl = chaptersColl;
		_my_WebView = myView;
	}*/
	
	@Override
	public PageView getPreviousView(PageView oldPage) 
	{
		MyWebView oldWebView = ((PageView)oldPage).getWebView();
		
		int chapterIndex = oldWebView.getData().getIndexOfChapter();
		int pageIndex = oldWebView.getData().getIndexOfPage();
		int pageCount = oldWebView.getData().getChapterVO().getPageCount();
		pageIndex--;
		if(pageIndex < 0)
		{
			pageIndex = 0;
			chapterIndex--;
			if(chapterIndex<0)
			{
				//return the same page
				chapterIndex = 0;
				return null;
			}
			else
			{
				//previous chapter last page
				PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
				MyWebView webView= pageView.getWebView();
				
				PageVO data = new PageVO();
				data.setChapterVO(_chaptersColl.get(chapterIndex));
				data.setIndexOfChapter(chapterIndex);
				data.setIndexOfPage(-2);
				
				webView.setData(data);
				return pageView;
			}
		}
		else if(pageIndex <= pageCount-1)
		{
			//same chapter previous page
			PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
			MyWebView webView= pageView.getWebView();
			
			PageVO data = new PageVO();
			data.setChapterVO(_chaptersColl.get(chapterIndex));
			data.setIndexOfChapter(chapterIndex);
			data.setIndexOfPage(pageIndex);
			
			webView.setData(data);
			return pageView;
		}
		return oldPage;
	}

	@Override
	public PageView getNextView(PageView oldPage) 
	{
		MyWebView oldWebView = ((PageView)oldPage).getWebView();
		int chapterIndex = oldWebView.getData().getIndexOfChapter();
		int pageIndex = oldWebView.getData().getIndexOfPage();
		int pageCount = oldWebView.getData().getChapterVO().getPageCount();
		pageIndex++;
		if(pageIndex>=pageCount)
		{
			pageIndex=0;
			chapterIndex++;
			if(chapterIndex>=_chaptersColl.size())
			{
				//end of the chapters and pages so return the same page
				chapterIndex--;
				return null;
			}
			else
			{
				//next chapter first page
				PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
				MyWebView webView= pageView.getWebView();
				
				PageVO data = new PageVO();
				data.setChapterVO(_chaptersColl.get(chapterIndex));
				data.setIndexOfChapter(chapterIndex);
				data.setIndexOfPage(pageIndex);
				
				webView.setData(data);
				
				return pageView;
			}
		}
		else
		{
			//next page in same chapter
			PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
			MyWebView webView= pageView.getWebView();
			
			PageVO data = new PageVO();
			data.setChapterVO(_chaptersColl.get(chapterIndex));
			data.setIndexOfChapter(chapterIndex);
			data.setIndexOfPage(pageIndex);
			//data.setPageCount(pageCount);
			
			webView.setData(data);
			
			return pageView;
		}
	}
	
	@Override
	public void onPageChanged(PageView currentPageView)
	{
		_callBackListener.onPageChanged(currentPageView);
	}
	
	public void navigateToPage(PageVO pageVO)
	{
		PageView pageView = new PageView(getContext(),_mViewPager);
		pageVO.setChapterVO(_chaptersColl.get(pageVO.getIndexOfChapter()));
		pageView.getWebView().setData(pageVO);
		_mViewPager.initWithView(pageView);
	}
	
	ListView _bookmarksListView ;
	ArrayList<BookmarkVO> _bookmarks ;
	Adapter adapter ;
	Dialog bookmarksDlg;
	boolean bookmarksListOpened;
	
	public void showBookmarksList(boolean show,boolean refresh)
	{
		//if(_bookmarks == null || refresh)
		{
			_bookmarks = getAllBookmarks();
		}
		if(show)
		{
			
			if(_bookmarks != null)
			{
				if(bookmarksDlg == null)
				{
					bookmarksDlg = new Dialog(getContext());
					bookmarksDlg.setOnDismissListener(new Dialog.OnDismissListener() {
						
						@Override
						public void onDismiss(DialogInterface arg0) 
						{
							bookmarksListOpened = false;
						}
					});
					bookmarksDlg.setTitle("BOOKMARKS");
					_bookmarksListView = new ListView(getContext());
					_bookmarksListView.setPadding(10, 10, 10, 10);
					adapter = new Adapter(_bookmarks);
					_bookmarksListView.setAdapter(adapter);
					bookmarksDlg.setContentView(_bookmarksListView);
					_bookmarksListView.getLayoutParams().height = _mViewPager.getMeasuredHeight()/2;
					_bookmarksListView.getLayoutParams().width = _mViewPager.getMeasuredWidth()/2;
					_bookmarksListView.setDividerHeight(3);
				}
				bookmarksListOpened = show;
				bookmarksDlg.show();
			}
		}
		else
		{
			bookmarksListOpened = false;
			if(bookmarksDlg != null)
			{
				bookmarksDlg.dismiss();
			}
		}
	}
	private ArrayList<BookmarkVO> getAllBookmarks()
	{
 		SharedPreferences pref =  getContext().getSharedPreferences("UGCData", Context.MODE_PRIVATE);
		String jsonArrStr = pref.getString("Bookmarks", "[]");
		try {
			
			ArrayList<BookmarkVO> bookmarks = new ArrayList<BookmarkVO>();
			
			JSONArray allBookmarksArray = new JSONArray(jsonArrStr);
			for(int i=0;i<allBookmarksArray.length();i++)
			{
				JSONObject bObj = allBookmarksArray.getJSONObject(i);
				BookmarkVO vo = new BookmarkVO();
				vo.setIndexOfChapter(bObj.getInt("chapter_index"));
				vo.setText(bObj.getString("text"));
				vo.setWordID(bObj.getInt("word_id"));
				bookmarks.add(vo);
			}
			return bookmarks;
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	private class Adapter extends BaseAdapter
	{
		ArrayList<BookmarkVO> data;
		public Adapter(ArrayList<BookmarkVO> bookmarks) 
		{
			data = bookmarks;
		}

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return data.size();
		}

		@Override
		public Object getItem(int arg0) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public View getView(final int arg0, View arg1, ViewGroup arg2) 
		{
			final BookmarkVO vo = data.get(arg0);
			TextView tv = new TextView(arg2.getContext());
			tv.setText("Chapter "+(vo.getIndexOfChapter()+1)+" : "+vo.getText());
			tv.setTextSize(20);
			tv.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View arg0) 
				{
					PageVO pageVO = Utils.getPageVO(_chaptersColl,vo.getIndexOfChapter(), vo.getWordID());
					navigateToPage(pageVO);
					bookmarksDlg.dismiss();
					bookmarksListOpened = false;
				}
			});
			return tv;
		}
		
	}

	public void toggleBookmarksListDlg() 
	{
		showBookmarksList(!bookmarksListOpened,false);
	}
}
