---
layout: post
title:  "Cookie and Session"
date:   2016-02-26 17:06:00 ＋8000
categories: Backend
---

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

