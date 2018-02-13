
#include <algorithm>
#include "XJGARSDKShaderProgram.h"
#include "XJGARSDKGLESContextManager.h"
#include "util.h"

namespace GPUImgLuo {


    XJGARSDKShaderProgram::XJGARSDKShaderProgram()
    {
        mProgramID= -1;
    }

    XJGARSDKShaderProgram::~XJGARSDKShaderProgram() {
        if (mProgramID != -1) {
            glDeleteProgram(mProgramID);
            mProgramID = -1;
        }
    }



    XJGARSDKShaderProgram* XJGARSDKShaderProgram::CreatShaderProgramFromString(
        const std::string& vShaderStr, const std::string& fShaderStr)
    {
        XJGARSDKShaderProgram* prog = new (std::nothrow) XJGARSDKShaderProgram();
        if (prog) {
            if (!prog->LoadShaderFromString(vShaderStr, fShaderStr))
            {
                delete prog;
                prog = NULL;
            }
        }
        return prog;
    }


    bool XJGARSDKShaderProgram::LoadShaderFromString(
        const std::string& vShaderStr, const std::string& fShaderStr)
    {

        if (mProgramID != -1) {
            CHECK_GL(glDeleteProgram(mProgramID));
            mProgramID = -1;
        }
        CHECK_GL(mProgramID = glCreateProgram());

        CHECK_GL(GLuint vertShader          = glCreateShader(GL_VERTEX_SHADER));
        const char* vertexShaderSourceStr   = vShaderStr.c_str();
        CHECK_GL(glShaderSource(vertShader, 1, &vertexShaderSourceStr, NULL));
        CHECK_GL(glCompileShader(vertShader));

        CHECK_GL(GLuint fragShader          = glCreateShader(GL_FRAGMENT_SHADER));
        const char* fragmentShaderSourceStr = fShaderStr.c_str();
        CHECK_GL(glShaderSource(fragShader, 1, &fragmentShaderSourceStr, NULL));
        CHECK_GL(glCompileShader(fragShader));

        CHECK_GL(glAttachShader(mProgramID, vertShader));
        CHECK_GL(glAttachShader(mProgramID, fragShader));

        CHECK_GL(glLinkProgram(mProgramID));

        CHECK_GL(glDeleteShader(vertShader));
        CHECK_GL(glDeleteShader(fragShader));
        
        return true;
    }

    void XJGARSDKShaderProgram::UseThisProgram()
    {
        CHECK_GL(glUseProgram(mProgramID));
    }

    GLuint XJGARSDKShaderProgram::GetAttribLocation(const std::string& attribute)
    {
        return glGetAttribLocation(mProgramID, attribute.c_str());
    }

    GLuint XJGARSDKShaderProgram::GetUniformLocation(const std::string& uniformName)
    {
        return glGetUniformLocation(mProgramID, uniformName.c_str());
    }


    void XJGARSDKShaderProgram::SetUniformValue(const std::string& uniformName, int value)
    {
        UseThisProgram();
        SetUniformValue(GetUniformLocation(uniformName), value);
    }

    void XJGARSDKShaderProgram::SetUniformValue(const std::string& uniformName, float value)
    {
        UseThisProgram();
        SetUniformValue(GetUniformLocation(uniformName), value);
    }
    void XJGARSDKShaderProgram::SetUniformValue(int uniformLocation, int value)
    {
        UseThisProgram();
        CHECK_GL(glUniform1i(uniformLocation, value));
    }

    void XJGARSDKShaderProgram::SetUniformValue(int uniformLocation, float value)
    {
        UseThisProgram();
        CHECK_GL(glUniform1f(uniformLocation, value));
    }

}
