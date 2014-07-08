package com.hurix.epubRnD.Controllers;

import java.util.ArrayList;

import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.WebViewDAO;
import com.hurix.epubRnD.Views.MyViewFlipper;
import com.hurix.epubRnD.Views.MyViewFlipper.OnPageChangeListener;
import com.hurix.epubRnD.Views.MyWebView;
import com.hurix.epubRnD.Views.PageView;

public class ViewPagerController implements OnPageChangeListener
{

	private ArrayList<ChapterVO> chaptersColl;
	private MyViewFlipper _mViewPager;
	
	
	public void setData(ArrayList<ChapterVO> chaptersColl,MyViewFlipper viewPager)
	{
		this.chaptersColl = chaptersColl;
		_mViewPager = viewPager;
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
		int pageCount = oldWebView.getData().getPageCount();
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
				
				WebViewDAO data = new WebViewDAO();
				data.setChapterVO(chaptersColl.get(chapterIndex));
				data.setIndexOfChapter(chapterIndex);
				data.setIndexOfPage(-2);
				data.setMaxScrollX(0);
				data.setScrollX(0);
				
				webView.setData(data);
				return pageView;
			}
		}
		else if(pageIndex <= pageCount-1)
		{
			//same chapter previous page
			PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
			MyWebView webView= pageView.getWebView();
			
			WebViewDAO data = new WebViewDAO();
			data.setChapterVO(chaptersColl.get(chapterIndex));
			data.setIndexOfChapter(chapterIndex);
			data.setIndexOfPage(pageIndex);
			data.setMaxScrollX(0);
			data.setScrollX(0);
			
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
		int pageCount = oldWebView.getData().getPageCount();
		pageIndex++;
		if(pageIndex>=pageCount)
		{
			pageIndex=0;
			chapterIndex++;
			if(chapterIndex>=chaptersColl.size())
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
				
				WebViewDAO data = new WebViewDAO();
				data.setChapterVO(chaptersColl.get(chapterIndex));
				data.setIndexOfChapter(chapterIndex);
				data.setIndexOfPage(pageIndex);
				data.setMaxScrollX(0);
				data.setScrollX(0);
				
				webView.setData(data);
				
				return pageView;
			}
		}
		else
		{
			//next page in same chapter
			PageView pageView = new PageView(oldPage.getContext(),_mViewPager);
			MyWebView webView= pageView.getWebView();
			
			WebViewDAO data = new WebViewDAO();
			data.setChapterVO(chaptersColl.get(chapterIndex));
			data.setIndexOfChapter(chapterIndex);
			data.setIndexOfPage(pageIndex);
			data.setPageCount(pageCount);
			data.setMaxScrollX(0);
			data.setScrollX(0);
			
			webView.setData(data);
			
			return pageView;
		}
		
	}
}
