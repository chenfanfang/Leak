# Leak
swift 内存泄漏动态检测工具

2020年在项目中写的一个swift版本对于控件视图内存泄露的检测工具，今天抽空整理了一下。

使用步骤
- 1、下载源码
- 2、将源码中的MemoryLeakMonitor文件夹导入到swift项目中
- 3、启动内存泄漏检测【只会在Debug模式下生效]
```
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 启动内存泄露检测，只会在Debug模式下生效
        EDLeaksMonitor.setup()
        return true
    }
}
```

![内存泄露提示.png](https://github.com/chenfanfang/Leak/blob/main/%E6%88%AA%E5%9B%BE/leak.png)
