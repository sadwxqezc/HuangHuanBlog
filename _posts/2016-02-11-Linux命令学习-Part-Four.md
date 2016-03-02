---
layout: post
title:  "Linux命令学习的日常 Part Four"
date:   2016-02-11 19:55:00 ＋8000
categories: Linux
---
* 内容目录
{:toc}


## 1\. sort命令
 
sort命令用于对文本进行排序，并将结果输出。其以文本的每一行为单位，从首字符向后，依次按照ascii码值进行比较，最后升序排列。（默认是忽略每行前面空格的）
<h4><b>基本格式 sort [option] [filename]</b></h4>
+ <code>-u</code> 忽略重复行
+ <code>-n</code> 按照数字大小排序
+ <code>-r</code> 逆序
+ <code>-k start,end</code>start为比较的起始位置，end为结束位置

范例一：<code>sort sort.txt</code> 排序
	
![sort]({{site.baseurl}}/pics/sort.png)  

范例二：  
1. <code>sort -nk 2 -t - sort.txt</code> 以`-`进行分割，对分割后的第二个域进行排序；  
2. <code>sort -nrk 2 -t - sort.txt</code> 逆序排序

![sort_t]({{site.baseurl}}/pics/sort_t.png)

范例三：<code>sort -t - -k 1.7 -nk 3,3 sort_k.txt</code>  
`-k start,end`中end可以省略，上面的`1.7`表示分割后第一个域的第7个字符，由于没有`end`，则表示对第一个域中第7字符及其之后的字符排序。而`3,3`则表示在前面排序的基础上，再对第三个域进行排序。

![sort_k]({{site.baseurl}}/pics/sort_k.png)

## 2\. netstat命令

netstat用于输出linux系统的网络情况信息，以前面试的时候还被问过：“如何查看占用某个端口的程序的pid?"，这个问题实际用<code>netstat -anp</code>输出，然后再grep一下即可。
<h4><b>基本格式 netstat [option]</b></h4>
+ <code>-a</code> 显示所有socket连接
+ <code>-l</code> 显示监控中(listening)的socket连接
+ <code>-n</code> 直接使用ip地址，而不使用域名服务器
+ <code>-p</code> 显示正在使用socket的程序的pid和名称
+ <code>-r</code> 打印路由表
+ <code>-t</code> 显示TCP传输协议的连线状况
+ <code>-u</code> 显示UDP传输协议的连线状况
+ <code>-s</code> 显示网络工作信息统计表

范例一：<code>netstat -anp</code>
显示程序的pid和名称

![netstat 端口]({{site.baseurl}}/pics/netstat_anp.png) 

范例二：<code>netstat -r</code>
输出本机路由表

![netstat 路由表]({{site.baseurl}}/pics/netstat_r.png)

范例三：<code>netstat -lts</code>
输出监听状态中的tcp协议统计信息

![netstat tcp统计]({{site.baseurl}}/pics/netstat_lts.png)

## 3\. more命令

more命令用于显示文件的内容，与cat和tail等命令不同的是，more命令是按页显示文件内容，同时具有搜寻字符串的功能。（由于more具有向前翻页功能，因此该命令会加载整个文件）

<h4><b>基本格式 more [option] [filename]</b></h4>
+ <code>+n</code> 从第n行开始显示
+ <code>-n</code> 定义屏幕大小为n行
+ <code>+/pattern</code> 再显示前按pattern匹配子串并显示
+ <code>-s</code> 把连续的多个空行显示为一行

	常用操作命令：
	<ul>
	<li>Enter 向下n行，默认为1行</li>
	<li>Ctrl+F 跳过一屏</li>
	<li>Ctrl+B 返回上一屏</li>
	<li>空格键 向下滚动一屏</li>
	<li>= 输出当前行的行号</li>
	<li>在more模式中回车，输入<code>/pattern</code>可以持续向下搜索</li></ul>
	
范例一：<code>more +/Deploy catalina.out</code>  
在catalina.out文件中查找“Deploy字符第一次出现的位置”，并从该处的前两行开始显示输出

![more 搜索]({{site.baseurl}}/pics/more_+.png) 

范例二：<code>more +10 -10 catalina.out</code>  
从第10行开始，每页10行

![more 参数]({{site.baseurl}}/pics/more_+_-.png)

## 4\. less命令

less命令与more命令对应，既可以前后翻看文件，同时还有前后搜索功能，除此之外，less在查看前不会加载整个文件。

<h4><b>基本格式 less [option] [filename]</b></h4>
+ <code>－N</code> 显示每行的行号
+ <code>-i</code> 忽略搜索时的大小写
+ <code>-s</code> 将连续空行显示为一行
+ <code>-m</code> 显示百分比

	常用操作命令：
	<ul>
	<li>/字符串 向下搜索“字符串”功能</li>
	<li>?字符串 向上搜索“字符串”功能</li>
	<li>n 重复前一个搜索</li>
	<li>空格键 滚动一页</li>
	<li>d 滚动半页</li>
	<li>b 回溯一页</li>
	<li>y 回溯一行</li>
	<li>q 退出less命令</li>
	</ul>
	
范例一：<code>less -Nm catalina.out</code>  
显示行号和百分比

![less 行号百分比]({{site.baseurl}}/pics/less_Nm.png) 

范例二：<code>/detail</code>或者<code>?detail</code>
向前向后搜索"detail"

![less 搜索]({{site.baseurl}}/pics/less_search.png)
