#include "global.h"
#include "GL/glu.h"
Settings settings;

Settings::Settings(){
}

void Settings::initSettings()
{
    useLighting = true;
    traceMode = CPU;
    drawWireFrame = false;
    drawNormals = false;
    usePointLights = true;
    useDirectionalLights = true;
    showAxis = true;
    testDrawShape = false;
    testCL = false;
    showTexture = true;
    useMultithread = false;
    useSupersampling = false;
    useShadow = false;
    useSpotLights = false;
    useReflection = true;
    traceRaycursion = 4;
    traceThreadNum = 5;
    showBoundingBox = false;
    showKdTree = false;
    useKdTree = true;
}

const char* getGLErrorString()
{
    GLenum err;
    if( (err = glGetError()) != GL_NO_ERROR )
    {
        return (const char*)gluErrorString( err );
    }
    else
        return NULL;

}
