
#ifndef _XJGARSDK_IMAGE_OPERATOR_
#define _XJGARSDK_IMAGE_OPERATOR_


#include "XJGARSDKGPUImageView.h"

namespace GPUImgLuo {

    class XJGARSDKImageOperator {//: public Source{
    public:
        XJGARSDKImageOperator() {}

        static XJGARSDKImageOperator* create(int width, int height, const void* pixels);
        XJGARSDKImageOperator* setImage(int width, int height, const void* pixels);


        static XJGARSDKImageOperator* create(NSURL* imageUrl);
        XJGARSDKImageOperator* setImage(NSURL* imageUrl);
        
        static XJGARSDKImageOperator* create(NSData* imageData);
        XJGARSDKImageOperator* setImage(NSData* imageData);
        
        static XJGARSDKImageOperator* create(UIImage* image);
        XJGARSDKImageOperator* setImage(UIImage* image);
        
        static XJGARSDKImageOperator* create(CGImageRef image);
        XJGARSDKImageOperator* setImage(CGImageRef image);
        
        
        
        void addTargetLarge(XJGARSDKGPUImageView* target) {
            mLargeView = target;
        }
        
        XJGARSDKGPUImageView* mLargeView;
        
        //帧缓存
        XJGARSDKFramebuffer* _framebuffer2;
        //旋转模式
        RotationMode _outputRotation2;
        
        void setInputFramebuffer(XJGARSDKGPUImageView*  _realTarget, XJGARSDKFramebuffer* framebuffer, RotationMode rotationMode = NoRotation, int texIdx = 0)  {
            [ _realTarget setInputFramebuffer:framebuffer withRotation:rotationMode atIndex:texIdx];
        };
        
        void updateTargetview(XJGARSDKGPUImageView*  _realTarget)
        {
            [_realTarget updateTargetView:0];
        }
        
        void proceed()
        {

//            [mLargeView setRotatedFrameBufWidth:getRotatedFramebufferWidth()];
//            [mLargeView setRotatedFrameBufHeight:getRotatedFramebufferHeight()];
            
            [mLargeView setRotatedFrameBufWidth:_framebuffer2->GetFrameBufWidth()];
            [mLargeView setRotatedFrameBufHeight:_framebuffer2->GetFrameBufHeight()];

            setInputFramebuffer(mLargeView,_framebuffer2);
            updateTargetview(mLargeView);
        };
        
        //获取当前旋转模式下，实际图像的宽度
        int getRotatedFramebufferWidth() const;
        //获取当前旋转模式下，实际图像的高度
        int getRotatedFramebufferHeight() const;
        
        //用于捕获一帧，指定捕获的宽度与高度
        unsigned char* captureAProcessedFrameData(int width/* = 0*/, int height/* = 0*/);
        
        

    private:
        UIImage* _adjustImageOrientation(UIImage* image);

    };

}

#endif 
