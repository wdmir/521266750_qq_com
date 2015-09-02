/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extmodel;

import System.Xml.XmlDocument;
import java.io.IOException;
import net.wdqipai.server.*;
import org.jdom2.JDOMException;

/** 
 棋盘
 该类不需要factory
*/
public class ChessBoardByChChess
{
	
	/** 
	 棋盘
	*/
	public String[][] grid;

	/** 
	 棋子初始位置
	*/
	public String gridXml;

	/** 
	 如果您選擇不初始化就宣告陣列變數，您必須使用 new 運算子來將陣列指派至變數。例如：
	
	VBC#C++F#JScript
	複製int[,] array5;
	array5 = new int[,] { { 1, 2 }, { 3, 4 }, { 5, 6 }, { 7, 8 } };   // OK
	array5 = {{1,2}, {3,4}, {5,6}, {7,8}};   // Error
	*/
	public ChessBoardByChChess() throws JDOMException, IOException
	{
            
		this.gridXml = "";

		//
		reset();
	}

	public ChessBoardByChChess(String gridXml) throws JDOMException, IOException
	{
		this.gridXml = gridXml;

		//
		reset();
	}

	/** 
	 重设棋盘
	*/
	public final void reset() throws JDOMException, IOException
	{
		if (gridXml.equals(""))
		{
			grid = new String[][]{
                            {QiziName.black_ju_2,QiziName.black_ma_2,QiziName.black_xiang_2,QiziName.black_shi_2,QiziName.black_jiang_1,QiziName.black_shi_1,QiziName.black_xiang_1,QiziName.black_ma_1,QiziName.black_ju_1}, 
                            {"","","","","","","","",""}, 
                            {"",QiziName.black_pao_1,"","","","","",QiziName.black_pao_2,""}, 
                            {QiziName.black_bing_5,"",QiziName.black_bing_4,"",QiziName.black_bing_3,"",QiziName.black_bing_2,"",QiziName.black_bing_1}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {QiziName.red_bing_1,"",QiziName.red_bing_2,"",QiziName.red_bing_3,"",QiziName.red_bing_4,"",QiziName.red_bing_5}, 
                            {"",QiziName.red_pao_1,"","","","","",QiziName.red_pao_2,""}, 
                            {"","","","","","","","",""}, 
                            {QiziName.red_ju_1,QiziName.red_ma_1,QiziName.red_xiang_1,QiziName.red_shi_1,QiziName.red_jiang_1,QiziName.red_shi_2,QiziName.red_xiang_2,QiziName.red_ma_2,QiziName.red_ju_2}
                        };
		}
		else
		{
			grid = new String[][]{
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}, 
                            {"","","","","","","","",""}
                        };

			XmlDocument gridDoc = new XmlDocument();
			gridDoc.LoadXml(gridXml);

			int len = 0;//gridDoc.DocumentElement.ChildNodes.size();

			//录入残局库时可能会出现手工错误，因此这里加try catch
			try
			{

				for (int i = 0; i < len; i++)
				{
//					XmlNode gridNode = gridDoc.DocumentElement.ChildNodes[i];
//
//					String qn = gridNode.Attributes["n"].Value;
//					int x = (int)(gridNode.Attributes["x"].Value);
//					int y = (int)(gridNode.Attributes["y"].Value);
//
//					grid[x][y] = qn;

				}
			}
			catch (RuntimeException exd)
			{
				//System.out.println("加载残局库失败:" + gridDoc.DocumentElement.Attributes["name"].Value + " " + exd.getMessage());

			}

		}


	}

	/** 
	 这里可以判断走棋规则的合法性，
	 目前没有判断，靠客户端判断
	 
	 @param viewName
	 @param h
	 @param v
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public void update(string viewName, uint h,uint v)
	public final void update(String viewName, int h, int v)
	{
		//clear
		for (int i = 0; i < 10; i++)
		{
			for (int j = 0; j < 9; j++)
			{
				if (viewName.equals(grid[i][j]))
				{
					grid[i][j] = "";
					break;
				}

			}

		}

		//move
		//直接覆盖原值
		grid[(h - 1)][(v - 1)] = viewName;
	}

	/** 
	 这个地方采用服务器计算，防止客户端作弊
	 
	 @param name
	 @return 
	*/
	public final Qizi getQizi(String viewName)
	{
		for (int i = 0; i < 10; i++)
		{
			for (int j = 0; j < 9; j++)
			{
				if (viewName.equals(grid[i][j]))
				{
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: uint h = Convert.ToUInt32(i+1);
					int h = (int)(i + 1);
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: uint v = Convert.ToUInt32(j + 1);
					int v = (int)(j + 1);

					return new Qizi(viewName, h, v);
				}

			}

		}

		throw new IllegalArgumentException("can't find " + viewName + " on chess board");

	}

	public final String toXMLString()
	{
		StringBuilder sb = new StringBuilder();

		//chessboard抽像成item节点

		for (int i = 0; i < 10; i++)
		{
			for (int j = 0; j < 9; j++)
			{
				if ("" != grid[i][j])
				{
					//qizi抽像成item
					sb.append("<item n='");

					sb.append(grid[i][j]);

					sb.append("' h='");

					int k = i + 1;

					sb.append((new Integer(k)).toString());

					sb.append("' v='");

					int m = j + 1;

					sb.append((new Integer(m)).toString());

					sb.append("'/>");

				}

			}

		} //end for

		return sb.toString();
	}

}
