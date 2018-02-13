#import <UIKit/UIKit.h>
#include "XJGARSDKFramebuffer.h"


//设置目标视图的填充模式
enum GPUImagViewFillMode {
    Stretch = 0,                    // Stretch to fill the view, and may distort the image
    PreserveAspectRatio = 1,        // preserve the aspect ratio of the image
    PreserveAspectRatioAndFill = 2  // preserve the aspect ratio, and zoom in to fill the view
};

//图像目标接口对象，继承自NSObject，提供opengl更新及帧缓存、纹理、旋转模式的相关设置的接口
@protocol XJGARSDKGPUImageTarget <NSObject>
@required
- (void)updateTargetView:(float)frameTime;
- (void)renderAndUpdateTargetview:(float)frameTime;
- (void)setInputFramebuffer:(GPUImgLuo::XJGARSDKFramebuffer*)inputFramebuffer withRotation:(GPUImgLuo::RotationMode)rotationMode atIndex:(NSInteger)texIdx;

@end


