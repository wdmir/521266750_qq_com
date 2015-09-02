/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Text;

namespace net.silverfoxserver.core.buffer
{
    /// <summary>
    /// 原理是拷出该数组中的一部分
    /// </summary>
    public class ByteBuffer
    {
        /// <summary>
        /// 指定长度的中间数组
        /// </summary>
        private Byte[] _content;
        
        //当前数组长度
        private int _current_length = 0;

        //最后返回数组
        private Byte[] _return_array;

        /// <summary>
        /// 默认构造函数
        /// 注意size值如果大于4096,则会重设为4096
        /// 初次申请的内存不能大于4096
        /// </summary>
        public ByteBuffer(int size)
        {
            if (size > 4096)
            {
                size = 4096;
            }

            //
            _content = new Byte[size];
            
            //
            _current_length = 0;
        }

        /// <summary>
        /// 向ByteBuffer压入一个字节
        /// </summary>
        /// <param name="by">一位字节</param>
        public void put(Byte b)
        {
            if (_current_length >= (_content.Length-1))
            {
                //new 一个大1倍的
                Byte [] tmp_array = new Byte[_current_length*2];
                //复制
                Array.Copy(_content, 0, tmp_array, 0, _content.Length);
                //
                _content = tmp_array;
            }

            _content[_current_length++] = b;
        }

         /// <summary>
        /// 获取当前ByteBuffer的长度
        /// </summary>
        public int Length
        {
            get
            {
                return _current_length;
            }
        }
       
        /// <summary>
        /// 获取ByteBuffer所生成的数组
        /// 长度必须小于 [MAXSIZE]
        /// </summary>
        /// <returns>Byte[]</returns>
        public Byte[] ToByteArray()
       {
            //分配大小
            _return_array = new Byte[_current_length];
            //调整指针
            Array.Copy(_content, 0, _return_array, 0, _current_length);
            return _return_array;
        }


    }
}
