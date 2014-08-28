/*!
    @file cylinder_intersect.h
    @author: yanli
    @date: May 2013
 */

#ifndef CYLINDER_INTERSECT_H
#define CYLINDER_INTERSECT_H

#include "CS123SceneData.h"
#include <qgl.h>
#include "CS123Common.h"
#include "vector.h"
#include "scene.h"

REAL doIntersectUnitCylinder(
                              const Vector4& eyePos,
                              const Vector4& d,
                              int& faceIndex
                              );

Vector3 getCylinderNorm(
        const Vector4& intersectPoint,
        const int faceIndex
        );

CS123SceneColor getCylinderIntersectTexColor(const SceneObject& object,
                                             const int index,
                                             const Vector4& intersect
                                          );
#endif
