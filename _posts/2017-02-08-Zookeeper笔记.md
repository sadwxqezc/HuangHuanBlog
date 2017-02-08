---
layout: post
title:  "Zookeeper笔记"
date:   2017-02-08 19:46 +0800
categories: Middleware
---
* 内容目录
{:toc}

> Zookeeper是Apache Hadoop的一个子项目，本质是一个分布式小文件系统，主要解决分布式系统应用中遇到的数据管理问题（一致性问题）：统一命名服务，状态同步服务，集群管理，分布式应用配置项的管理。

## 数据结构
![Zookeeper]({{site.baseurl}}/pics/zk.png)

### Zookeeper数据结构的特点

1. 每个**子目录项**（比如图中的**NameService**）都被称为**znode**。
2. **znode**可以有**子节点目录**，并且每个**znode**都可以保存数据，但注意**EPHEMERAL**类型的目录节点不能有子节点目录。
3. **znode**是有**版本的**，每个**znode**中存储的数据可以有多个版本，也就是同一访问路径可以存储多份数据。
4. 对于临时的**znode**，一旦创建这个**znode**的客户端与服务器失去联系，这个**znode**也将自动删除，Zookeeper的客户端和服务器通信采用长链接方式，每个客户端和服务器通过心跳来保持连接。
5. **znode**可以被监控，包括这个节点中存储的数据的修改，子节点目录的变化等，一旦变化可以通知监听的客户端，这个是Zookeeper的重要特性。

## 节点

Zookeeper有四种类型的节点:

1. PERSISTENT
2. PERSISTENT_SEQUENTIAL
3. EPHEMERAL
4. EPHEMERAL_SEQUENTIAL

节点在创建后其类型不能被修改。

### Zookeeper简单封装

{% highlight java %}
/**
 * Zookeeper测试类
 * Created by huanghuan on 2017/2/8.
 */
@Log
public class ZookeepeTest {
    private ZooKeeper zooKeeper;

    public ZooKeeper connect(String host) throws Exception {
        zooKeeper = new ZooKeeper(host, 2181, watchedEvent -> {
            log.info("# connect " + watchedEvent.toString());
        });
        return zooKeeper;
    }

    public void close() throws InterruptedException {
        zooKeeper.close();
    }

    public String createNode(String path, byte[] data, CreateMode createMode) 
        throws Exception {
        zooKeeper.create(path, data, ZooDefs.Ids.OPEN_ACL_UNSAFE, createMode);
    }

    public void deleteNode(String path) throws Exception {
        zooKeeper.delete(path, zooKeeper.exists(path, true).getVersion());
    }

    public Stat watch(String path) throws KeeperException, InterruptedException {
        Stat stat = new Stat();
        zooKeeper.getData(path, watchedEvent -> {
            log.info("# event " + watchedEvent.toString());
        }, stat);
        return stat;
    }
}
{% endhighlight %}

### 节点的创建

{% highlight java %}
    public static void main(String args[]) throws Exception {
        ZookeeperTest zookeeperTest=new ZookeeperTest();
        zookeeperTest.connect("127.0.0.1");
        log.info(zookeeperTest.createNode("/test", "test".getBytes(),
            CreateMode.PERSISTENT));
                for (int i = 0; i < 5; i++) {
            log.info(zookeeperTest.createNode("/test/child", null, 
                CreateMode.PERSISTENT_SEQUENTIAL));
        }
    }
{% endhighlight %}

结果为：

{% highlight java %}
信息: /test
信息: /test/child0000000000
信息: /test/child0000000001
信息: /test/child0000000002
信息: /test/child0000000003
信息: /test/child0000000004
{% endhighlight %}

临时节点的创建原理类似，但在客户端断开连接后，临时节点的内容将消失。

### 监听节点的变化。

{% highlight java %}
    public static void main(String args[]) throws Exception {
        ZookeeperTest zookeeperTest = new ZookeeperTest();
        zookeeperTest.connect("127.0.0.1");
        zookeeperTest.createNode("/test/watch", "watch".getBytes(), 
            CreateMode.PERSISTENT);
        zookeeperTest.watch("/test/watch");
        zookeeperTest.deleteNode("/test/watch");
    }
{% endhighlight %}

结果为：

{% highlight java %}
信息: # connect WatchedEvent state:SyncConnected type:None path:null
信息: # connect WatchedEvent state:SyncConnected type:NodeDeleted path:/test/watch
信息: # event WatchedEvent state:SyncConnected type:NodeDeleted path:/test/watch
{% endhighlight %}
