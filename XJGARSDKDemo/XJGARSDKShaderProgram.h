
#ifndef _XJGARSDK_SHDER_PROGRM_
#define _XJGARSDK_SHDER_PROGRM_

#include "XJGARSDKMacroDefinitions.h"
#include "string"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#include <vector>

namespace GPUImgLuo {

    class XJGARSDKShaderProgram{
    public:
        XJGARSDKShaderProgram();
        ~XJGARSDKShaderProgram();
        
        static XJGARSDKShaderProgram* CreatShaderProgramFromString(
            const std::string& vShaderStr, const std::string& fShaderStr);
        
        void        UseThisProgram();
        GLuint      GetProgramID() const { return mProgramID; }

        GLuint      GetAttribLocation(  const std::string& attribute                );
        GLuint      GetUniformLocation( const std::string& uniformName              );
        void        SetUniformValue(const std::string& uniformName, int     value   );
        void        SetUniformValue(const std::string& uniformName, float   value   );
        void        SetUniformValue(int uniformLocation, int    value               );
        void        SetUniformValue(int uniformLocation, float  value               );
        
    private:
        GLuint mProgramID;
        bool        LoadShaderFromString(
             const std::string& vShaderStr, const std::string& fShaderStr);
    };


}

#endif //_XJGARSDK_SHDER_PROGRM_
