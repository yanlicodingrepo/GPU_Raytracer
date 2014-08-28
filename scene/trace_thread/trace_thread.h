/*!
    @file trace_thread.h
    @author: yanli
    @date: May 2013
 */

#ifndef TRACE_THREAD_H
#define TRACE_THREAD_H

#include "CS123SceneData.h"
#include "trace.h"
#include "scene.h"
#include <QHash>
#include <QThread>

class KdTree;

class TraceThread : public QThread
{
    Q_OBJECT

public:
    TraceThread(QObject *parent = 0 );

    //! The mechanism for thread is like this: given a set of pixels from the canvas with a begin index and end index,
    //! do raytracing for the pixels in the range of that. Each thread is responsible for equivalent numbers
    //! all the necessary information will be copied in each thread.
    TraceThread(BGRA* pixel,
              const int width,
              const int height,
              const int beginIndex,
              const int endIndex,
              CS123SceneGlobalData& global,
              QVector<SceneObject>& objects,
              QList<CS123SceneLightData>& lights,
              Vector4& eyePos,
                const float near,
              Matrix4x4& invViewTransMat,
                KdTree* tree,
                AABB extends
                );

    void pack(
            BGRA* pixel,
            const int width,
            const int height,
            const int beginIndex,
            const int endIndex,
            CS123SceneGlobalData& global,
            QVector<SceneObject>& objects,
            QList<CS123SceneLightData>& lights,
            Vector4& eyePos,
            const float near,
            Matrix4x4& invViewTransMat,
            KdTree* tree,
            AABB extends
            );

    void render();
    ~TraceThread();

    //! Call run to do rendering
    void run();

signals:
protected:

private:
    BGRA* m_pixel;
    int m_width;
    int m_height;
    int m_beginIndex;
    int m_endIndex;
    CS123SceneGlobalData m_global;
    QVector<SceneObject> m_objects;
    QList<CS123SceneLightData> m_lights;
    /* QHash<GLuint, QImage> m_textureImages;*/
    Vector4 m_eyePos;
    float m_near;
    Matrix4x4 m_invViewTransMat;
    KdTree* m_tree;
    AABB m_extends;
};

#endif
