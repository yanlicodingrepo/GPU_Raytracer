#include "CPUrayscene.h"
#include "camera.h"
#include "view2d.h"
#include "trace.h"
#include "trace_thread.h"
#include "kdtree.h"

CPURayScene::CPURayScene()
{

}

CPURayScene::CPURayScene( Scene* scene )
{
    m_globalData     = scene->getGlobal();
    m_lightData = scene->getLight();
    m_objects = scene->getObjects();
    m_tree = scene->getKdTree();
    m_extends = scene->getExtends();
}

CPURayScene::~CPURayScene()
{

}

cl_float3 copySceneVector3( Vector3 v )
{
    cl_float3 result;
    result.s0 = v.xyz[0];
    result.s1 = v.xyz[1];
    result.s2 = v.xyz[2];
    return result;
}

/**
    For GPU test
  **/
/*
void copyKdTree(  KdTree* tree )
{
    kdnode_test.resize( KDTREE_ARRAY_SIZE );
    objnode_test.resize( KDTREE_ARRAY_SIZE );
    KdTreeNode* kdNodeArray = tree->getKdTreeNodeArray();
    ObjectNode* objNodeArray = tree->getObjectNodeArray();
    for( int i = 0; i < KDTREE_ARRAY_SIZE; i++ )
    {
        kdnode_test[i].axis = kdNodeArray[i].getAxis();
        kdnode_test[i].boxBegin = copySceneVector3(kdNodeArray[i].getAABB().getPos());
        kdnode_test[i].boxSize = copySceneVector3(kdNodeArray[i].getAABB().getSize());
        kdnode_test[i].leaf = kdNodeArray[i].isLeaf();
        kdnode_test[i].split = kdNodeArray[i].getSplitPos();
        if( kdNodeArray[i].getLeft() )
            kdnode_test[i].leftIndex = kdNodeArray[i].getLeft() - kdNodeArray;
        else
            kdnode_test[i].leftIndex = -1;
        if( kdNodeArray[i].getRight() )
            kdnode_test[i].rightIndex = kdNodeArray[i].getRight() - kdNodeArray;
        else
            kdnode_test[i].rightIndex = -1;
        if( kdNodeArray[i].getObjectList() )
            kdnode_test[i].objIndex = kdNodeArray[i].getObjectList() - objNodeArray;
        else
            kdnode_test[i].objIndex = -1;

        if( objNodeArray[i].getObject() )
        {
            objnode_test[i].objectIndex = objNodeArray[i].getObject()->m_arrayID;
        }
        else
            objnode_test[i].objectIndex = -1;

        if( objNodeArray[i].getNext() )
            objnode_test[i].nextNodeIndex = objNodeArray[i].getNext() - objNodeArray;
        else
            objnode_test[i].nextNodeIndex  = -1;
    }
}
*/

void CPURayScene::traceScene( View2D* view2D,
                 OrbitCamera* camera,
                 int width,
                 int height
                 )
{

    assert( view2D );
    assert( camera );
    assert( width > 0 && height > 0 );

    camera->updateMatrices();
    Vector4 eyePos;
    Matrix4x4 invViewTransMat;

    // Resize the view2D
    view2D->resize( width, height );

    eyePos = camera->getEyePos();

    invViewTransMat = camera->getInvViewTransMatrix();

    BGRA* pixels = view2D->data();

    if( settings.useMultithread )
    {
        assert( settings.traceThreadNum > 0 );
        int unitLength = width*height/settings.traceThreadNum;
        TraceThread* threads = new TraceThread[settings.traceThreadNum];

        for( int i = 0; i < settings.traceThreadNum-1; i++ )
            threads[i].pack( pixels,
                             width,
                             height,
                             i*unitLength,
                             (i+1)*unitLength,
                             m_globalData,
                             m_objects,
                             m_lightData,
                             eyePos,
                             camera->getNear(),
                             invViewTransMat,
                             m_tree,
                             m_extends
                             );

        threads[settings.traceThreadNum-1].pack(
                    pixels,
                    width,
                    height,
                    (settings.traceThreadNum-1)*unitLength,
                    width*height,
                    m_globalData,
                    m_objects,
                    m_lightData,
                    eyePos,
                    camera->getNear(),
                    invViewTransMat,
                    m_tree,
                    m_extends
                    );

        for( int i = 0; i < settings.traceThreadNum; i++ )
            threads[i].start();

        for( int i = 0; i < settings.traceThreadNum; i++ )
            threads[i].wait();

        delete []threads;
    }
    else
    {
        doRayTrace( pixels,
                    width,
                    height,
                    0,
                    width*height,
                    m_globalData,
                    m_objects,
                    m_lightData,
                    eyePos,
                    camera->getNear(),
                    invViewTransMat,
                    m_tree,
                    m_extends
                    );
    }
}

