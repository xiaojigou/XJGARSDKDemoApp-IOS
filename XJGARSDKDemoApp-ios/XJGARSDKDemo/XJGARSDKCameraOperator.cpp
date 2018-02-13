
#include "XJGARSDKCameraOperator.h"
#include "XJGARSDKGLESContextManager.h"


using namespace GPUImgLuo;

//初始化
XJGARSDKCameraOperator::XJGARSDKCameraOperator() {
    _videoDataOutputSampleBufferDelegate = [[VideoDataOutputSampleBufferDelegate alloc] init];
    _videoDataOutputSampleBufferDelegate.XJGARSDKCameraOperator = this;
    
    _horizontallyMirrorFrontFacingCamera = false;
    _horizontallyMirrorRearFacingCamera = true;

}
//析构函数
XJGARSDKCameraOperator::~XJGARSDKCameraOperator() {
    stop();
    _videoDataOutputSampleBufferDelegate = 0;

}
//创建并初始化一个新的XJGARSDKCameraOperator对象
XJGARSDKCameraOperator* XJGARSDKCameraOperator::create() {
    XJGARSDKCameraOperator* camOperator = new XJGARSDKCameraOperator();

    if (!camOperator->init()) {
        camOperator = 0;
    }

    return camOperator;
}

void XJGARSDKCameraOperator::setFrameData(int width, int height, const void* pixels, RotationMode outputRotation/* = RotationMode::NoRotation*/) {

    
    _framebuffer2 = 0;
//    _outputRotation2 = outputRotation;
    static  XJGARSDKFramebuffer* framebuffer  = NULL;
    if(framebuffer==NULL)
        framebuffer = new XJGARSDKFramebuffer(width, height, false);
    _framebuffer2 = framebuffer;
//    _outputRotation2 = outputRotation;



    //将帧缓存中的纹理取出，并将数据载入到纹理中
    CHECK_GL(glBindTexture(GL_TEXTURE_2D, framebuffer->GetAttachedTexture()));

    CHECK_GL(glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, pixels));

    CHECK_GL(glBindTexture(GL_TEXTURE_2D, 0));
}


//初始化相机对象
bool XJGARSDKCameraOperator::init() {
    
   
//    //默认初始化前置摄像头，如果前置摄像头存在则初始化，否则初始化后置摄像头。并设置分辨率为640x480
//    if (isCameraExist(AVCaptureDevicePositionFront))
//        return init(AVCaptureSessionPreset640x480, AVCaptureDevicePositionFront);
//    else
//        return init(AVCaptureSessionPreset640x480, AVCaptureDevicePositionBack);
    
    //默认初始化前置摄像头，如果前置摄像头存在则初始化，否则初始化后置摄像头。并设置分辨率为最高分辨率
    if (isCameraExist(AVCaptureDevicePositionFront))
        return init(AVCaptureSessionPresetHigh, AVCaptureDevicePositionFront);
    else
        return init(AVCaptureSessionPresetHigh, AVCaptureDevicePositionBack);
}


//初始化指定位置cameraPosition（前置或后置）的摄像头数据，并指定分辨率字符串sessionPreset
//然后设置相机的一些属性，及相机的格式类型
bool XJGARSDKCameraOperator::init(NSString* sessionPreset, AVCaptureDevicePosition cameraPosition) {
    
    _outputRotation = GPUImgLuo::NoRotation;
    //internalRotation = GPUImgLuo::NoRotation;
    _capturePaused = NO;
    
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = sessionPreset;
    
    // input 设置相机输入为视频，不是图片
    AVCaptureDevice* device = 0;
    for(AVCaptureDevice* dev in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if([dev position] == cameraPosition)
        {
            device = dev;
            break;
        }
    }
    if (!device) return false;
    
    NSError *error = nil;
    //用指定的设备初始化输入对象，并指定给session的输入
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([_captureSession canAddInput:_captureDeviceInput])
    {
        [_captureSession addInput:_captureDeviceInput];
        
    } else {
        return false;
    }
    
    // output，初始化视频输出对象，设置当一帧到达超时时直接抛弃该帧
    _captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_captureVideoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [_captureSession addOutput:_captureVideoDataOutput];//将视频数据输出对象指定给session管理
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //设置视频输出对象的像素格式
    [_captureVideoDataOutput setSampleBufferDelegate:_videoDataOutputSampleBufferDelegate queue:queue];
    _captureVideoDataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                 nil];
    //设置输出图像的方向信息
    setOutputImageOrientation(UIInterfaceOrientationPortrait);
    
    return true;
}

//判断相机是否存在。cameraPosition：相机的位置，代表前置相机还是后置相机
bool XJGARSDKCameraOperator::isCameraExist(AVCaptureDevicePosition cameraPosition) {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == cameraPosition)
            return true;
    }
    return false;
}

void XJGARSDKCameraOperator::start() {
    if (![_captureSession isRunning])
    {
        _videoDataOutputSampleBufferDelegate.XJGARSDKCameraOperator = this;
        //Tells the receiver to start running.
        [_captureSession startRunning];
    };
}

