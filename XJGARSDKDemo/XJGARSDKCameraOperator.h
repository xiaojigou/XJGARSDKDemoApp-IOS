

#ifndef _XJGARSDK_CAMERA_OPERATOR_
#define _XJGARSDK_CAMERA_OPERATOR_

#include "XJGARSDKGPUImageView.h"


#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>


//IOS基础：深入理解Objective-c中@class的含义
//objective-c中，当一个类使用到另一个类时，并且在类的头文件中需要创建被引用的指针时，
//如下面代码：
//A.h文件
//
//C代码
//#import "B.h"
//@interface A : NSObject {
//    
//    B *b;
//}
//@end
//
//为了简单起见：A类是引用类，B类是被引用类，这里先不考虑A类的实现文件。
//通常引用一个类有两种办法：
//一种是通过#import方式引入；另一种是通过@class引入；
//这两种的方式的区别在于：
//1、#import方式会包含被引用类的所有信息，包括被引用类的变量和方法；@class方式只是告诉编译器在A.h文件中 B *b 只是类的声明，具体这个类里有什么信息，这里不需要知道，等实现文件中真正要用到时，才会真正去查看B类中信息；
//2、使用@class方式由于只需要只要被引用类（B类）的名称就可以了，而在实现类由于要用到被引用类中的实体变量和方法，所以需要使用#importl来包含被引用类的头文件；
//3、通过上面2点也很容易知道在编译效率上，如果有上百个头文件都#import了同一 个文件，或者这些文件依次被#improt（A->B, B->C,C->D…）,一旦最开始的头文件稍有改动，后面引用到这个文件的所有类都需要重新编译一遍，这样的效率也是可想而知的，而相对来 讲，使用@class方式就不会出现这种问题了；
//4、对于循环依赖关系来说，比方A类引用B类，同时B类也引用A类，B类的代码：
//#import "A.h"
//@interface B : NSObject {
//    
//    A *a;
//}
//@end
//
//当程序运行时，编译会报错,
//当使用@class在两个类相互声明，就不会出现编译报错。
//由上可知，@class是放在interface中的，只是在引用一个类，将这个被引用类作为一个类型，在实现文件中，
//如果需要引用到被引用类的实体变量或者方法时，还需要使用#import方式引入被引用类。
@class VideoDataOutputSampleBufferDelegate;


namespace GPUImgLuo
{
    
    
    //相机输入操作管理类
    class XJGARSDKCameraOperator
    {
        
    public:
        XJGARSDKCameraOperator();
        virtual ~XJGARSDKCameraOperator();
        
        //创建一个相机输入操作对象
        static XJGARSDKCameraOperator* create();

        void setFrameData(int width, int height, const void* pixels, RotationMode outputRotation = RotationMode::NoRotation);
          

        bool init();
        bool init(NSString* sessionPreset, AVCaptureDevicePosition cameraPosition);
        static bool isCameraExist(AVCaptureDevicePosition cameraPosition);
        void start();
        void stop();
        void pause();
        void resume();
        bool isRunning();
        bool flip();
        
        //Constants to specify the position of a capture device.
        AVCaptureDevicePosition getCameraPosition();
        void setOutputImageOrientation(UIInterfaceOrientation orientation);
//        void setHorizontallyMirrorFrontFacingCamera(bool newValue);
//        void setHorizontallyMirrorRearFacingCamera(bool newValue);

        
        
        
        
        
        void addTargetLarge(XJGARSDKGPUImageView* target) {
            mLargeView = target;
        }
        
        void addTargetSmall(XJGARSDKGPUImageView* target) {
            mSmallView = target;
        }

        XJGARSDKGPUImageView* mLargeView;
        XJGARSDKGPUImageView* mSmallView;
        
        
        //帧缓存
        XJGARSDKFramebuffer* _framebuffer2;
        //旋转模式
        //RotationMode _outputRotation2 = NoRotation;
        
