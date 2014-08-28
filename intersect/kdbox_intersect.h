/*!
    @file kdbox_intersect.h
    @author: yanli
    @date: May 2013
 */

#ifndef KDBOX_INTERSECT_H
#define KDBOX_INTERSECT_H

#include "CS123Common.h"
#include "CS123Algebra.h"
#include "aabb.h"

void doIntersectRayKdBox(
        const Vector4& eyePos,
        const Vector4& d,
        REAL& near,
        REAL& far,
        AABB box
        );

#endif // KDBOX_INTERSECT_H
