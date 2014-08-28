/*!
    @file global.h
    @author: yanli
    @date: May 2013
 */

#ifndef GLOBAL_H
#define GLOBAL_H
/*!
    This file includes the global defination of the project
 */

#include <qgl.h>
#include <iostream>
#include "GPUrayscene.h"
#include <QVector>

#define WIN_WIDTH 600
#define WIN_HEIGHT 600

#define GPU_LOCAL_WORK_SIZE_X 32
#define GPU_LOCAL_WORK_SIZE_Y 32

#define MAX_ARRAY 1024

#define DUMP_EXTENSION_INFO

enum TraceMode
{
    GPU,
    CPU
};

enum PolygonMode
{
    POINT,
    LINE,
    FILL
};

struct Settings
{
    Settings();
    void initSettings();

    bool useLighting;
    TraceMode traceMode;
    bool drawWireFrame;
    bool drawNormals;
    bool useDirectionalLights;
    bool usePointLights;
    bool showAxis;
    bool showTexture;
    bool testDrawShape;
    bool testCL;
    bool useMultithread;
    bool useSupersampling;
    bool useShadow;
    bool useSpotLights;
    bool useReflection;
    bool showBoundingBox;
    bool showKdTree;
    bool useKdTree;

    int traceRaycursion;
    int traceThreadNum;
};

// Will be initialized in mainwindow
extern Settings settings;

extern QVector<KdTreeNodeHost> kdnode_test;
extern QVector<ObjectNodeHost> objnode_test;

#define OFFSET(offset) ((void*)NULL + offset)

const char* getGLErrorString();

#define PRINT_GL_ERROR(void) ({ \
    const char* error = getGLErrorString();\
    if(error) \
    {\
        std::cout<<"GL error: "<<error<<std::endl;\
    }\
})
#endif // GLOBAL_H
