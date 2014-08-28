#ifndef INTERSECT_H
#define INTERSECT_H

#include "cone_intersect.h"
#include "cube_intersect.h"
#include "sphere_intersect.h"
#include "cylinder_intersect.h"
#include "plane_intersect.h"

#include "aabb.h"
#include "CS123Common.h"
#include "CS123Algebra.h"
#include "CS123SceneData.h"
#include "scene.h"

class KdTree;

REAL
intersect( const Vector4& eyePos,
           const QVector<SceneObject>& objects,
           const Vector4& d,
           int& objectIndex,
           int& faceIndex,
            KdTree* tree,
            AABB extends,
           bool refract = false
           );

REAL
doIntersect(const SceneObject &object,
            const Vector4& eyePos,
            const Vector4& d,
           int& faceIndex
            );

#endif // INTERSECT_H
