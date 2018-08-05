---
layout: post
title: "Spring条件初始化资源"
date: 2018-08-05 19:35:00 +0800
categories: Framework
---

* 内容目录
{:toc}

### 概述

在项目中会有依据一定条件来初始化Bean的需求，特别是在分Module的代码中，底层Module实现了对各种资源的封装，比如DB，Thrift，MQ，Http，调度任务等，但是上层的需求多种多样，比如有的Module只需要使用Thrift，但由于其依赖的底层Module封装了所有的资源，导致在上层Module运行时，除了Thrift，实际还初始化了DB，MQ，Http等资源，这不仅是种不必要的浪费，有时还可能带来问题。因此，本文将主要探讨如何能依据一定的条件，按需初始化Bean，以避免不必要的浪费。

### 说明

范例项目通过`Main`函数启动项目，项目结构参考，其中`Db.java，Http.java，Kafka.java`代表三种不同的资源，它们在`init`时会打印日志：

```
.
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── example
    │   │           └── foo
    │   │               ├── Boot.java
    │   │               └── beans
    │   │                   ├── Db.java
    │   │                   ├── Http.java
    │   │                   └── Kafka.java
    │   └── resources
    │       ├── applicationContext.xml

```

`applicationContext.xml`文件内容为：

```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Spring基础配置 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- 类增强代理（而不是基于java的接口代理） -->
    <aop:aspectj-autoproxy proxy-target-class="true"/>

</beans>
```

启动类`Boot.java`内容为：

```
package com.example.foo;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 启动类
 *
 * @author huanhuang
 */
public class Boot {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext context =
                new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        context.start();
    }
}
```

资源代码以`Db.java`为例：

```
public class Db {

    public void init() {
        System.out.println("Db has bean initialized");
    }
}
```



### 方法一：Spring Profile

Profile的概念其实很常见，比如Maven也有，大家一般用Maven的Profile来管理不同环境的配置文件。但我自己之前有一个误区，以为Spring的Profile只能选者一种特定的Profile，但实际上它是支持同时指定多种Profile的，这就带来了很大的灵活性，下面介绍如何基于Spring Profile来条件初始化资源，先列下项目结构，主要多了一个配置文件`enableProfiles.properties`：

```
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── example
    │   │           └── foo
    │   │               ├── Boot.java
    │   │               └── beans
    │   │                   ├── Db.java
    │   │                   ├── Http.java
    │   │                   └── Kafka.java
    │   └── resources
    │       ├── applicationContext.xml
    │       └── enableProfiles.properties
```



#### Profile配置

在`applicationContext.xml`文件中为不同的资源指定了Profile:

```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Spring基础配置 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- 类增强代理（而不是基于java的接口代理） -->
    <aop:aspectj-autoproxy proxy-target-class="true"/>

    <beans profile="enableDb">
        <bean class="com.example.foo.beans.Db" init-method="init"/>
    </beans>

    <beans profile="enableHttp">
        <bean class="com.example.foo.beans.Http" init-method="init"/>
    </beans>

    <beans profile="enableKafka">
        <bean class="com.example.foo.beans.Kafka" init-method="init"/>
    </beans>

</beans>
```

#### 启用特定的Profile

这里我们把启用的profile放在了一个`enableProfiles.properties`文件里，内容为:

```
enableProfiles=enableDb,enableKafka
```

表明我们只启用`Db`和`Kafka`资源，这里要注意的一点是，从结果来看，需要在Spring初始化之前，设置选用好Profile，`Boot.java`代码如下：

```
/**
 * 启动类
 *
 * @author huanhuang
 */
public class Boot {
    public static void main(String[] args) {
        try {
            Properties properties = PropertiesLoaderUtils
            .loadAllProperties("enableProfiles.properties");
            String enableProfiles = properties.getProperty("enableProfiles");
            System.out.println(enableProfiles);
            System.setProperty(
            AbstractEnvironment.ACTIVE_PROFILES_PROPERTY_NAME, enableProfiles);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ClassPathXmlApplicationContext context =
                new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        context.start();
    }
}
```

这段代码里我们首先手动读取了`enableProfiles.properties`文件，然后最关键的代码在于下面一行：

```
System.setProperty(AbstractEnvironment.ACTIVE_PROFILES_PROPERTY_NAME, enableProfiles);
```

这个设定了一个环境变量，实际对应是的是`spring.profiles.active`，最后运行结果如下：

```
Db has bean initialized
Kafka has bean initialized
```

符合预期，只有`Db`和`Kafka`被启用了，这种方式简单明了。

### 方法二：Spring Conditional

Spring的`@Conditional`注解也就是依据一定的条件去初始化Bean，实际上Spring 4之后，`@Profile`注解就是通过`@Conditional`来实现的，基于`@Conditional`注解，实际上想怎么初始化资源都可以，Profile实际知识它的一个Feature。这个工具非常强大，唯一的问题是貌似不支持XML。下面是使用这种方式的代码结构：

```
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── example
│   │   │           └── foo
│   │   │               ├── Boot.java
│   │   │               ├── beans
│   │   │               │   ├── Db.java
│   │   │               │   ├── Http.java
│   │   │               │   └── Kafka.java
│   │   │               └── config
│   │   │                   ├── Config.java
│   │   │                   ├── DbCondition.java
│   │   │                   ├── HttpCondition.java
│   │   │                   └── KafkaCondition.java
│   │   └── resources
│   │       └── applicationContext.xml
```

因为`@Conditional`是注解，所以Bean的初始化也就通过`@Configuration`来实现了，需要配置`applicationContext.xml`如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Spring基础配置 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd 
        http://www.springframework.org/schema/context 
        http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 类增强代理（而不是基于java的接口代理） -->
    <aop:aspectj-autoproxy proxy-target-class="true"/>

    <context:component-scan base-package="com.example.foo"/>
</beans>
```

Bean的初始化在`Config.java`中：

```
@Configuration
public class Config {

    @Bean(initMethod = "init")
    @Conditional(DbCondition.class)
    public Db db() {
        return new Db();
    }

    @Bean(initMethod = "init")
    @Conditional(HttpCondition.class)
    public Http http() {
        return new Http();
    }

    @Bean(initMethod = "init")
    @Conditional(KafkaCondition.class)
    public Kafka kafka() {
        return new Kafka();
    }
}
```

可以看到，我们可以给不同的资源使用不同的Condition，非常强大，当然自己得多写点代码，以`DbCondition.class`为例：

```
/**
 * 启用Db的条件
 *
 * @author huanhuang
 */
public class DbCondition implements Condition {

    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return false;
    }
}
```

需要继承`Condition`接口，然后这个方法里怎么匹配，自己想怎么写都可以，这里我只有`HttpCondition.class`的方法返回`true`，其它都是`false`，运行结果如下：

```
Http has bean initialized
```

### 总结

Profile实际是Conditional的一个Feature，如果没有更复杂的需求，Profile就够用了，对于业务代码来讲Profile更容易理解，Conditional更适合于框架的场景。