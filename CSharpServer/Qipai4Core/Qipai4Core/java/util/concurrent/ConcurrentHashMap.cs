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
using System.Collections;
using System.Linq;
using System.Text;
using System.Collections.Concurrent;

namespace java.util.concurrent
{
    public class ConcurrentHashMap<TKey, TValue> : ConcurrentDictionary<TKey, TValue>
    {

        public Boolean Add(TKey key, TValue addValue)
        {
            return this.put(key, addValue);
            
        }

        public Boolean put(TKey key, TValue addValue)
        {
            if (this.containsKey(key))
            {

                this[key] = addValue;

                return true;
            }           

            return this.TryAdd(key, addValue);
        }

        public TValue get(TKey key)
        {
            TValue value;

            bool b = this.TryGetValue(key, out value);
           
            return value;
        
        }

        public Boolean containsKey(TKey key)
        {
            return get(key) != null;
        }

        public Boolean Remove(TKey key)
        {

            return remove(key);
        }

        public Boolean remove(TKey key)
        {
            TValue value;
            return this.TryRemove(key,out value);
        }
        
    }
}
