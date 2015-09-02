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

import java.util.List;
import org.jdom2.Attribute;
import org.jdom2.Content;
import org.jdom2.Element;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author ACER-FX
 */
public class XmlNode 
{
    
    private Element _e;
    
    public XmlNode(Element value)
    {
        _e = value;
    
       
    }
    
    public Element[] ChildNodes()
    {
        //List<Element>
        Element[] a = new Element[_e.getChildren().size()];
        
        return _e.getChildren().toArray(a);
    }
    
    public Element ParentNode()
    {
        return  _e.getParentElement();
    }
    
    /**
     * (new XMLOutputter()).outputString(
     * 
     * @return 
     */
    public String OuterXml()
    {    
       
       return (new XMLOutputter()).outputString(_e);
        
       //自已写的也能用，暂未发现问题
//       StringBuilder sb = new StringBuilder();
//       
//       //
//       sb.append("<").append(_e.getName());
//       
//       List<Attribute> eAtt = _e.getAttributes();
//       
//       for(int i=0;i<eAtt.size();i++)
//       {
//           sb.append(" ");
//           sb.append(eAtt.get(i).getName());
//           sb.append("='");
//           sb.append(eAtt.get(i).getValue());
//           sb.append("'");
//       }
//       
//       sb.append(">");
//       
//       //
//       List<Element> list = _e.getChildren();
//       
//       for (Element eChild : list) {
//            
//            sb.append("<").append(eChild.getName());
//            
//            List<Attribute> eChildAtt = eChild.getAttributes();
//            
//            for(int i=0;i<eChildAtt.size();i++)
//            {
//               sb.append(" ");
//               sb.append(eChildAtt.get(i).getName());
//               sb.append("='");
//               sb.append(eChildAtt.get(i).getValue());
//               sb.append("'");
//            }
//            
//            sb.append(">");
//            
//            //
//            sb.append(eChild.getText());
//            //
//            
//            sb.append("</").append(eChild.getName()).append(">");
//       }
//        
//       //
//       sb.append(_e.getText());
//       sb.append("</").append(_e.getName()).append(">");
//         
//       
//       return sb.toString();
//       
        
    }
    
    public String InnerXml()
    {
        return (new XMLOutputter()).outputElementContentString(_e);
    }
    
    public String getText()
    {    
       return _e.getText();//
    }
    
    public String InnerText()
    {    
       return _e.getText();//
    }
    
    public void setInnerText(String value)
    {    
       _e.setText(value);
    }
    
    public String getAttributeValue(String attname)
    {
        return _e.getAttributeValue(attname);
    }
    
}
