
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//主函数
int main(int argc, char * argv[]) {
    
    /*
    引言
    
    OC对象的生命周期取决于引用计数，我们有两种方式可以释放对象：一种是直接调用release释放；另一种是调用autorelease将对象加入自动释放池中。自动释放池用于存放那些需要在稍后某个时刻释放的对象。
    
    本文将介绍自动释放池的原理和使用场景，并结合一道据说是优酷iOS的笔试题来举例说明自动释放池的妙用。
    
    更多关于iOS内存管理的文章已经汇总至：深入总结iOS内存管理。
    
    自动释放池的创建
    
    如果没有自动释放池而给对象发送autorelease消息，将会收到控制台报错。但一般我们无需担心自动释放池的创建问题。
    
    我们的Mac以及iOS系统会自动创建一些线程，例如主线程和GCD中的线程，都默认拥有自动释放池。每次执行 “事件循环”(event loop)时，就会将其清空，这一点非常重要，请务必牢记！ 关于事件循环，其涉及到runloop，可以看这篇文章：深入理解RunLoop。
    
    因此我们一般不需要手动创建自动释放池，通常只有一个地方需要它，那就是在main()函数里，如下：
    
    int main(int argc, char * argv[]) {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    这个main()函数里面的池并非必需。因为块的末尾是应用程序的终止处，即便没有这个自动释放池，也会由操作系统来释放。但是这些由UIApplicationMain函数所自动释放的对象就没有池可以容纳了，系统会发出警告。因此，这里的池可以理解成最外围捕捉全部自动释放对象所用的池。
    
    作者：周鶏
    链接：http://www.jianshu.com/p/affc844da255
    來源：简书
    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。*/
    
    @try{
        
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
