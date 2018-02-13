
#include "XJGARSDKFramebuffer.h"
#include <assert.h>
#include <algorithm>



namespace GPUImgLuo {


    //初始化设置帧缓存的纹理属性值
    TextureAttributes g_DefaultTextureAttribures = {
        .minFilter      = GL_LINEAR,
        .magFilter      = GL_LINEAR,
        .wrapS          = GL_CLAMP_TO_EDGE,
        .wrapT          = GL_CLAMP_TO_EDGE,
        .internalFormat = GL_RGBA,
        .format         = GL_RGBA,
        .type           = GL_UNSIGNED_BYTE
    };

    //设置帧缓存，onlyGenerateTexture指示是否产生帧缓存对象
    XJGARSDKFramebuffer::XJGARSDKFramebuffer(int width, int height, bool bGenFrameBuffer/* = true*/,
                             const TextureAttributes texAttrib/* = g_DefaultTextureAttribures*/)

    {
        mTextureID          = -1                ;
        mFramebufferID      = -1                ;
        mWidth              = width             ;
        mHeight             = height            ;
        mTextureAttributes  = texAttrib         ;
        mHasFB              = bGenFrameBuffer   ;
        
        if (mHasFB)
            GenerateFramebuffer();
        else
            GenerateTexture();
    }

    //帧缓存析构函数函数
    XJGARSDKFramebuffer::~XJGARSDKFramebuffer() {
        if (mTextureID != -1)
        {
            CHECK_GL(glDeleteTextures(      1, &mTextureID      ));
            mTextureID = -1;
        }
        if (mFramebufferID != -1)
        {
            CHECK_GL(glDeleteFramebuffers(  1, &mFramebufferID  ));
            mFramebufferID = -1;
        }
    }

    void XJGARSDKFramebuffer::BeginRenderFrameBuffer()
    {
        CHECK_GL(glBindFramebuffer( GL_FRAMEBUFFER, mFramebufferID  ));
        CHECK_GL(glViewport(        0, 0, mWidth, mHeight           ));
    }

    void XJGARSDKFramebuffer::EndRenderFrameBuffer()
    {
        CHECK_GL(glBindFramebuffer(GL_FRAMEBUFFER, 0                ));
    }

    //为帧缓存生成opengl的纹理
    void XJGARSDKFramebuffer::GenerateTexture()
    {
        if(mTextureID!=-1) return;
        
        CHECK_GL(glGenTextures(  1,             &mTextureID ));
        CHECK_GL(glBindTexture(  GL_TEXTURE_2D, mTextureID  ));
        CHECK_GL(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER   , mTextureAttributes.minFilter  ));
        CHECK_GL(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER   , mTextureAttributes.magFilter  ));
        CHECK_GL(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S       , mTextureAttributes.wrapS      ));
        CHECK_GL(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T       , mTextureAttributes.wrapT      ));

        // TODO: Handle mipmaps
        CHECK_GL(glBindTexture(GL_TEXTURE_2D, 0));
    }

    //为当前类生产帧缓存对象
    void XJGARSDKFramebuffer::GenerateFramebuffer()
    {
        if(mFramebufferID!=-1) return;
        
        CHECK_GL(glGenFramebuffers(1,               &mFramebufferID));
        CHECK_GL(glBindFramebuffer(GL_FRAMEBUFFER,  mFramebufferID));
        
        GenerateTexture();
        
        CHECK_GL(glBindTexture(GL_TEXTURE_2D, mTextureID));
        CHECK_GL(glTexImage2D( GL_TEXTURE_2D, 0, mTextureAttributes.internalFormat,
                              mWidth, mHeight, 0, mTextureAttributes.format,
                              mTextureAttributes.type, 0));
        CHECK_GL(glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextureID, 0));
        CHECK_GL(glBindTexture(         GL_TEXTURE_2D , 0));
        CHECK_GL(glBindFramebuffer(     GL_FRAMEBUFFER, 0));
    }


}
