package com.hurix.epubRnD.Parsers;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.hurix.epubRnD.Constants.GlobalConstants;
import com.hurix.epubRnD.Utils.Constants;
import com.hurix.epubRnD.VOs.ChapterVO;
import com.hurix.epubRnD.VOs.ManifestVO;
import com.hurix.epubRnD.VOs.PathVO;
import com.hurix.epubRnD.VOs.SpineVO;

public class EpubParser 
{
	private static EpubParser Object =null;

	public static EpubParser getObject()
	{
		if(Object ==null)
		{
			Object = new EpubParser();
		}

		return Object;
	}

	public Document getDocFromXmlFile(File f)  
	{
		Document doc = null;
		File file =null;
		try
		{
			doc = domParser(f);

			String _path = getAttValue(doc, Constants.ROOTFILE, Constants.FULLPATH);

			System.out.println("Value is " + _path);
			NodeList nList = doc.getElementsByTagName(Constants.ROOTFILES);
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				Element el = (Element) node;
			}

			file = new File(Constants.SDCARD, Constants.EPUBBOOK + _path);
			System.out.println("EPUB file is" + file);
		}catch(Exception e)
		{
			e.printStackTrace();
		}


		return domParser(file);

	}

	public String getFilepath(Document doc) 
	{
		String _spine = getAttValue(doc, Constants.SPINE, Constants.TOC);
		System.out.println("Toc id is" + _spine);

		NodeList manifest = doc.getElementsByTagName(Constants.ITEM);
		String id = "";
		String href = "";

		for (int i = 0; i < manifest.getLength(); i++) 
		{
			Node node = manifest.item(i);
			Element el = (Element) node;
			id = el.getAttribute(Constants.ID);
			if (_spine.equals(id)) {
				href = el.getAttribute(Constants.HREF);
			}

		}
		File href_path = new File(Constants.SDCARD, Constants.OEBPS + href);

		return href_path.getAbsolutePath();
	}

	public SpineVO getSpineFromXML(Document doc, String nodevalue) 
	{

		NodeList node = doc.getElementsByTagName(nodevalue);

		SpineVO sVO = new SpineVO();
		ArrayList<String> itemreflist = new ArrayList<String>();
		for (int j = 0; j < node.getLength(); j++)
		{

			Node aNode = node.item(j);
			Element fstElmnt = (Element) aNode;

			NodeList websiteList = fstElmnt.getElementsByTagName("itemref");
			int check = websiteList.getLength();

			for (int k = 0; k < check; k++)
			{

				Node checkNode = websiteList.item(k);

				Element websiteElement = (Element) checkNode;
				String id = websiteElement.getAttribute("idref");

				itemreflist.add(id);

			}
		}
		sVO.setIdref(itemreflist);
		return sVO;
	}


	public ManifestVO getManifestXML(Document doc, String nodevalue,SpineVO vo) 
	{

		ArrayList<String> spineItemList = vo.getIdref();

		NodeList node = doc.getElementsByTagName(nodevalue);

		ManifestVO sVO = new ManifestVO();
		LinkedHashMap<String, String> itemslist = new LinkedHashMap<String, String>();

		for (int j = 0; j < node.getLength(); j++)
		{

			Node aNode = node.item(j);
			Element fstElmnt = (Element) aNode;

			NodeList websiteList = fstElmnt.getElementsByTagName("item");
			int check = websiteList.getLength();

			for (int k = 0; k < check; k++)
			{

				Node checkNode = websiteList.item(k);

				Element websiteElement = (Element) checkNode;
				String id = websiteElement.getAttribute("id");
				String href = websiteElement.getAttribute("href");

				for (int i = 0; i < spineItemList.size(); i++)
				{
					if(id.equalsIgnoreCase(spineItemList.get(i)))
					{
						itemslist.put(id,href);
					}

				}


			}
		}
		sVO.setItem(itemslist);
		return sVO;
	}


	public Document domParser(File f)
	{
		Document doc =null;
		try
		{
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			doc= dBuilder.parse(f);
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return doc;
	}

	public String getAttValue(Document document, String nodeTag, String attrId)
	{
		NodeList rootNodeList = null;
		String attrValue = "";
		try {
			rootNodeList = document.getElementsByTagName(nodeTag);
			for (int i = 0; i < rootNodeList.getLength(); i++) {
				Node node = rootNodeList.item(i);
				Element el = (Element) node;
				attrValue = el.getAttribute(attrId);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
		}

		return attrValue;

	}

	public PathVO getUrlFromXML(ManifestVO manifest) 
	{


		Iterator i = manifest.getItem().keySet().iterator();
		PathVO pathVo = new PathVO();
		ArrayList<String> path = new ArrayList<String>();


		while(i.hasNext())
		{
			String key = i.next().toString();  
			String value = manifest.getItem().get(key);
			System.out.println(key + " " + value);
			path.add(value);

		}

		pathVo.set_urlFiles(path);
		return pathVo;

	}

	public ArrayList<ChapterVO> setUrlFromPathVo(PathVO pathViews) 
	{
		
		ArrayList<ChapterVO> chapterVOs = new ArrayList<ChapterVO>();
		for (int i = 0; i < pathViews.get_urlFiles().size(); i++) 
		{
			
			String value = pathViews.get_urlFiles().get(i);
			ChapterVO chapters = new ChapterVO();
			chapters.setChapterURL("file://"+GlobalConstants.ROOT_FOLDER+File.separator+"EPUB/"+value);
			chapterVOs.add(chapters);

		}
		
		return chapterVOs;

	}



}
