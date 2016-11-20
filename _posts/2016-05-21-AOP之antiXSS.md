---
layout: post
title:  "利用AOP进行Dao层antiXSS过滤"
date:   2016-05-21 12:59:00 +0800
categories: Linux
---
* 内容目录
{:toc}

## 开发原因

在后台开发过程中，往往需要对用户的输入进行antiXSS等过滤，以防止被攻击。以Dao层为例，这一层在写入数据库之前，应该对数据进行过滤，此时对应的一般是`save()`，`saveOrUpdate()`和`update()`操作，输入多数情况下是基本类型或者对于数据库实体的`Entity`。如果按照以往的写法，主要需要对`String`类型的数据（包括`Entity`中的`String` Field）进行过滤，这时往往需要为对应的字段调用`antiXSS()`方法，造成大量的`get/set`代码，颇为麻烦，也造成代码冗长。因此，既然`Spring`具有强大的`AOP`功能，不妨尝试用它简化这一过程。

## 开发组件

SpringBoot，Intellij，Lombok(一个用于消除`get/set`,`toString`,`hashcode`这类代码的工具)

## 开发思路

通过 `AOP`中的`doAround`方法截取传入参数，并利用反射筛选出其中的`String` Filed进行antiXSS处理。

## 实现细节

### 注解

首先需要定义一个专门用来对方法进行antiXSS处理的注解：

    package beijing.huanghuan.anotations;
    
    import java.lang.annotation.*;
    
    /**
     * AntiXSS注解
     * <p/>
     * Created by huanghuan on 16/5/21.
     */
    @Documented
    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.METHOD)
    public @interface AntiXSS {
    
    }
   
### 注解的实现

