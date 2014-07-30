package com.hurix.epubRnD.VOs;

import java.util.ArrayList;


public class ChapterVO 
{
	private String chapterURL;
	private int pageCount;
	private ArrayList<BookmarkVO> bookmarksColl;
	
	public String getChapterURL() {
		return chapterURL;
	}

	public void setChapterURL(String path) {
		this.chapterURL = path;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	
	public ArrayList<BookmarkVO> getBookmarksColl()
	{
		if(bookmarksColl == null)
		{
			bookmarksColl = new ArrayList<BookmarkVO>();
		}
		return bookmarksColl;
	}
}
