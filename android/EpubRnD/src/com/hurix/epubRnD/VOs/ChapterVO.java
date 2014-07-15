package com.hurix.epubRnD.VOs;


public class ChapterVO {
	private String chapterURL;
	private int pageCount;
	
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
}
