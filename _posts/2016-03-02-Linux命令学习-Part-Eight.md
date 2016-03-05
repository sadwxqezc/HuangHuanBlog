---
layout: post
title:  "Linux命令之sed与awk"
date:   2016-03-04 18:08:00 ＋8000
categories: Linux
---
* 内容目录
{:toc}

> `sed`与`awk`是可以单独出书的两个Linux命令，它们的功能非常强大，本章节将分别介绍着两个命令。其中`sed`使用的是`gng-sed 4.2.2`版本，对应下文中出现的`gsed`，而不是Mac自带的`sed`。

## 1. sed命令(Mac)

sed是Linux中的一个文件编辑工具，按行处理文件内容，可以实现插入，删除，替换等功能。更重要的是sed命令可以用script来处理文本文件，能够应对复杂的编辑需求。

---

### sed命令语法

<h4><b>基本格式 sed [option] [filename]</b></h4>
<h5><b>选项:</b></h5>  

+ `-e <script>` 按script编辑文本并输出到控制台，但不修改原文件内容
+ `-f filename` 调用sed脚本文件
+ `-i` 直接修改读取的文件内容，而不输出到终端
+ `-n` 使用安静模式，只有经过sed处理的行才会被显示出来
+ `-r` 使用延伸型的正则表达式语法，预设的是基础的正则语法

<h5><b>动作命令[n1[,n2]] function</b></h5>
n1,n2表示起始行和结束行，不一定存在，而function表示动作行为
<h5><b>常用function命令:</b></h5>
+ `a` 新增一行内容（在指定行的下一行）
+ `c` 取代内容，可取代n1,n2之间的行
+ `d` 删除行
+ `i` 插入一行内容（在指定行的上一行）
+ `p` 列印，将某个选择的资料印出，常与`sed -n`连用
+ `s` 取代，搭配正则表达式，替换文本中的内容

---

### sed命令示例
1\. 行的删除：`ls -lha | nl | gsed '1,3d'`删除输出中的第1到第3行，此时参数`-e`可不加。

![sed delete]({{site.baseurl}}/pics/sed_d.png)

2\. 行的插入：

+ 在指定行前插入 `gsed '4a 插入的第一行\n插入的第二行' testSed`
+ 在指定行后插入  `gsed '1i 插入的第一行\n插入的第二行' testSed`  
若要让操作更新到原文件中，需加`-i`，该操作较为危险。建议使用`gsed -i.bak '1i test' testSed`这样的执行方式，通过这种方式可额外生成`testSed.bak`文件，该文件保存了原始内容，这样更安全。

![sed insert]({{site.baseurl}}/pics/sed_insert.png)

3\. 行的选择性显示：
有时会显示文件中某个区间内容的需求，这时通过`gsed -n`可以做到。  
`gsed -n '2,$p' testSed`

![sed print]({{site.baseurl}}/pics/sed_n.png)

4\. 搜索含有关键字的行：`gsed -n '/^第.行/p' testSed`

![sed search]({{site.baseurl}}/pics/sed_search.png)