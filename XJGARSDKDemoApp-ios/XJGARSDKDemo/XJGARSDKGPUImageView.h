

#ifndef _GPU_IMG_VIEW_
#define _GPU_IMG_VIEW_


#import <UIKit/UIKit.h>
#import "XJGARSDKGPUImageTarget.h"


//GPU图像视图的基类，继承自UI视图类，XJGARSDKGPUImageTarget
@interface XJGARSDKGPUImageView : UIView <XJGARSDKGPUImageTarget>


@property(readwrite, nonatomic) GPUImagViewFillMode fillMode;
@property(readwrite, nonatomic) int rotatedFrameBufWidth;
@property(readwrite, nonatomic) int rotatedFrameBufHeight;



@end


#endif
