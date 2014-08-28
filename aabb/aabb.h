/*!
    @file aabb.h
    @author: yanli
    @date: May 2012
 */

#ifndef AABB_H
#define AABB_H

#include "vector.h"
#include "CS123Algebra.h"

class AABB
{
public:
    AABB() : m_pos( Vector3( 0, 0, 0 ) ), m_size( Vector3( 0, 0, 0 ) ) {}
    AABB( Vector3 pos, Vector3 size ) : m_pos( pos ), m_size( size ) {}
    inline Vector3& getPos() { return m_pos; }
    inline Vector3& getSize() { return m_size; }
    // Find if the bounding box intersect the other one
    bool intersectAABB( AABB& b2 )
    {
        Vector3 v1 = b2.getPos(), v2 = b2.getPos() + b2.getSize();
        Vector3 v3 = m_pos, v4 = m_pos + m_size;
        return ((v4.x >= v1.x) && (v3.x <= v2.x) && // x-axis overlap
                (v4.y >= v1.y) && (v3.y <= v2.y) && // y-axis overlap
                (v4.z >= v1.z) && (v3.z <= v2.z));   // z-axis overlap
    }

    // Find if the pos is inside the bounding box
    bool contains( Vector3 pos )
    {
        Vector3 v1 = m_pos, v2 = m_pos + m_size;
        return ((pos.x >= v1.x) && (pos.x <= v2.x) &&
                (pos.y >= v1.y) && (pos.y <= v2.y) &&
                (pos.z >= v1.z) && (pos.z <= v2.z));
    }

    inline float w() { return m_size.x; }
    inline float h() { return m_size.y; }
    inline float d() { return m_size.z; }
    inline float x() { return m_pos.x; }
    inline float y() { return m_pos.y; }
    inline float z() { return m_pos.z; }
private:
    Vector3 m_pos, m_size;
};

AABB computeCubeAABB(Matrix4x4 transform );
AABB computeSphereAABB(Matrix4x4 transform );
AABB computeConeAABB(Matrix4x4 transform );
AABB computeCylinderAABB(Matrix4x4 transform );
AABB computeMeshAABB(Matrix4x4 transform );

void drawAABB( AABB& aabb, float color[3] );

#endif
