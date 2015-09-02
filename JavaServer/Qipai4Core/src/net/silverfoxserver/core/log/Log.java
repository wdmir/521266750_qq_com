/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.log;

import System.AppDomain;
import System.Console;
import System.ConsoleColor;
import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import System.IO.Path;
import java.io.File;
import java.time.LocalDate;
import java.time.LocalTime;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.util.SR;

/**
 *
 * @author FUX
 */
public class Log {
    
    private static int _createdDayOfYear;

    /** 
     须先手工创建logs目录，否则生成不了文件
    */
    public static final String fileDir = "logs";
    
    //java .log
    public static final String fileExtName = ".txt";

    private static String _fileName;
        
    private static Logger Trace;
    
    private static FileHandler _write;
    
    /** 
     打印级别
    */
    private static int _lvl = LoggerLvl.ALL2;
    
    /** 
    */
    public static void init(String GameName, int Lvl)
    {
        
        _createdDayOfYear = -1;

        if (GameName.equals(""))
        {
                WriteStr2("you need set file name for WriteFile!");
        }
                
        _fileName = GameName;
        
        //
        Trace = Logger.getLogger(GameName);

        String fileFullDir = Path.Combine(AppDomain.getCurrentDomain().getSetupInformation().getApplicationBase(),fileDir);
         
        File f = new File(fileFullDir);
         
        if (f.exists())
        {
            
            //nothing
           
        }else{
           
            f.mkdir();
        }
        
         WriteStr2("[LOG] " + fileFullDir);
         
        //
        checkFile();
    }
    
    
    
    /** 
     通用，前面无时间显示

     @param messageStr
    */
    public static void WriteStr2(String messageStr)
    {
        if(Console.ForegroundColor == ConsoleColor.Red){
            
            System.err.println(String.format("%1$s", messageStr));    
            
        }else{
            
            System.out.println(String.format("%1$s", messageStr));
        }
    }
    
    
    public static String getYear()
    {   
            int year =  LocalDate.now().getYear();

            return String.valueOf(year);
    }

    public static String getMonth()
    {
            int month = LocalDate.now().getMonthValue();
            
            String monthStr = String.valueOf(month);

            if (1 == monthStr.length())
            {
                    monthStr = "0" + monthStr;
            }

            return monthStr;
    }

    public static String getDay()
    {
            int day = LocalDate.now().getDayOfMonth();

            String dayStr = String.valueOf(day);
            
            if (1 == dayStr.length())
            {
                    dayStr = "0" + dayStr;
            }

            return dayStr;

    }

    public static String getHour()
    {
            int hour = LocalTime.now().getHour();

            String hourStr = String.valueOf(hour);
            
            if (1 == hourStr.length())
            {
                    hourStr = "0" + hourStr;
            }

            return hourStr;
    }

    public static String getMinute()
    {
        
            int minute = LocalTime.now().getMinute();

            String minuteStr = String.valueOf(minute);
            
            if (1 == minuteStr.length())
            {
                    minuteStr = "0" + minuteStr;
            }

            return minuteStr;
    }

    public static String getSecond()
    {
            int second = LocalTime.now().getSecond();
            String secondStr = String.valueOf(second);

            if (1 == secondStr.length())
            {
                    secondStr = "0" + secondStr;
            }

            return secondStr;
    }

    public static String getMillisecond()
    {
            int millisecond =  LocalTime.now().getNano();

            String millisecondStr = String.valueOf(millisecond);
            
            if (1 == millisecondStr.length())
            {
                    millisecondStr = "0" + "0" + millisecondStr;
            }
            else if (2 == millisecondStr.length())
            {
                    millisecondStr = "0" + millisecondStr;
            }

            return millisecondStr;
    }
    