定义一个`AntiXSSAspect`来对应该注解：

    package beijing.huanghuan.anotations.aop;
    
    import org.aspectj.lang.ProceedingJoinPoint;
    import org.aspectj.lang.annotation.Around;
    import org.aspectj.lang.annotation.Aspect;
    import org.aspectj.lang.annotation.Pointcut;
    import org.springframework.stereotype.Service;
    
    import java.lang.reflect.Field;
    
    /**
     * 对String或者Entity中的String进行AntiXSS处理
     * <p/>
     * Created by huanghuan on 16/5/21.
     */
    @Service
    @Aspect
    public class AntiXSSAspect {
    
        /**
         * 定义切面，定位到@AntiXSS注解的地方
         */
        @Pointcut("@annotation(beijing.huanghuan.anotations.AntiXSS)")
        public void antiXSSPointCut() {
    
        }
    
        /**
         * 对String类型或包含String类型的Entity进行antiXSS处理
         *
         * @param point
         */
        @Around("antiXSSPointCut()")
        public Object doAround(ProceedingJoinPoint point) {
            Object result = null;
            Object args[] = point.getArgs();
            try {
                antiXSS(args);
                result = point.proceed(args);
            } catch (Throwable throwable) {
                throwable.printStackTrace();
            }
            return result;
        }
    
        /**
         * antiXSS处理
         *
         * @param args
         */
        private void antiXSS(Object[] args) {
            if (args == null) {
                return;
            }
            for (int i = 0; i < args.length; i++) {
                if (args[i] == null) {
                    continue;
                }
                if (args[i] instanceof String) {
                    args[i] = antiXSS((String) args[i]);
                }
                if (!isPrimitive(args[i])) {
                    args[i] = antiXSSEntity(args[i]);
                }
            }
        }
    
        /**
         * 对Entity进行antiXSS
         *
         * @param object
         * @return 处理后的结果
         */
        private Object antiXSSEntity(Object object) {
            Field[] fields = object.getClass().getDeclaredFields();
            for (Field field : fields) {
                field.setAccessible(true);
                try {
                    Object arg = field.get(object);
                    if (arg instanceof String) {
                        arg = antiXSS((String) arg);
                        field.set(object, arg);
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
            return object;
        }
    
        /**
         * 判断是否是基本类型
         *
         * @param arg
         * @return
         */
        private boolean isPrimitive(Object arg) {
            try {
                /************ 基本类型中包含Class<T> TYPE字段 **********/
                Field field = arg.getClass().getDeclaredField("TYPE");
                field.setAccessible(true);
                Class fieldClass = (Class) field.get(arg);
                if (fieldClass.isPrimitive()) {
                    return true;
                }
            } catch (Exception e) {
                return false;
            }
            return true;
        }
    
        /**
         * antiXSS实现
         *
         * @param target
         * @return
         */
        private String antiXSS(String target) {
            /********* 自己的antiXSS或其它实现 **********/
            return target + "(antiXSS success)";
        }
    }

在这部分代码中`@PointCut`定义了其作用的位置是`AntiXSS`注解的方法，而`@Around`来进行参数处理，通过`ProceedingJoinPoint`的`getArgs`即可获得所有的入参数，进行处理后通过`proceed(args[])`传回。

在处理的过程中，由于我们只需要对`String`类型的域进行处理，对于本来就是基本类型的域，可以直接通过`instanceof String`进行判定，而对于`Entity`这种`POJO`类型的对象，我们需要一些其它的方法，来首现判定出它不是基本类型，然后再分析出其中的`String` Filed i.e. 反射:

1. 首先通过`getClass().getDeclaredFields()`获取对象中的所有Field，并将它们的访问权限设置为`true`
2. 对每一个Field，获取其中的名为`TYPE`的`Field`，这其实是一个取巧的方法，之所以这么做是因为基本类型的`wrapper`里都一个`Class<T> TYPE`字段，通过该字段能够判定它是不是基本类型，而普通的与数据库对应的`Entity`自然是不会有这中种字段的。
3. 然后将该Field转化为Class，并通过Class的`isPrimitive`方法来判定是否为基本类型，期间出现任何异常则表示该对象不是基本类型
4. 当判定出该对象是`Entity`，则获取其中的所有Field，按照之前的思路进行处理。注意，上面的代码只支持包含基本类型的Entity，对于像`hibernate`的`many to one`或者`one to many`的判定，还需要读者自己去实现。

这里补充`Double`源码中的`Type`字段定义：

    /**
     * The {@code Class} instance representing the primitive type
     * {@code double}.
     *
     * @since JDK1.1
     */
    public static final Class<Double> TYPE=(Class<Double>)Class.getPrimitiveClass("double");
    
### 测试

测试用的`TestAntiXSSDaoImpl`类：
	
    /**
     * Created by huanghuan on 16/5/21.
     */
    @Repository
    public class TestAntiXSSDaoImpl {
    
        @AntiXSS
        public void testSave(long id, String text) {
            System.out.println("id: " + id + " text: " + text);
        }
    
        @AntiXSS
        public void testSaveObject(Object object) {
            System.out.println(object.toString());
        }
    }

测试类`AntiXSSAspectTest`类,`@Data`是`Lombok`注解，自动生成`toString`:

    /**
     * Created by huanghuan on 16/5/21.
     */
    @RunWith(SpringJUnit4ClassRunner.class)
    @SpringApplicationConfiguration(Starter.class)
    public class AntiXSSAspectTest {
    
        @Autowired
        private TestAntiXSSDaoImpl testAntiXSSDao;
    
        @Test
        public void testAntiXSS() {
            testAntiXSSDao.testSave(1, "test save string");
            testAntiXSSDao.testSaveObject(new TestEntity());
        }
    
        public
        @Data
        class TestEntity {
            long id = 2;
            String text = "test save Object";
        }
    }

测试结果：

	id:1 text: test save string(antiXSS success)
	AntiXSSAspectTest.TestEntity(id=2, text=test save Object(antiXSS success))

成功的进行的处理，至于`antiXSS`的具体实现请自己补充。
