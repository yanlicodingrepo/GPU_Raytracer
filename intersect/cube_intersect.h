/*!
    @file cube_intersect.h
    @author: yanli
    @date: May 2013
 */

#ifndef CUBE_INTERSECT_H
#define CUBE_INTERSECT_H

#include "CS123SceneData.h"
#include <qgl.h>
#include "CS123Common.h"
#include "vector.h"
#include "scene.h"

REAL doIntersectUnitCube(
                          const Vector4& eyePos,
                          const Vector4& d,
                          int& faceIndex
                          );

Vector3 getCubeNorm(
        const int faceIndex
        );

CS123SceneColor getCubeIntersectTexColor( const SceneObject& object,
                                          const int faceIndex,
                                          const Vector4& intersect
                                          );
#endif
