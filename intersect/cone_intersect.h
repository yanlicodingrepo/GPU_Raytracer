/*!
    @file cone_intersect.h
    @author: yanli
    @date: May 2013
 */

#ifndef CONE_INTERSECT_H
#define CONE_INTERSECT_H

#include "CS123SceneData.h"
#include <qgl.h>
#include "CS123Common.h"
#include "vector.h"
#include "scene.h"

REAL doIntersectUnitCone(
                          const Vector4& eyePos,
                          const Vector4& d,
                          int& faceIndex
                          );

Vector3 getConeNorm(
        const Vector4& intersectPoint,
        const int faceIndex
        );

CS123SceneColor getConeIntersectTexColor( const SceneObject& object,
                                          const int faceIndex,
                                          const Vector4& intersect
                                          );
#endif
