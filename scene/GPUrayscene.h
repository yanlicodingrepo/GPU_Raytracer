/*!
    @file GPURayScene.h
    @author: yanli
    @date: May 2013
 */

#ifndef GPURayScene_H
#define GPURayScene_H

#include <qgl.h>
#include "scene.h"
#include "CL/cl.h"
#include "oclUtils.h"
#include <QVector>
#include "CS123SceneData.h"
#include <QHash>
#include <string>
#include <fstream>

class Scene;
struct CLPack;
class OrbitCamera;
class KdTree;

struct KdTreeNodeHost
{
    cl_float3 boxBegin;
    cl_float3 boxSize;
    cl_float split;
    cl_int leaf;
    cl_int axis;
    cl_int leftIndex;
    cl_int rightIndex;
    cl_int objIndex;
};

struct ObjectNodeHost
{
    cl_int objectIndex;
    cl_int nextNodeIndex;
};


class GPURayScene
{
public:

    struct LightDataHost
    {
        cl_int id;
        cl_int type;
        cl_float4 color;
        cl_float3 function;
        cl_float4 pos;
        cl_float4 dir;

        cl_float radius;
        cl_float penumbra;
        cl_float angle;
        cl_float width;
        cl_float height;
    };

    struct ObjectDataHost
    {
        cl_float16 transform;
        cl_float16 invTransform;
        cl_float16 invTTransformWithoutTrans;
        cl_int type;

        // Textures
        // Only support general texture. Bump texture not supported
        cl_int texHandle;
        cl_float texBlend;
        cl_float2 texRepeat;
        cl_int texIsUsed;
        cl_int texMapID;
        cl_int texWidth;
        cl_int texHeight;
        // Materials
        cl_float4 diffuse;
        cl_float4 ambient;
        cl_float4 reflective;
        cl_float4 specular;
        cl_float4 transparent;
        cl_float4 emmisive;
        cl_float shininess;
        cl_float ior;
    };

    struct GlobalSettingHost
    {
        cl_int useShadow;
        cl_int usePointLight;
        cl_int useDirectionalLight;
        cl_int useSpotLight;
        cl_int showTexture;
        cl_int useSupersampling;
        cl_int traceNum;
        cl_int useReflection;
        cl_int useKdTree;
    };

    /*
    struct KdTreeNodeHost
    {
        cl_float3 boxBegin;
        cl_float3 boxSize;
        cl_float split;
        cl_int leaf;
        cl_int axis;
        cl_int leftIndex;
        cl_int rightIndex;
        cl_int objIndex;
    };

    struct ObjectNodeHost
    {
        cl_int objectIndex;
        cl_int nextNodeIndex;
    };*/

    GPURayScene();
    GPURayScene( CLPack* cl,
                 OrbitCamera* camera,
                 Scene* scene,
                 GLuint screenTexHandle,
                 GLuint screenPbo,
                 GLuint screenWidth,
                 GLuint screenHeight );
    ~GPURayScene();

    void render();
    void syncGlobalSettings();

private:

    OrbitCamera* m_camera;
    CLPack* m_cl;
    cl_float4 m_global;
    QVector<LightDataHost> m_lightData;
    QVector<ObjectDataHost> m_objects;

    QVector<KdTreeNodeHost> m_kdNodes;
    QVector<ObjectNodeHost> m_objNodes;

    GLuint m_screenTex;
    GLuint m_screenPbo;

    GLuint m_screenWidth;
    GLuint m_screenHeight;

    GlobalSettingHost m_globalSetting;

    cl_mem m_cmGlobal;
    cl_mem m_cmLight;
    cl_mem m_cmObject;

    cl_mem m_cmKdNodes;
    cl_mem m_cmObjNodes;

    cl_mem m_cmTexPixelBuffer;
    cl_mem m_cmOffsetBuffer;

    QVector<cl_uint> m_textureOffsets;

    cl_int m_pixelNum;
    cl_uint* m_pixels;

    QVector<cl_GLuint> m_textureHandles;

private:
    void pushSceneData( Scene* scene );
    void setKernelArgs();

    void displayScreenTex();
    void updateScreenTexFromPBO();

    cl_float4 copySceneColor( CS123SceneColor color );
    cl_float16 copySceneMatrix( Matrix4x4 mat );
    cl_float4 copySceneVector4( Vector4 v );
    cl_float3 copySceneVector3( Vector3 v );
    void copyKdTree( Scene* scene, KdTree* tree );
    void dumpCLKdTree( std::string fileName );
    void dumpKdTreeInfoLeaf( int curIndex,  std::ofstream& ofile, int depth );

    void initCLBuffers();
};

#endif // GPURayScene_H
