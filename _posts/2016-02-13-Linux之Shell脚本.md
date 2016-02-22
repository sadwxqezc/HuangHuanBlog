---
layout: post
title:  "Shell脚本学习 初阶"
date:   2016-02-21 17:27:00 ＋8000
categories: Shell
---


## 范例代码(Mac下)

以一段Git代码提交脚本为例：
  
	# 添加目录下所有文件
	git add . 
	# message为git commit的值，默认值为当前时间，``间包含字符串将被按照命令执行。
	message=`date +%Y-%m-%d-%H-%M`
	# getopts命令可获取输入的参数，如m:则表示检查'-m'的参数输入，并将参数名存入opt中。
	# 如果未找到参数，则存入?,参数值通过OPTARG变量获得，变量通过$取值。
	
	while getopts m: opt
	do
	case $opt in
	     m)
           message=$OPTARG
           ;;
         ?)
           echo "Usage: args [-m]"
           echo "-m means message"
           echo "exit"
           exit
           ;;
    esac
    done
    # git提交message信息
	git commit -m "$message"
	git push origin gh-pages

Git代码提交脚本执行效果截图：

![Git代码提交]({{site.baseurl}}/pics/git_shell.png)

## 基本知识介绍

一般所指的Shell是指Shell脚本（Shell script），是为Shell编写的脚本程序。而Shell本身是用户访问操作系统内核服务的程序界面，Shell编程与其它语言类似，只需要编写代码的编辑器和能够解释执行的程序即可。Bourne shell是标准的Shell解释器，其所在路径往往是`/bin/sh`。

在Shell脚本中，第一行一般是`#!/bin/sh`，`#!`是用于约定的标记，告诉系统该脚本需要什么解释器执行。当然如果文件以`.sh`作为后缀的话，不写这一行也能正确执行。

---

### 1. 基本语法
<br/>
<h4><b>Shell变量</b></h4>
+ 变量定义与赋值 `testVar="testValue"`
+ 变量的取值只需要在前面加入`$`符号，如`$testVar`，加花括号可以帮助解释器识别边界，如`${testVar}`

> 代码范例：
	
	1 #! /bin/sh
	2 count=0
	3 for testVar in Let us learn Shell
	4 do
	5     echo "Word:${testVar}_Number:$count"
	6     ((count++))
	7 done
	
> `var.sh`执行结果：

![var.sh]({{site.baseurl}}/pics/var.png)

<br/>
<h4><b>字符串</b></h4>
+ 单引号的特点:   
  1.单引号中的所有字符串都原样输出，字符串中的变量无效  
  2.单引号中不能出现单引号，转义亦无效
+ 双引号的特点：  
  1.双引号中可以有变量，并读取变量值
  2.双引号中可以出现转义字符

> 代码范例：

	1  #! /bin/sh
	2  testString='this is a test'
	3  echo '$testString'
    4  echo "$testString"
    5  testString="${testString} string catenate"
    6  echo $testString
    7  testString=""$testString" string catenate"
    8  echo $testString
    9  echo "The length: ${#testString}"
    10 echo "Part of the string: ${testString:1:7}"

> `string.sh`执行结果：

![string.sh]({{site.baseurl}}/pics/shell_string.png)

