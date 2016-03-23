---
layout: post
title:  "Cookie and Session"
date:   2016-02-29 20:06:00 - 0800
categories: Backend
---
* 内容目录
{:toc}


## Cookie

### 什么是Cookie ？

由于`http`是无状态协议，它不会对之前发生过的请求和响应的状态进行管理。无状态协议虽然资源消耗少，但由于其无法管理如登陆状态等信息，给服务器管理客户端的状态带来了难题。

![图解Http_状态]({{site.baseurl}}/pics/http.png)

为了解决该问题，Cookie技术被引入，通过在请求和响应报文中写入Cookie信息来控制客户端的状态。

### Cookie的工作原理

在服务端发送的响应报文内会有一个`Set-Cookie`字段信息，通知客户端保存Cookie。当客户端在此往同一服务器发送请求时，客户端会自动在请求报文中加入Cookie值，其选择Cookie的依据是当前的url地址。

![Cookie工作流程]({{site.baseurl}}/pics/http_process.png)

### Cookie的类型与内容

Cookie中内容以Key-Value的形式存储，存在两种类型的Cookie:

+ `session cookie`（会话Cookie）：未设置过期时间的cookie，一般被保存在内存中，cookie的生命周期为浏览器会话期间
+ `persistent cookie`（持久Cookie）：设置了过期时间的cookie，浏览器会将其保存在硬盘上，直至其过期失效

PS:图片来自《图解Http》,书中图画的萌，我就不重新画了

### Cookie示例

参考：[Spring MVC](http://www.importnew.com/15141.html)

	package com.springapp.mvc.controller;

	import org.springframework.stereotype.Controller;
	import org.springframework.ui.ModelMap;
	import org.springframework.web.bind.annotation.CookieValue;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.ResponseBody;

	import javax.servlet.http.Cookie;
	import javax.servlet.http.HttpServletResponse;

	@Controller
	@RequestMapping(value = "/testCookie")
	public class HelloController {

    	@RequestMapping(method = {RequestMethod.POST, RequestMethod.GET})
    	@ResponseBody
    	public String testCookie(@CookieValue(value = "testCookie", defaultValue = "defaultCookieValue") String cookieValue, HttpServletResponse httpServletResponse) {
    	/** 输出cookie内容 **/
    	String result = "";
    	/** 创建Cookie **/
    	Cookie cookie = new Cookie("testCookie", "CookieValue");
    	httpServletResponse.addCookie(cookie);
    	result += "Key:testCookie" + "Value:" + cookieValue + "n";
    	return result;
    	}
    }

需要`@ResponseBody`把`return`的内容作为请求返回体，不然会跳转成`return`内容`.jsp`之类的。

第一次访问截图：

![cookie_init]({{site.baseurl}}/pics/cookie_init.png)

第二次访问截图：

![cookie_after]({{site.baseurl}}/pics/cookie_after.png)

## Session

### 什么是Session ？

本文所讲的为HTTP Session，在Java中该Session对象用`javax.servlet.http.HttpSession`表示。Session代表服务器和浏览器的一次会话过程，当如JSP页面中未显示的禁止session时，在浏览器第一次请求该JSP时，服务器会为其自动创建一个session，并分配给其一个sessionID，返回给客户端。当客户端再次请求时，会自动在header中加上：`Cookie:JSESSIONID=分配到的sessionID`，服务器会根据该ID在内存中找到之前创建的session对象（与Cookie不同，Session是保存在服务端）。对于同一个浏览器窗口中的多个标签，同时访问同一应用的不同页面，其session是一样的，但不同的浏览器窗口，其session不一样。

### Session的删除时间
+ Session超时
+ 程序显示的调用`HttpSession.invalidate()`
+ 服务器关闭或停止

### Session示例

	package com.springapp.mvc.controller;

	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.ResponseBody;

	import javax.servlet.http.HttpSession;

	/**
	 * Created by huanghuan on 16/3/1.
	 */

	@Controller
	@RequestMapping(value = "/testSession")
	public class TestSession {

	    @RequestMapping(method = RequestMethod.GET)
	    @ResponseBody
	    public String testSession(HttpSession httpSession) {
	        /** 输出结果 **/
	        String result = "SessionID:";
	        if (httpSession != null) {
	            result += httpSession.getId();
	            /** 参数设置 **/
	            Object value = httpSession.getAttribute("key");
	            if (value == null) {
	                httpSession.setAttribute("key", "value");
	            } else {
	                result += " " + httpSession.getAttribute("key").toString();
	            }
	        }
	        return result;
	    }
	}

第一次访问截图：

![testSession_init]({{site.baseurl}}/pics/testSession_init.png)

第二次访问截图，包括在浏览器开两个窗口的情况：

![testSession_after]({{site.baseurl}}/pics/testSession_after.png)

## Cookie与Session的区别

主要在于Cookie保存在客户端而Session保存在服务端，单个Cookie保存的数据不能超过4k，同时很多浏览器限制一个站点的总Cookie数为20，而服务端的Session会占用服务器内存，影响性能。
