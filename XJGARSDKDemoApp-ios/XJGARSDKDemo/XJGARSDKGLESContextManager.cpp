
#include "XJGARSDKGLESContextManager.h"
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/glext.h>

namespace GPUImgLuo {

    #define GL_CONTEXT_QUEUE    "com.xiaojigou.luo.openglContextQueue"


    XJGARSDKGLESContextManager* XJGARSDKGLESContextManager::mpSelfInstance = NULL;
    std::mutex                  XJGARSDKGLESContextManager::mMutexForThreadSafe;

    XJGARSDKGLESContextManager::XJGARSDKGLESContextManager()
    {
        mDispatchQueueForGLCall = dispatch_queue_create(GL_CONTEXT_QUEUE, DISPATCH_QUEUE_SERIAL);
        mEglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:mEglContext];
        //Instance();
    }

    XJGARSDKGLESContextManager::~XJGARSDKGLESContextManager() {
        
    }

    XJGARSDKGLESContextManager* XJGARSDKGLESContextManager::Instance() {
        if (!mpSelfInstance)
        {
            std::unique_lock<std::mutex> lock(mMutexForThreadSafe);
            if (!mpSelfInstance) {
                mpSelfInstance = new (std::nothrow) XJGARSDKGLESContextManager;
            }
        }
        return mpSelfInstance;
    };




    //相当于用同步的方式，在Opengl上下文中
    void XJGARSDKGLESContextManager::CallGLFuncSynch(std::function<void(void)> funcToCall) {
        //切换Opengl上下文
        MakeGLContextCurrent();
        //A dispatch queue is a lightweight object to which your application submits blocks for subsequent execution.
        dispatch_queue_t contextQueue = GetContextQueue();

        //Returns the queue on which the currently executing block is running.
        //    This function is defined to never return NULL.
        //如果当前线程的同步派遣队列与Opengl上下文的调用派遣队列一致，则直接调用，
        if (dispatch_get_current_queue() == contextQueue)
        {
            funcToCall();
        }
        else//否则调用同步派遣的方式执行函数
        {
            //Submits a block object for execution on a dispatch queue and waits until that block completes.
            //dispatch_sync(),同步添加操作。他是等待添加进队列里面的操作完成之后再继续执行。
            //dispatch_async ,异步添加进任务队列，它不会做任何等待
            dispatch_sync(contextQueue, ^{ funcToCall(); });
        }
    }

    void XJGARSDKGLESContextManager::CallGLFuncAsync(std::function<void(void)> funcToCall) {
        MakeGLContextCurrent();
        dispatch_queue_t contextQueue = GetContextQueue();

        if (dispatch_get_current_queue() == contextQueue)
        {
            funcToCall();
        }else
        {
            dispatch_async(contextQueue, ^{ funcToCall(); });
        }
    }

    void XJGARSDKGLESContextManager::MakeGLContextCurrent(void)
    {
        if ([EAGLContext currentContext] != mEglContext)
        {
            [EAGLContext setCurrentContext:mEglContext];
        }
    }

    void XJGARSDKGLESContextManager::SwapEGLBuffers() {
        [mEglContext presentRenderbuffer:GL_RENDERBUFFER ];
    }


}
