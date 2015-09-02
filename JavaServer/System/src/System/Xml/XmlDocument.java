/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System.Xml;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;
import java.util.List;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;
import org.jdom2.xpath.XPath;

/**
 *
 * @author ACER-FX
 */
public class XmlDocument 
{
    
    private Document _d;
    private String _dSnap;
    
    public XmlDocument()
    {
        
    }
    
    public void Load(String filename) throws JDOMException, IOException
    {
        SAXBuilder saxBuilder;
        saxBuilder = new SAXBuilder();
                   
        File f = new File(filename);
        _d = saxBuilder.build(f);
        
        //
        BufferedReader bufRead=new BufferedReader(new InputStreamReader(new FileInputStream(f))); 
        
        _dSnap = "";
        
        String strTmp = "";
        while((strTmp=bufRead.readLine())!=null) 
        { 
            _dSnap += strTmp;
            _dSnap += "\n";
        }
        
       
        //trace();
    }
    
    public void LoadXml(String xml) throws JDOMException, IOException
    {
        SAXBuilder saxBuilder;
        saxBuilder = new SAXBuilder();
        
        Reader xmlReader = new StringReader(xml);
        _d = saxBuilder.build(xmlReader);
        _dSnap = xml;
    }
   
    public Element getDocumentElement()
    {
        return _d.getRootElement();
    
    }
    
    /**
     * XPATH 
     * http://www.ibm.com/developerworks/cn/xml/x-jdom/
     * 
     * 注意:在使用dom4j的xpath时出现java.lang.NoClassDefFoundError: org/jaxen/JaxenException的异常，
     * 原因是dom4j引用了jaxen jar包，而在项目中没有引用此jar包，引用此jar包即可解决问题，
     * 如果你用了maven，在pom.xml中添加如下配置就可以了
     * 
     * @param xpath
     * @throws org.jdom2.JDOMException
     */
    public XmlNode SelectSingleNode(String xpath) throws JDOMException
    {
        
        //
        if(xpath.indexOf("//") != 0)
        {
            
            xpath = "/" + xpath;
        }
        
                
        //
        Element root = _d.getRootElement();          
                
        Element node = (Element)XPath.selectSingleNode(root, xpath);  
       
        return new XmlNode(node);
    
    }
    
    
    public XmlNodeList SelectNodes(String xpath) throws JDOMException
    {
        
        //
        if(xpath.indexOf("//") != 0)
        {
            
            xpath = "/" + xpath;
        }
        
                
        //
        Element root = _d.getRootElement();          
                
        List<?> node = XPath.selectNodes(root, xpath);  
       
        return new XmlNodeList(node);
    
    }
    
    public String OuterXml()
    {
        return toString();
    }
    
    
    @Override
    public String toString()
    {
        //return _dSnap;
        return (new XMLOutputter()).outputString(_d);
    }
    
}
