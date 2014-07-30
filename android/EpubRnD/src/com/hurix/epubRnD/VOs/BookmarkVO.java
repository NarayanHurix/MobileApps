package com.hurix.epubRnD.VOs;

public class BookmarkVO 
{

	private int wordID;
	private String text;
	private int indexOfChapter;
	
	public int getWordID() {
		return wordID;
	}
	public void setWordID(int wordID) {
		this.wordID = wordID;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public int getIndexOfChapter() {
		return indexOfChapter;
	}
	public void setIndexOfChapter(int indexOfChapter) {
		this.indexOfChapter = indexOfChapter;
	}
}
