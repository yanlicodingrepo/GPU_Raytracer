/*!
    @file plane_intersect.h
    @author: yanli
    @date: May 2013
 */


#ifndef PLANE_INTERSECT_H
#define PLANE_INTERSECT_H

#include "CS123Common.h"
#include "CS123Algebra.h"
#include "vector.h"

REAL doIntersectPlane( const Vector3& point, const Vector3& norm, const Vector4& eyePos, const Vector4& d);

#endif // PLANE_INTERSECT_H
