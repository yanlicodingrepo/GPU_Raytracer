/*!
    @file sphere_intersect.h
    @author: yanli
    @date: May 2013
 */

#ifndef SPHERE_INTERSECT_H
#define SPHERE_INTERSECT_H

#include "CS123SceneData.h"
#include <qgl.h>
#include "CS123Common.h"
#include "vector.h"
#include "scene.h"

REAL doIntersectUnitSphere(
                            const Vector4& eyePos,
                            const Vector4& d
                            );

Vector3 getSphereNorm(
         const Vector4& intersectPoint
        );

CS123SceneColor getSphereIntersectTexColor( const SceneObject& object,
                                          const Vector4& intersectPoint
                                          );

#endif
