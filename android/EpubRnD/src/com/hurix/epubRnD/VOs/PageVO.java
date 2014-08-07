package com.hurix.epubRnD.VOs;

import com.hurix.epubRnD.Constants.GlobalConstants;

public class PageVO 
{
	private ChapterVO _chapterVO;
	private int indexOfPage;
	private int indexOfChapter;
	private int firstWordID;
	private int lastWordID;
	private int wordIDToGetIndexOfPage;
	
	public ChapterVO getChapterVO() {
		return _chapterVO;
	}

	public void setChapterVO(ChapterVO _chapterVO) {
		this._chapterVO = _chapterVO;
	}

	public int getIndexOfPage() {
		return indexOfPage;
	}
	/**
	 * when we don't know the index of page then set it to GlobalConstants.GET_PAGE_INDEX_USING_WORD_ID
	 * and set any wordID belong to respective page
	 * @param indexOfPage
	 */
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

	public int getWordIDToGetIndexOfPage() {
		return wordIDToGetIndexOfPage;
	}

	public void setWordIDToGetIndexOfPage(int wordIDToGetIndexOfPage) {
		this.wordIDToGetIndexOfPage = wordIDToGetIndexOfPage;
	}

}