        void setInputFramebuffer(XJGARSDKGPUImageView*  _realTarget, XJGARSDKFramebuffer* framebuffer, RotationMode rotationMode = NoRotation, int texIdx = 0)  {
            [ _realTarget setInputFramebuffer:framebuffer withRotation:rotationMode atIndex:texIdx];
        };
        
        void updateTargetview(XJGARSDKGPUImageView*  _realTarget)
        {
            [_realTarget updateTargetView:0];
        }
        
        
        void renderAndUpdateTargetview(XJGARSDKGPUImageView*  _realTarget)
        {
            [_realTarget renderAndUpdateTargetview:0];
        }
        
        
        
        //获取当前旋转模式下，实际图像的宽度
        int getRotatedFramebufferWidth() const;
        //获取当前旋转模式下，实际图像的高度
        int getRotatedFramebufferHeight() const;
        
        //用于捕获一帧，指定捕获的宽度与高度
        unsigned char* captureAProcessedFrameData(int width/* = 0*/, int height/* = 0*/);
        
        
    //    EAGLContext* _eglContext;    
    //    void useAsCurrent(void);
    //    void presentBufferForDisplay();


        
        GPUImgLuo::RotationMode _outputRotation;
        
    private:
        
        //参见http://www.jianshu.com/p/7182b8c1d7f4 有关于视频捕获及采样的说明，比较好
        VideoDataOutputSampleBufferDelegate* _videoDataOutputSampleBufferDelegate;
        //相机捕获对话session,You use an AVCaptureSession object to coordinate the flow of data from AV input devices to outputs.
        AVCaptureSession* _captureSession;
        BOOL _capturePaused;
        //GPUImgLuo::RotationMode internalRotation;
        //AVCaptureDeviceInput is a concrete sub-class of AVCaptureInput you use to capture data from an AVCaptureDevice object.
        //从捕获设备（相机）中捕获输入
        AVCaptureDeviceInput* _captureDeviceInput;
        //AVCaptureVideoDataOutput is a concrete sub-class of AVCaptureOutput you use to process uncompressed frames from the video being captured, or to access compressed frames.
        //处理压缩或非压缩的正在捕获的视频、相机等帧数据
        AVCaptureVideoDataOutput* _captureVideoDataOutput;
        /// This determines the rotation applied to the output image, based on the source material
        UIInterfaceOrientation _outputImageOrientation;
        /// These properties determine whether or not the two camera orientations should be mirrored. By default, both are NO.
        //用于控制相机水平方向是否翻转
        bool _horizontallyMirrorFrontFacingCamera, _horizontallyMirrorRearFacingCamera;
        void _updateOutputRotation();
        

    };

}

#endif 

//https://www.cnblogs.com/loying/p/5208821.html
//iOS开发-OC、C、C++ 混编
//OC里面的有三大类文件.m/.h（OC），.c/.h （C)，.cpp/.hpp（C++）。
//一、在OC中调用C或者C++
//如果是.m文件，可以用OC和C的代码；
//如果是.mm文件，可以用OC和C和C++的代码；
//.m 和.mm 的区别是告诉编译器在编译时要加的一些参数。.mm也可以命名成.m,手动加编译参数。
//二、在C++中调用OC
//PIMPL (Private Implementation, 私有实现)
//不要在C++中依赖ARC，最好自己手动管理。
//遇到的问题：
//1，尝试在同一个文件中调用oc、c、c++，ld: symbol(s) not found for architecture x86_64。
//问题出现的原因和OC无关，在c++中引用c的头文件，需要用extern "C"{}把代码包括起来。详细原因见下：
//http://stackoverflow.com/questions/9334650/linker-error-calling-c-function-from-objective-c
//2，在c++中调用OC时遇到了问题，在.cpp文件中调用OC的类，在Foundation处报错。
//问题出现在.cpp文件用的是纯粹的c++编译。
//解决方案：把实现放在.mm。

//相机捕获数据输出委托
@interface VideoDataOutputSampleBufferDelegate : NSObject  <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic) GPUImgLuo::XJGARSDKCameraOperator* XJGARSDKCameraOperator;

@end