    /** 
	 

     @param className
     @param funcName
     @param cause
     @param source
     @param stack
    */
    public static void WriteStrByExceptionByNoWriteFile(String className, String funcName, String cause, String source, String stack)
    {
            System.out.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s:%12$s %13$s:%14$s", 
                            getHour(), getMinute(), getSecond(), getMillisecond(), 
                            SR.getExce_p_tion(), className, SR.getFunc_tion(), funcName, SR.getCasue(), cause, SR.getSource(), source, SR.getStack(), stack));

            //此函数不Write File，只打印
    }

    /** 
     try-catch捕获的异常描述

     @param ipAndPort
     @param errCode
     @param cause
    */
    public static void WriteStrByException(String className, String funcName, String cause)
    {
            System.err.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s", 
                            getHour(), getMinute(), getSecond(), getMillisecond(),
                            SR.getExce_p_tion(), className, SR.getFunc_tion(), funcName, SR.getCasue(), cause));

            //
            WriteFileByException(className, funcName, cause);
    }

	/** 
	 
	 
     @param className
     @param funcName
     @param cause
     @param source
    */
    public static void WriteStrByException(String className, String funcName, String cause, StackTraceElement[] source)
    {
        
        StackTraceElement ste;
        
        String sourceStr = "";
        
        if(source.length > 0){
            ste = source[0];
            
            sourceStr = "Line="+ste.getLineNumber();
            sourceStr += " ";
            sourceStr += "File="+ste.getFileName();
        } 
        
        
        
                
//        System.out.println("File="+stackTraceElement.getFileName()); 
//        System.out.println("Line="+stackTraceElement.getLineNumber()); 
//        System.out.println("Method="+stackTraceElement.getMethodName());

        
            System.out.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s:%12$s",
                            getHour(), getMinute(), getSecond(), getMillisecond(), 
                            SR.getExce_p_tion(), className, SR.getFunc_tion(), funcName, SR.getCasue(), cause, SR.getSource(), sourceStr));

            //
            WriteFileByException(className, funcName, cause, sourceStr);
    }

	/** 
	 
	 
     @param className
     @param funcName
     @param cause
     @param stack
    */
    public static void WriteStrByException(String className, String funcName, String cause, String source, String stack)
    {
            System.out.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s:%12$s %13$s:%14$s", 
                            getHour(), getMinute(), getSecond(), getMillisecond(), 
                            SR.getExce_p_tion(), className, SR.getFunc_tion(), funcName, SR.getCasue(), cause, SR.getSource(), source, SR.getStack(), stack));

            //
            WriteFileByException(className, funcName, cause, source, stack);
    }

	/** 
     参数的异常描述

     @param ipAndPort
     @param errCode
     @param cause
    */
    public static void WriteStrByArgument(String className, String funcName, String arguName, String cause)
    {
            System.out.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s", 
                            getHour(), getMinute(), getSecond(), getMillisecond(), 
                            SR.getClas_s_Name(), className, SR.getFunc_tion(), funcName, SR.getParam(), arguName, cause));
    }

    /** 


     @param errCode
     @param ipAndPort
     @param cause 关闭原因
     @return 
    */
    public static void WriteStrByExceptionClose(String ipAndPort, String errCode, String cause)
    {
            System.out.println(
                    String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s", 
                            getHour(), getMinute(), getSecond(), getMillisecond(), SR.getDisconnect_the_server_exception(),
                            ipAndPort, SR.getDesc(), errCode, SR.getCasue(), cause));
    }

    /** 


     @param ipAndPort
     @param cause 关闭原因
     @return 
    */
    public static void WriteStrByClose(String ipAndPort, String cause)
    {
            if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
            {
                    return;
            }

            System.err.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s /%7$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getDisconnect(), cause, ipAndPort));
    }

	/** 
	 
	*/
	public static void WriteStrByVcNoValue(String actionStr, String ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getVcNoValue(), actionStr, ipAndPort));

	}

	/** 
	 
	 
	 @param actionStr
	 @param ipAndPort
	 @param vc_client
	 @param vc_server
	 @param doc_OuterXml
	*/
	public static void WriteStrByVcNoMatch(String actionStr, String ipAndPort, String vc_client, String vc_server, String vc_XmlMsg)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s \n\tC:%8$s \n\tS:%9$s \n\tXmlMsg:%10$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getVcErr(), actionStr, ipAndPort, vc_client, vc_server, vc_XmlMsg));
	}

	/** 
	 
	 
	 @param from
	 @param actionStr
	 @param ipAndPort
	*/
	public static void WriteStrByRecv(String actionStr, String ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		//

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s /%7$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRecv(), actionStr, ipAndPort));
	}

	/** 
	 转发
	 
	 @param target 转发的目标
	 @param actionStr
	 @param ipAndPort
	*/
	public static void WriteStrByTurn(String target, String ipAndPort, String actionStr)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getTurn(), actionStr, target, ipAndPort));
	}
        
       
	/** 
	 
	 
	 @param target
	 @param ipAndPort
	 @param actionStr
     * @param n
     * @param v
	*/
	public static void WriteStrByTurn(String target, String ipAndPort, String actionStr, String n, String v)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s IP:%8$s n:%9$s v:%10$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getTurn(), actionStr, target, ipAndPort, n, v));
	}

	/** 
	 
	 
	 @param actionStr
	*/
	public static void WriteStrByServerRecv(String actionStr, String serverName)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		//

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s %6$s %7$s:%8$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getFrom(), serverName, SR.getRecv(), actionStr));
	}

	public static void WriteStrByMySqlRecv(String actionStr, String rowCount)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRecv(), actionStr, SR.getAffectedRows(), rowCount));
	}

	public static void WriteStrByMySqlRecv(String actionStr, String rowCount, String cloumn, String param1, String username)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s %12$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRecv(), actionStr, SR.getAffectedRows(), rowCount, SR.getCloumn(), cloumn, param1, username));
	}


	public static void WriteStrByMySqlRecv(String actionStr, String rowCount, String cloumn, String param1, String param2, String username)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s %11$s %12$s %13$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRecv(), actionStr, SR.getAffectedRows(), rowCount, SR.getCloumn(), cloumn, param1, param2, username));
	}



	public static void WriteStrByMySqlWarnning(String actionStr, String rowCount)
	{
		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getWarning(), actionStr + " Warnning", SR.getCasue(), rowCount));
	}

        public static void WriteStrByMySqlWarnning(String actionStr, String rowCount,String sql)
	{
            //警告:SELECT Warnning 原因:0 
            
		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s:%8$s %9$s:%10$s",
                        getHour(), getMinute(), getSecond(), getMillisecond(), 
                        SR.getWarning(), actionStr,
                        SR.getAffectedRows(), rowCount,
                        SR.getSqlStatement(), sql
                ));
	}


	/** 
	 
	 
	 @param actionStr
	 @param ipAndPort
	*/
	public static void WriteStrBySend(String actionStr, String ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s /%7$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRespond(), actionStr, ipAndPort));
	}

	public static void WriteStrBySend(String actionStr, String ipAndPort, String cause)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s %8$s:%9$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRespond(), actionStr, ipAndPort, SR.getCasue(), cause));
	}

	/** 
	 
	 
	 @param content
	*/
	public static void WriteStrByConnect(String content)
	{
	   //必须打印

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s", getHour(), getMinute(), getSecond(), getMillisecond(), content));
	}

	public static void WriteStrBySendFailed(String actionStr, String ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s %8$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getRespond_failed(), actionStr, ipAndPort, SR.getDisconnected()));
	}

	public static void WriteStrByMultiSend(String actionStr, java.util.ArrayList<IUserModel> ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		String ipAndPortStr = "";

		for (int i = 1;i <= ipAndPort.size();i++)
		{
			ipAndPortStr += ipAndPort.get(i - 1).getNickName();

			if (i == ipAndPort.size())
			{
				//nothing
			}
			else
			{
				ipAndPortStr += ",";
			}
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getTurnGroup(), actionStr, ipAndPortStr));
	}

	public static void WriteStrByMultiSend(String actionStr, String ipAndPort)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getTurnGroup(), actionStr, ipAndPort));
	}
        
        public static void WriteStrByMultiSend(String actionStr, String ipAndPort,int roomId)
	{
		if (LoggerLvl.CLOSE0 == _lvl || LoggerLvl.NORMAL1 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s IP:%7$s Room:%8$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getTurnGroup(), actionStr, ipAndPort,String.valueOf(roomId)));
	}

	public static void WriteStrByWarn(String content)
	{
		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s ", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getWarning(), content));
	}


	/** 
	 通用
	*/
	public static void WriteStr(String content)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s", getHour(), getMinute(), getSecond(), getMillisecond(), content));

		//
		WriteFile(content);
	}

	/** 
	 通用，前面无时间显示
	 
	 @param messageStr
	*/
