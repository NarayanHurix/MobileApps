package com.hurix.epubRnD.Utils;

import java.util.ArrayList;

import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.PageVO;

public class Utils 
{
	
	public static PageVO getPageVO(int pageNo,ArrayList<ChapterVO> chaptersColl)
	{
		int arrLength = chaptersColl.size();
	    int tempPageCount = 0;
	    for (int i=0; i<arrLength; i++)
	    {
	        ChapterVO tempCVO = chaptersColl.get(i);
	        tempPageCount+= tempCVO.getPageCount();
	        if(pageNo<=tempPageCount)
	        {
	            PageVO dao = new PageVO();
	            dao.setIndexOfChapter(i);
	            dao.setIndexOfPage(pageNo - (tempPageCount-tempCVO.getPageCount())-1);
	            return dao;
	        }
	    }
	    return null;
	}
	
	public static int getPageNo(PageVO dao, ArrayList<ChapterVO> chaptersColl)
	{
		int arrLength = chaptersColl.size();
	    int tempPageCount = 0;
	    for (int i=0; i<arrLength; i++)
	    {
	        ChapterVO tempCVO = chaptersColl.get(i);
	        tempPageCount+= tempCVO.getPageCount();
	        if(i == dao.getIndexOfChapter())
	        {
	            return tempPageCount-tempCVO.getPageCount()+(dao.getIndexOfPage()+1);
	        }
	    }
	    return -1;
	}
}
