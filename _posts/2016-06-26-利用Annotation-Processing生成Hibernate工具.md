---
layout: post
title:  "利用Annotation Processing生成Hibernate工具"
date:   2016-06-26 10:49:00 +0800
categories: Framework
---
* 内容目录
{:toc}

## 开发原因

在使用Hibernate时候，经常会写这样的代码：
    
    @Override
    public List getTemplateList(long id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(Template.class);
        criteria.add(Restrictions.eq("id", id));
        criteria.addOrder(Order.desc("create_time"));
        return findByDetachedCriteria(criteria);
    }

在设置条件的时候，不得不使用hibernate 实体类中对应的字段，这个时侯要么是跳到对应类或xml文件里复制粘贴，要么是自己手打，还容易出错。这个时侯就会想，如果能为实体类生成一些方法，以获取对应的实体类字段名，那就方便多了，达到如下这种效果：

    @Override
    public List getTemplateList(long id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(Template.class);
        criteria.add(Restrictions.eq(TemplateTool.getId(), id));
        criteria.addOrder(Order.desc(TemplateTool.getCreate_Time());
        return findByDetachedCriteria(criteria);
    }

这样是不是方便了很多，在IDE的帮助下，能有效提高写代码的效率。


## 开发组件

Intellij

## 开发思路

根据开发原因，很容联想到一个开源工具`LomBok`，它能够自动生成`Getter/Setter`，`toString`，`hashCode`等方法，在intellij上配合lombok的插件，能够实时调出这些方法。于是我尝试在Lombok上去拓展，但发现Lombok并不能直接拓展，需要修改其源码并重新编译，这就没必要了。然后了解了一下Lombok的原理，是基于`Annotation Processing`来实现的，简单来说就是为`Annotation`注册一个`Processor`，在编译时动态生成代码，这算是实现工具的神器了。

于是我学习了一下这片文章 [Annotation Processing](http://hannesdorfmann.com/annotation-processing/annotationprocessing101)，照着上面所诉的模式写了一个Hibernate工具。

## 实现细节

源码参见：[Huang Huan Github Annotation Processing](https://github.com/sadwxqezc/AP)

### 注解

首先需要定义一个作用于`source`阶段的注解：

	@Documented
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.SOURCE)
	public @interface ORMTool {
	}

### 注解Processor的实现

定义一个`ORMToolProcessor`来对应该注解：

    @AutoService(Processor.class)
    @SupportedAnnotationTypes("bj.huanghuan.annotation.ORMTool")
    public class ORMToolProcessor extends AbstractProcessor {
    
        /**
         * 打印信息
         **/
        private Messager messager;
    
        /**
         * 创建文件工具
         **/
        private Filer filer;
    
        /**
         * element工具
         **/
        private Elements elementUtils;
    
    
        private static final String SUFFIX = "Tool";
    
        @Override
        public synchronized void init(ProcessingEnvironment processingEnv) {
            super.init(processingEnv);
            messager = processingEnv.getMessager();
            filer = processingEnv.getFiler();
            elementUtils = processingEnv.getElementUtils();
        }
    
        @Override
        public boolean process(Set<? extends TypeElement> annotations, 
        RoundEnvironment roundEnv) {
            for (Element element : roundEnv.getElementsAnnotatedWith(ORMTool.class)) {
                if (element.getKind() != ElementKind.CLASS) {
                    printError(element, 
                    "Only Classes can be annotated with @%s",
                     ORMTool.class.getSimpleName());
                    return true;
                }
                TypeElement typeElement = (TypeElement) element;
                String className = typeElement.getSimpleName() + SUFFIX;
                try {
                    JavaFileObject classFile = filer.createSourceFile(className);
                    Writer writer = classFile.openWriter();
                    JavaWriter javaWriter = new JavaWriter(writer);
                    /*************** package Name *************/
                    PackageElement packageElement = elementUtils.getPackageOf(typeElement);
                    if (!packageElement.isUnnamed()) {
                        javaWriter.emitPackage(packageElement.getQualifiedName().toString());
                        javaWriter.emitEmptyLine();
                    } else {
                        javaWriter.emitPackage("");
                    }
    
                    javaWriter.beginType(className, "class", EnumSet.of(Modifier.PUBLIC));
                    javaWriter.emitEmptyLine();
    
                    /************ generate getter for fields ************/
                    List<VariableElement> insideElements =
                     ElementFilter.fieldsIn(typeElement.getEnclosedElements());
                    for (VariableElement variableElement : insideElements) {
                        javaWriter.beginMethod("String",
                         variableElement.getSimpleName().toString(),
                         EnumSet.of(Modifier.PUBLIC, Modifier.STATIC),
                         null, null);
                        javaWriter.emitStatement("return \"" +
                         variableElement.getSimpleName().toString() + "\"");
                        javaWriter.endMethod();
                        javaWriter.emitEmptyLine();
                    }
    
                    javaWriter.endType();
                    javaWriter.close();
                } catch (IOException e) {
                    messager.printMessage(Diagnostic.Kind.ERROR, 
                    "Gennerate Source Code Failed!");
                }
            }
            return false;
        }
    
        @Override
        public SourceVersion getSupportedSourceVersion() {
            return SourceVersion.latestSupported();
        }
    
        /**
         * 错误日志打印
         *
         * @param element
         * @param msg
         * @param args
         */
        private void printError(Element element, String msg, Object... args) {
            messager.printMessage(Diagnostic.Kind.ERROR, String.format(msg, args), element);
        }
    }

这部门代码里有一些需要解释的地方：

+ `@AutoService`是Google提供的注册一个工具，其实作用应该是省去后面我将要讲的配置文件，不过影响不大。
+ `process(Set<? extends TypeElement> annotations, ...)`是处理的入口，首先判断被`ORMTool`注解的元素是不是`Class`类型，然后利用`JavaWriter`这个代码生成工具来构建新的Java文件，为注解的类生成一个对应的tool类。该类包含了被注解类中所有`Field`的参数名`Getter`。
+ 这里面的`TypeElement`，`VariableElement`分别指的类类型和域类型。

### 配置文件

这里需要一个配置文件，文件全路径是`/META-INF/services/javax.annotation.processing.Processor`，配置文件中写入`ORMToolProcessor`中的路径，如`bj.huanghuan.processor.ORMToolProcessor`。实际上又了上面的`@AutoService`其实应该不需要手写这个文件了，不过我没试过，读者有兴趣可以试试。

截图：

![文件结构]({{site.baseurl}}/pics/ap-structure)
   
### 生成Maven包

最后需要生成一个Maven包，加入到其它项目中供调用。

### 测试

测试用的`Test`类：
	
	@ORMTool
	public class Test {

    	private int id;

    	private String name;

    	private Boolean isNew;
	}

生成的`TestTool`类:

	public class TestTool {
    	public TestTool() {
    	}

    	public static String id() {
        	return "id";
    	}

    	public static String name() {
        	return "name";
    	}

    	public static String isNew() {
        	return "isNew";
    	}
	}
	
### 总结

这种方式的工具需要在使用前编译一下代码，也算是点小遗憾了，要实现`Lombok`那样无需手动编译的效果，需要实现对应的Intellij插件，这份工作就看以后有没有精力做了。
