
#import <UIKit/UIKit.h>
#import "XJGARSDKResInterface.h"

//定义滤镜，贴纸，美颜整形等相关参数回调委托接口，继承至NSObject
@protocol XJGARSDKChangeResDelegate <NSObject>

//@optional 表示可选择实现
//@required 表示必须实现
@optional
- (void)onFilterSelected:       (XJGARSDKFilterType)filterIdx;
- (void)onStickerPaperSelected: (XJGARSDKStickerType)stickerIdx;
//- (void)onFilterSelected:(XJGARSDKFilterType)filterIdx;

@end

//定义继承至UITableViewController的视图控制器类
@interface XJGARSDKResSelViewController : UITableViewController

//看到instancetype和id的区别如下:
//区别1
//在ARC(Auto Reference Count)环境下:
//instancetype用来在编译期确定实例的类型,而使用id的话,编译器不检查类型, 运行时检查类型.
//在MRC(Manual Reference Count)环境下:
//instancetype和id一样,不做具体类型检查
//区别2:
//id可以作为方法的参数,但instancetype不可以
//instancetype只适用于初始化方法和便利构造器的返回值类型
//作者：三木成森
//链接：http://www.jianshu.com/p/bd913b3a8e93
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
- (instancetype)initWithSetXJGARSDKChangeResDelegate:(id <XJGARSDKChangeResDelegate>)delegate actionType:(int)actionType;
@end