//	public static void WriteStr2(String messageStr)
//	{
//		System.out.println(String.format("%1$s", messageStr));
//	}
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
		///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
		///#region File 打印

	private static void checkFile()
	{
		if (_fileName.equals(""))
		{
			WriteStr2("you need set fileName for WriteFile!");
			return;
		}

		//按天来，与文件名对应
		//否则会生成前面带md5码的文件,如:b7253c9b-b9bc-4fbe-90bf-e9a102338dc9DdzLogic_2012_4_15.txt
		//int nowDayOfYear = DateTime.Now.DayOfYear;

		//if (_createdDayOfYear != nowDayOfYear)
                
                
                
		if (_createdDayOfYear != LocalDate.now().getDayOfYear())
		{
                    try {
                        if (null != _write)
                        {
                            //Trace.Listeners.Remove(_write);
                            _write.close();
                            Trace.removeHandler(_write);
                        }
                        
                        //
                        _createdDayOfYear = LocalDate.now().getDayOfYear();
                        
                        //
                        String fileFullPath = getFileFullPath();
                        
                        //_write = new TextWriterTraceListener(fileFullPath);
                        _write = new FileHandler(fileFullPath,true);
                        Trace.addHandler(_write);
                        
                        //Trace.Listeners.Add(_write);
                        //Trace.AutoFlush = true;
                    } catch (IOException | SecurityException ex) {
                        Logger.getLogger(Log.class.getName()).log(Level.SEVERE, null, ex);
                    }


		}



	}

	/** 
	 不需要小时，按天计看起来清爽些
	 
	 write每小时更换一次
	 
	 @return 
	*/
	public static String getFileFullPath()
	{
		return Path.Combine(AppDomain.getCurrentDomain().getSetupInformation().getApplicationBase(),
                        fileDir) + Path.getFilePathSeparator() + 
                        _fileName + 
                        "_" + LocalDate.now().getYear() + 
                        "_" + LocalDate.now().getMonth().getValue() + 
                        "_" + LocalDate.now().getDayOfMonth() +
                        fileExtName;
	}



	/**
	 * 这里输出的是txt格式，
	 * xml格式因为有头和尾结点，因此无法输出
	 * 这里输出到.txt文件，可以查看
	 * xml项格式，方便统计
	 * 
	 */ 
	public static void WriteFileByMySqlRecv(String actionStr, String rowCount, String cloumn, String param1, String param2, String username)
	{
		//必须打印，不受logLvl限制

		//
		checkFile();

		//[18:59:41,953] 收到:mysql update 影响行数:1 extcredits1,add:3,1026,iui2004
		Trace.log(Level.INFO,
                        String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' a='%6$s' row='%7$s' c='%8$s' p1='%9$s' p2='%10$s' n='%11$s' />", 
                                _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), 
                                actionStr, rowCount, cloumn, param1, param2, username)
                );
                
			 //string.Format("[{0}:{1}:{2},{3}] 收到:{4} 影响行数:{5} {6},{7},{8},{9}", getHour(), getMinute(), getSecond(), getMillisecond(), actionStr, rowCount, cloumn, param1, param2, username)
	}

	/** 
	 try-catch捕获的异常描述
	 不需要trace，WriteStrByException会调用本函数
	 
	 @param ipAndPort
	 @param errCode
	 @param cause
	*/
	private static void WriteFileByException(String className, String funcName, String cause)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		//不需要trace，WriteStrByException会调用本函数

                
		Trace.log(Level.FINE,
                        //String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' content='异常:类:%6$s 函数:%7$s 原因:%8$s'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), className, funcName, cause));
                        String.format("%1$s:%2$s:%3$s %4$s:%5$s %6$s:%7$s", SR.getExce_p_tion(),SR.getClas_s_Name(),className, SR.getFunc_tion(),funcName, SR.getCasue(),cause));
	}


	private static void WriteFileByException(String className, String funcName, String cause, String source)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		//不需要trace，WriteStrByException会调用本函数

		Trace.log(Level.INFO,
                        //String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' content='异常:类:%6$s 函数:%7$s 原因:%8$s 源:%9$s'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), className, funcName, cause, source));
                         String.format("%1$s:%2$s:%3$s %4$s:%5$s %6$s:%7$s %8$s:%9$s", SR.getExce_p_tion(),SR.getClas_s_Name(),className, SR.getFunc_tion(),funcName, SR.getCasue(),cause,SR.getSource(),source));
	}

	private static void WriteFileByException(String className, String funcName, String cause, String source, String stack)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		//不需要trace，WriteStrByException会调用本函数

		Trace.log(Level.INFO,
                        //String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' content='异常:类:%6$s 函数:%7$s 原因:%8$s 源:%9$s 栈%10$s'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), className, funcName, cause, source, stack));
                        String.format("%1$s:%2$s:%3$s %4$s:%5$s %6$s:%7$s %8$s:%9$s %10$s:%11$s", SR.getExce_p_tion(),SR.getClas_s_Name(),className, SR.getFunc_tion(),funcName, SR.getCasue(),cause,SR.getSource(),source,SR.getStack(),stack));
	}

	public static void WriteFileByLoginSuccess(String accountName, String fromIp)
	{

		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s %7$s IP:%8$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getUser(), accountName, SR.getLoginSuccess(), fromIp));

		//Console.WriteLine(
		//   string.Format("<{0} t='{1}:{2}:{3},{4}' online='{5}' logined='{6}' ip='{7}'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), count.ToString(), accountName, fromIp)
		//   );

		Trace.log(Level.INFO,
                        String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' logined='%6$s' ip='%7$s'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), accountName, fromIp));
	}

	public static void WriteFileByOnlineUserCount(int count)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		System.out.println(String.format("[%1$s:%2$s:%3$s,%4$s] %5$s:%6$s", getHour(), getMinute(), getSecond(), getMillisecond(), SR.getOnline(), (new Integer(count)).toString()));

		//Console.WriteLine(
		//   string.Format("<{0} t='{1}:{2}:{3},{4}' online='{5}' logined='{6}' ip='{7}'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), count.ToString(), accountName, fromIp)
		//   );

		Trace.log(Level.INFO,
                        String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' online='%6$s'/>", _fileName, getHour(), getMinute(), getSecond(), getMillisecond(), (new Integer(count)).toString()));
	}

	/** 
	 通用
	*/
	public static void WriteFile(String content)
	{
		if (LoggerLvl.CLOSE0 == _lvl)
		{
			return;
		}

		//
		checkFile();

		Trace.log(Level.INFO,
                        String.format("<%1$s t='%2$s:%3$s:%4$s,%5$s' content='%6$s' />", _fileName,getHour(), getMinute(), getSecond(), getMillisecond(), content));
	}
    
    
    
    
    
    
    
    
        
}
