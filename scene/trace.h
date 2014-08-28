/*!
    @file trace.h
    @author: yanli
    @date: May 2013
 */

#ifndef TRACE_H
#define TRACE_H

#include "CS123Common.h"
#include "CS123Algebra.h"
#include "CS123SceneData.h"
#include "scene.h"

void doRayTrace(
        BGRA* data,
        const int width,
        const int height,
        const int beginIndex,
        const int endIndex,
        const CS123SceneGlobalData& global,
        QVector<SceneObject>& objects,
        const QList<CS123SceneLightData>& lights,
        const Vector4& eyePos,
        const float near,
        const Matrix4x4& invViewTransMat,
        KdTree* tree,
        AABB extends
        );

CS123SceneColor
recursiveTrace(
      const Vector4& pos,
      const Vector4& d,
      const CS123SceneGlobalData& global,
      QVector<SceneObject>& objects,
      const QList<CS123SceneLightData>& lights,
      KdTree* tree,
      AABB extends,
      int curIndex, // If the ray is inside an object, then this parameter will be the index of object
      int count
      );

CS123SceneColor
computeObjectColor(
        const int& objectIndex,
        QVector<SceneObject>& objects,
        const CS123SceneGlobalData& global,
        const QList<CS123SceneLightData>& lights,
        KdTree* tree,
        AABB extends,
        const Vector4& pos,
        const Vector3& norm,
        const Vector4& eyePos,
       const  CS123SceneColor& texture
        );
#endif // TRACE_H