void XJGARSDKCameraOperator::stop() {
    if ([_captureSession isRunning])
    {
        _videoDataOutputSampleBufferDelegate.XJGARSDKCameraOperator = 0;
        [_captureSession stopRunning];
    }
}

void XJGARSDKCameraOperator::pause() {
    _capturePaused = true;
}

void XJGARSDKCameraOperator::resume() {
    _capturePaused = false;
}

bool XJGARSDKCameraOperator::isRunning() {
    return [_captureSession isRunning];
}


#define rotationSwapsSize(rotation) ((rotation) == GPUImgLuo::RotateLeft || (rotation) == GPUImgLuo::RotateRight || (rotation) == GPUImgLuo::RotateRightFlipVertical || (rotation) == GPUImgLuo::RotateRightFlipHorizontal)

//获取当前旋转模式下，实际图像的宽度
int XJGARSDKCameraOperator::getRotatedFramebufferWidth() const {
    if (_framebuffer2)
//        if (rotationSwapsSize(_outputRotation2))
        if (rotationSwapsSize(_outputRotation))
            return _framebuffer2->GetFrameBufHeight();
        else
            return _framebuffer2->GetFrameBufWidth();
        else
            return 0;
}

//获取当前旋转模式下，实际图像的高度
int XJGARSDKCameraOperator::getRotatedFramebufferHeight() const {
    if (_framebuffer2)
//        if (rotationSwapsSize(_outputRotation2))
        if (rotationSwapsSize(_outputRotation))
            return _framebuffer2->GetFrameBufWidth();
        else
            return _framebuffer2->GetFrameBufHeight();
        else
            return 0;
}

//用于捕获一帧，指定捕获的宽度与高度
unsigned char* XJGARSDKCameraOperator::captureAProcessedFrameData( int width/* = 0*/, int height/* = 0*/) {
//    if (Context::getInstance()->isCapturingFrame) return 0 ;
    
    //如果还没有取得高度宽度值，则从帧缓存中获取
    if (width <= 0 || height <= 0) {
        if (!_framebuffer2) return 0;
        width = getRotatedFramebufferWidth();
        height = getRotatedFramebufferHeight();
    }
    
    XJGARSDKFramebuffer* framebuffer =_framebuffer2;
//    RotationMode rotationMode =_outputRotation2;
    RotationMode rotationMode =_outputRotation;
    setInputFramebuffer(mLargeView,framebuffer,rotationMode,0);
    updateTargetview(mLargeView);

    
    unsigned char* processedFrameData = new unsigned char[width * height * 4];
    CHECK_GL(glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, processedFrameData));
    
    return processedFrameData;
}




//翻转相机的位置
bool XJGARSDKCameraOperator::flip() {
    //相机捕获设备的位置，front相机还是背面相机
    AVCaptureDevicePosition cameraPosition = [[_captureDeviceInput device] position];
    if (cameraPosition == AVCaptureDevicePositionBack)
    {
        cameraPosition = AVCaptureDevicePositionFront;
    }
    else
    {
        cameraPosition = AVCaptureDevicePositionBack;
    }
//如果反转后相机不存在，则翻转失败
    if (!isCameraExist(cameraPosition))
        return false;
    
    //遍历所有视频捕获类型的设备，查看位置是否为指定的位置匹配，
    AVCaptureDevice* device = 0;
    for(AVCaptureDevice* dev in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if([dev position] == cameraPosition)
        {
            device = dev;
            break;
        }
    }
    //如果还是找不到设备，则翻转失败
    if (!device) return false;
    
    //创建一个新的输入设备，如果不能创建，则失败
    NSError *error = nil;
    AVCaptureDeviceInput* newCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!newCaptureDeviceInput) return false;
    
    //开始重新配置捕获设备
    [_captureSession beginConfiguration];
    
    [_captureSession removeInput:_captureDeviceInput];          //将之前的输入设备移除掉
    if ([_captureSession canAddInput:newCaptureDeviceInput])    //查看刚刚创建的输入设备对象可否加入到Session的输入中
    {
        [_captureSession addInput:newCaptureDeviceInput];       //可以就加入
        _captureDeviceInput = newCaptureDeviceInput;            //保存设备的指针
    }
    else
    {
        [_captureSession addInput:_captureDeviceInput];         //否则还是使用之前保存的输入设备
    }
    [_captureSession commitConfiguration];//配置完成，提交
    
    _updateOutputRotation();
    
    return true;
}

AVCaptureDevicePosition XJGARSDKCameraOperator::getCameraPosition()
{
    return [[_captureDeviceInput device] position];
}

void XJGARSDKCameraOperator::setOutputImageOrientation(UIInterfaceOrientation orientation) {
    _outputImageOrientation = orientation;
    _updateOutputRotation();
}

//void XJGARSDKCameraOperator::setHorizontallyMirrorFrontFacingCamera(bool newValue)
//{
//    _horizontallyMirrorFrontFacingCamera = newValue;
//    _updateOutputRotation();
//}
//
//void XJGARSDKCameraOperator::setHorizontallyMirrorRearFacingCamera(bool newValue)
//{
//    _horizontallyMirrorRearFacingCamera = newValue;
//    _updateOutputRotation();
//}

