package com.qq.open.https;

import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.X509TrustManager;

 
 /**
 * 自定义签名证书管理类 (接受任意来源证书)
 *
 * @version 3.0.0
 * @since jdk1.5
 * @author open.qq.com
 * @copyright © 2012, Tencent Corporation. All rights reserved.
 * @History:
 *               3.0.0 | nemozhang | 2012-03-21 12:01:05 | initialization
*/

 
public class MyX509TrustManager implements X509TrustManager 
{

	/* (non-Javadoc)
	 * @see javax.net.ssl.X509TrustManager#checkClientTrusted(java.security.cert.X509Certificate[], java.lang.String)
	 */
	public void checkClientTrusted(X509Certificate[] arg0, String arg1)
		throws CertificateException 
    {

	}

	/* (non-Javadoc)
	 * @see javax.net.ssl.X509TrustManager#checkServerTrusted(java.security.cert.X509Certificate[], java.lang.String)
	 */
	public void checkServerTrusted(X509Certificate[] arg0, String arg1)
		throws CertificateException 
    {

	}

	/* (non-Javadoc)
	 * @see javax.net.ssl.X509TrustManager#getAcceptedIssuers()
	 */
	public X509Certificate[] getAcceptedIssuers() 
    {
		return null;
	}

}
