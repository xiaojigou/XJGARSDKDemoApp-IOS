
#import <UIKit/UIKit.h>

//定义一个应用程序委托类对象（objc中类对象定义使用@interface 关键字），继承自UIResponder，并实现UIApplicationDelegate借口
@interface AppDelegate : UIResponder <UIApplicationDelegate>
//定义属性，指向窗口对象，
    
    /*3.strong与weak
    strong：强引用，也是我们通常说的引用，其存亡直接决定了所指向对象的存亡。如果不存在指向一个对象的引用，并且此对象不再显示在列表中，则此对象会被从内存中释放。
    weak：弱引用，不决定对象的存亡。即使一个对象被持有无数个弱引用，只要没有强引用指向它，那么还是会被清除。
    strong与retain功能相似；weak与assign相似，只是当对象消失后weak会自动把指针变为nil;
     
     1.atomic与nonatomic
     atomic：默认是有该属性的，这个属性是为了保证程序在多线程情况，编译器会自动生成一些互斥加锁代码，避免该变量的读写不同步问题。
     nonatomic：如果该对象无需考虑多线程的情况，请加入这个属性，这样会让编译器少生成一些互斥加锁代码，可以提高效率。
     
     */
    @property (strong, nonatomic) UIWindow *window;


@end

