
#ifndef _XJGARSDK_FRAME_BUFFER_
#define _XJGARSDK_FRAME_BUFFER_

#include "XJGARSDKMacroDefinitions.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#include <vector>

namespace GPUImgLuo {

    typedef struct {
        GLenum minFilter;           //纹理的缩小过滤模式
        GLenum magFilter;           //纹理的放大过滤模式
        GLenum wrapS;               //纹理的环绕方式，x方向
        GLenum wrapT;               //纹理的环绕方式，y方向
        GLenum internalFormat;      //纹理的内部格式（GPU端）
        GLenum format;              //纹理的外部格式（CPU端）
        GLenum type;                //纹理的类型
    } TextureAttributes;            //纹理属性类
    extern TextureAttributes g_DefaultTextureAttribures;
    //帧缓存类，指定帧缓存的高宽，纹理的产生
    class XJGARSDKFramebuffer
    {
    public:
    //    Framebuffer();
        XJGARSDKFramebuffer(int width, int height, bool bGenFrameBuffer = true,
                    const TextureAttributes texAttrib = g_DefaultTextureAttribures);
        ~XJGARSDKFramebuffer();
        
        
        //获取帧缓存关联的纹理对象
        GLuint GetAttachedTexture()     const   { return mTextureID;        }
        GLuint GetFramebuffer()         const   { return mFramebufferID;    }
        int GetFrameBufWidth ()         const   { return mWidth;            }
        int GetFrameBufHeight()         const   { return mHeight;           }
        const TextureAttributes& getTextureAttributes() const
        { return mTextureAttributes; };
        bool HasFramebuffer()           { return mHasFB; }
        
        //设置当前帧缓存是活动还是非活动
        void BeginRenderFrameBuffer ();
        void EndRenderFrameBuffer   ();

        
    private:
        int                 mWidth, mHeight         ;
        TextureAttributes   mTextureAttributes      ;
        bool                mHasFB                  ;
        GLuint              mTextureID              ;
        GLuint              mFramebufferID          ;
        
        void GenerateTexture();
        void GenerateFramebuffer();

    };


}

#endif //_XJGARSDK_FRAME_BUFFER_
