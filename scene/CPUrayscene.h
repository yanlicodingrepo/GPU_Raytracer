/*!
    @file CPUCPURayScene.h
    @author: yanli
    @date: May 2013
 */

#ifndef CPURayScene_H
#define CPURayScene_H

#include "scene.h"
#include "aabb.h"

#define THREAD_NUM 8

class View2D;
class OrbitCamera;
class KdTree;

class CPURayScene
{
public:
    CPURayScene();
    CPURayScene( Scene* scene );
    ~CPURayScene();

    // Trace scene and output the result to view2D
    void traceScene( View2D* view2D,
                     OrbitCamera* camera,
                     int width,
                     int height
                     );
private:
protected:

    CS123SceneGlobalData m_globalData;
    QList<CS123SceneLightData> m_lightData;

    QVector<SceneObject> m_objects;

    KdTree* m_tree;
    AABB m_extends;
};

#endif // CPURayScene_H
