package com.hurix.epubRnD.VOs;

public class PageVO 
{
	private ChapterVO _chapterVO;
	private int indexOfPage;
	private int indexOfChapter;
	private int firstWordID;
	private int lastWordID;
	
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

	public int getFirstWordID() {
		return firstWordID;
	}

	public void setFirstWordID(int firstWordID) {
		this.firstWordID = firstWordID;
	}

	public int getLastWordID() {
		return lastWordID;
	}

	public void setLastWordID(int lastWordID) {
		this.lastWordID = lastWordID;
	}

}
