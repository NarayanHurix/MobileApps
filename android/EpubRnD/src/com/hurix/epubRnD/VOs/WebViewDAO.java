package com.hurix.epubRnD.VOs;

public class WebViewDAO 
{
	private ChapterVO _chapterVO;
	private int indexOfPage;
	private int indexOfChapter;
	private int pageCount;
	
	public ChapterVO getChapterVO() {
		return _chapterVO;
	}

	public void setChapterVO(ChapterVO _chapterVO) {
		this._chapterVO = _chapterVO;
	}

	public int getIndexOfPage() {
		return indexOfPage;
	}

	public void setIndexOfPage(int indexOfPage) {
		this.indexOfPage = indexOfPage;
	}

	public int getIndexOfChapter() {
		return indexOfChapter;
	}

	public void setIndexOfChapter(int indexOfChapter) {
		this.indexOfChapter = indexOfChapter;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

}
