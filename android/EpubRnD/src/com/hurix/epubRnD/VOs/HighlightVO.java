package com.hurix.epubRnD.VOs;

public class HighlightVO 
{
	private int _chapterIndex;
	private int _noOfPagesInChapter;
	private int _startWordID;
	private int _endWordID;
	private String _chapterPath;
	private String _selectedText;
	private boolean _hasNote;
	
	public int getChapterIndex() {
		return _chapterIndex;
	}
	public void setChapterIndex(int _chapterIndex) {
		this._chapterIndex = _chapterIndex;
	}
	public int getNumOfPagesInChapter() {
		return _noOfPagesInChapter;
	}
	public void setNumOfPagesInChapter(int _noOfPagesInChapter) {
		this._noOfPagesInChapter = _noOfPagesInChapter;
	}
	public int getStartWordID() {
		return _startWordID;
	}
	public void setStartWordID(int _startWordID) {
		this._startWordID = _startWordID;
	}
	public int getEndWordID() {
		return _endWordID;
	}
	public void setEndWordID(int _endWordID) {
		this._endWordID = _endWordID;
	}
	public String getChapterPath() {
		return _chapterPath;
	}
	public void setChapterPath(String _chapterPath) {
		this._chapterPath = _chapterPath;
	}
	public String getSelectedText() {
		return _selectedText;
	}
	public void setSelectedText(String _selectedText) {
		this._selectedText = _selectedText;
	}
	public boolean hasNote() {
		return _hasNote;
	}
	public void setHasNote(boolean _hasNote) {
		this._hasNote = _hasNote;
	}
	

}