//根据相机的位置，相机的显示模式，设置图像的旋转对齐方式
void XJGARSDKCameraOperator::_updateOutputRotation()
{
//    _outputRotation = GPUImgLuo::NoRotation;
//    return;
    
    if (getCameraPosition() == AVCaptureDevicePositionBack)
    {
        if (_horizontallyMirrorRearFacingCamera)
        {
            switch(_outputImageOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    _outputRotation = GPUImgLuo::RotateRightFlipVertical; break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    _outputRotation = GPUImgLuo::Rotate180; break;
                case UIInterfaceOrientationLandscapeLeft:
                    _outputRotation = GPUImgLuo::FlipHorizontal; break;
                case UIInterfaceOrientationLandscapeRight:
                    _outputRotation = GPUImgLuo::FlipVertical; break;
                default:
                    _outputRotation = GPUImgLuo::NoRotation;
            }
        }
        else
        {
            switch(_outputImageOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    _outputRotation = GPUImgLuo::RotateRight; break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    _outputRotation = GPUImgLuo::RotateLeft; break;
                case UIInterfaceOrientationLandscapeLeft:
                    _outputRotation = GPUImgLuo::Rotate180; break;
                case UIInterfaceOrientationLandscapeRight:
                    _outputRotation = GPUImgLuo::NoRotation; break;
                default:
                    _outputRotation = GPUImgLuo::NoRotation;
            }
        }
    }
    else
    {
        if (_horizontallyMirrorFrontFacingCamera)
        {
            switch(_outputImageOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    _outputRotation = GPUImgLuo::RotateRightFlipVertical; break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    _outputRotation = GPUImgLuo::RotateRightFlipHorizontal; break;
                case UIInterfaceOrientationLandscapeLeft:
                    _outputRotation = GPUImgLuo::FlipHorizontal; break;
                case UIInterfaceOrientationLandscapeRight:
                    _outputRotation = GPUImgLuo::FlipVertical; break;
                default:
                    _outputRotation = GPUImgLuo::NoRotation;
            }
        }
        else
        {
            switch(_outputImageOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    _outputRotation = GPUImgLuo::RotateRight; break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    _outputRotation = GPUImgLuo::RotateLeft; break;
                case UIInterfaceOrientationLandscapeLeft:
                    _outputRotation = GPUImgLuo::NoRotation; break;
                case UIInterfaceOrientationLandscapeRight:
                    _outputRotation = GPUImgLuo::Rotate180; break;
                default:
                    _outputRotation = GPUImgLuo::NoRotation;
            }
        }
    }
    //_videoDataOutputSampleBufferDelegate.rotation = _outputRotation;
}




@implementation VideoDataOutputSampleBufferDelegate
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
//相机捕获输出回调接口，传入捕获输出对象、采样缓存、连接对象
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_XJGARSDKCameraOperator) {
        XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
            //获取图像缓存，锁定，并将数据辅导相机对象的帧数据中
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CVPixelBufferLockBaseAddress(imageBuffer, 0);
//            _XJGARSDKCameraOperator->setFrameData((int) CVPixelBufferGetWidth(imageBuffer),
//                                        (int) CVPixelBufferGetHeight(imageBuffer),
//                                        CVPixelBufferGetBaseAddress(imageBuffer),
//                                        _rotation);
            _XJGARSDKCameraOperator->setFrameData((int) CVPixelBufferGetWidth(imageBuffer),
                                        (int) CVPixelBufferGetHeight(imageBuffer),
                                        CVPixelBufferGetBaseAddress(imageBuffer),
                                         _XJGARSDKCameraOperator->_outputRotation);
 
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

            
            
            XJGARSDKFramebuffer* framebuffer =_XJGARSDKCameraOperator->_framebuffer2;
//            RotationMode rotationMode =_XJGARSDKCameraOperator->_outputRotation2;
            RotationMode rotationMode =_XJGARSDKCameraOperator->_outputRotation;
            XJGARSDKGPUImageView* mLargeView =_XJGARSDKCameraOperator->mLargeView;
            XJGARSDKGPUImageView* mSmallView =_XJGARSDKCameraOperator->mSmallView;
            [mLargeView setRotatedFrameBufWidth:_XJGARSDKCameraOperator->getRotatedFramebufferWidth()];
            [mLargeView setRotatedFrameBufHeight:_XJGARSDKCameraOperator->getRotatedFramebufferHeight()];

            _XJGARSDKCameraOperator->setInputFramebuffer(mLargeView,framebuffer,rotationMode,0);
            //            _XJGARSDKCameraOperator->updateTargetview(mLargeView);
            _XJGARSDKCameraOperator->renderAndUpdateTargetview(mLargeView);
//            _XJGARSDKCameraOperator->setInputFramebuffer(mSmallView,framebuffer,rotationMode,0);
//            _XJGARSDKCameraOperator->updateTargetview(mSmallView);
        });
    }
}
@end
