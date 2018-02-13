
#ifndef _XJGARSDK_EGL_CONTEXT_MANAGER_
#define _XJGARSDK_EGL_CONTEXT_MANAGER_

#include "XJGARSDKMacroDefinitions.h"
#include <mutex>
#include <pthread.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>

namespace GPUImgLuo {

    //Opengl上下文对象管理类，管理Opengles的上下文对象
    class XJGARSDKGLESContextManager {
    public:
        ~XJGARSDKGLESContextManager();

        //获取上下文的实例对象,使用单件模式
        static XJGARSDKGLESContextManager* Instance();
        

        //同步方式调用Opengl函数
        void CallGLFuncSynch(std::function<void(void)> funcToCall);
        //异步方式调用Opengl函数
        void CallGLFuncAsync(std::function<void(void)> funcToCall);
        //将Opengl上下文切换为当前上下文
        void MakeGLContextCurrent(void);
        //获取调用Opengl的派遣队列
        dispatch_queue_t    GetContextQueue() const { return mDispatchQueueForGLCall; };
        //获取EGL的上下对象
        EAGLContext*        GetEGLContext()   const { return mEglContext; };
        //切换EGL渲染缓存，用于显示最终结果
        void                SwapEGLBuffers();


        
    private:
        XJGARSDKGLESContextManager();
        
        static XJGARSDKGLESContextManager*  mpSelfInstance;             //单实例对象
        static std::mutex                   mMutexForThreadSafe;        //互斥对象
        dispatch_queue_t                    mDispatchQueueForGLCall;    //用户opengl同步与异步调用的调度队列
        EAGLContext*                        mEglContext;                //类对象管理的具体EGL上下文
    };



}

#endif //_XJGARSDK_EGL_CONTEXT_MANAGER_
