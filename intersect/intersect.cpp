#include "intersect.h"
#include "kdbox_intersect.h"
#include "global.h"
#include "kdtree.h"
#include "kdtreenode.h"

#include "CL/cl.h"
#include <QVector>


QVector<KdTreeNodeHost> kdnode_test;
QVector<ObjectNodeHost> objnode_test;

/**
    GPU code, preserve for future test
  **/
/*
inline float getAxisElem4( cl_float4 vec, int axis )
{
    if( axis == 0 )
        return vec.x;
    else if( axis == 1 )
        return vec.y;
    else if( axis == 2 )
        return vec.z;
    else
        return -1;
}

bool checkRange( const cl_float4 intersect, const cl_float4 range, const int axis )
{
    bool result = false;
    switch( axis )
    {
    case 0: // X axis range
        if( intersect.y >= range.x && intersect.y <= range.y &&
                intersect.z >= range.z && intersect.z <= range.w )
          result = true;
        break;
    case 1: // Y axis range
        if( intersect.x >= range.x && intersect.x <= range.y &&
                intersect.z >= range.z && intersect.z <= range.w )
          result = true;
        break;
    case 2: // Z axis range
        if( intersect.x >= range.x && intersect.x <= range.y &&
                intersect.y >= range.z && intersect.y <= range.w )
          result = true;
        break;
    default:
        break;
    }
    return result;
}

float dot( cl_float3 f1, cl_float3 f2 )
{
    return f1.x*f2.x + f1.y*f2.y + f1.z*f2.z;
}

float doIntersectPlane( cl_float3 point, cl_float3 norm, cl_float4 eyePos, cl_float4 d)
{

    float t = -1;
    float denominator = (norm.x*d.x+norm.y*d.y+norm.z*d.z);
    if(fabs(denominator)>EPSILON)
    {
        cl_float3 eye3;
        eye3.x  =eyePos.x;
        eye3.y = eyePos.y;
        eye3.z = eyePos.z;
        t = (dot(norm, point)-dot(norm, eye3))/(denominator);
    }

    return t;
}

void doIntersectRayKdBox2(
        const cl_float4 eyePos,
        const cl_float4 d,
        float* near,
        float* far,
        const cl_float3 boxStart,
        const cl_float3 boxSize
    )
{
    *near = -1;
    *far = -1;
    cl_float3 start = boxStart;
    cl_float3 end;
    end .x = boxStart.x + boxSize.x;
    end .y = boxStart.y + boxSize.y;
    end .z = boxStart.z + boxSize.z;

    cl_float3 norm[3];
//    = {(cl_float3)(1,0,0), (cl_float3)(0,1,0), (cl_float3)(0,0,1) };
    norm[0].x = 1, norm[0].y = 0, norm[0].z = 0;
    norm[1].x = 0, norm[1].y = 1, norm[1].z = 0;
    norm[2].x = 0, norm[2].y = 0, norm[2].z = 1;

    cl_float4 range[3];
    range[0].x = start.y, range[0].y = end.y, range[0].z = start.z, range[0].w = end.z;
     range[1].x = start.x, range[1].y = end.x, range[1].z = start.z, range[1].w = end.z;
      range[2].x = start.x, range[2].y = end.x, range[2].z = start.y, range[2].w = end.y;
    float t[6];
    t[0] = doIntersectPlane( start, norm[0], eyePos, d );
    t[1] = doIntersectPlane( end, norm[0], eyePos, d );
    t[2] = doIntersectPlane( start, norm[1], eyePos, d );
    t[3] = doIntersectPlane( end, norm[1], eyePos, d );
    t[4] = doIntersectPlane( start, norm[2], eyePos, d );
    t[5] = doIntersectPlane( end, norm[2], eyePos, d );

    cl_float4 intersectPoint[6];
    float min = POS_INF;
    float max = -POS_INF;
    for( int i = 0; i < 6; i++ )
    {
        intersectPoint[i].x = eyePos.x + t[i]*d.x;
        intersectPoint[i].y = eyePos.y + t[i]*d.y;
        intersectPoint[i].z = eyePos.z + t[i]*d.z;
        intersectPoint[i].w = eyePos.w + t[i]*d.w;
        if( t[i] > 0 && checkRange( intersectPoint[i], range[i/2], i/2 ) && min > t[i] )
        {
            min = t[i];
            *near = t[i];
        }
        if( t[i] > 0 && checkRange( intersectPoint[i], range[i/2], i/2 ) && max < t[i] )
        {
            max = t[i];
            *far = t[i];
        }
    }
}

bool boxContain( const cl_float3 start, const cl_float3 size, const cl_float3 pos )
{
    cl_float3 v1 = start;
    cl_float3 v2;
    v2.x  = start.x  + size.x;
    v2.y  = start.y  + size.y;
    v2.z  = start.z  + size.z;
        return ((pos.x >= v1.x) && (pos.x <= v2.x) &&
                (pos.y >= v1.y) && (pos.y <= v2.y) &&
                (pos.z >= v1.z) && (pos.z <= v2.z));
}

cl_float4 add4( cl_float4 v1, cl_float4 v2 )
{
    cl_float4 result;
    result.x = v1.x + v2.x;
    result.y = v1.y + v2.y;
    result.z = v1.z + v2.z;
    result.w = v1.w + v2.w;
    return result;
}

cl_float3 add3( cl_float3 v1, cl_float3 v2 )
{
    cl_float3 result;
    result.x = v1.x + v2.x;
    result.y = v1.y + v2.y;
    result.z = v1.z + v2.z;
    return result;
}

cl_float3 mult3( float s,  cl_float3 v )
{
    cl_float3 result;
    result.x = s*v.x;
    result.y = s*v.y;
    result.z = s*v.z;
    return result;
}

cl_float4 mult4( float s,  cl_float4 v )
{
    cl_float4 result;
    result.x = s*v.x;
    result.y = s*v.y;
    result.z = s*v.z;
    result.w = s*v.w;
    return result;
}

*/
REAL
intersect( const Vector4& eyePos,
           const QVector<SceneObject>& objects,
           const Vector4& d,
           int& objectIndex,
           int& faceIndex,
           KdTree* tree,
           AABB extends,
           bool refract
           )
{
        REAL minT = POS_INF;
        REAL resultT = -1;
        int tempFaceIndex = -1;
        if( settings.useKdTree && tree && !refract )
        {
            assert( EQ( eyePos.w, 1) && EQ(d.w, 0) );

            REAL near, far;
            doIntersectRayKdBox( eyePos, d, near, far, extends );
            if( near <= 0&&far <= 0 )
                return -1;

            QVector<KdTreeNode*> nodeStack;
            KdTreeNode* current = tree->getRoot();
            while( current )
            {
                while( !current->isLeaf() )
                {
                    AABB curBox = current->getAABB();
                    REAL near, far;
                    doIntersectRayKdBox( eyePos, d, near, far, curBox );
                    int axis = current->getAxis();
                    float splitPos = current->getSplitPos();
                    if( near == far )  // inside the box
                        near = 0;
                    Vector4 nearPos = eyePos + d*near;
                    Vector4 farPos = eyePos + d*far;
                    if( nearPos.data[axis] <= splitPos  )
                    {
                        if( farPos.data[axis] <= splitPos )
                        {
                            current = current->getLeft();
                            continue;
                        }
                        KdTreeNode* right = current->getRight();
                        current = current->getLeft();

                        // Preserve the right
                        nodeStack.push_back( right );
                    }
                    else
                    {
                        if( farPos.data[axis] > splitPos )
                        {
                            current=current->getRight();
                            continue;
                        }
                        KdTreeNode* left = current->getLeft();
                        current = current->getRight();
                        nodeStack.push_back( left );
                    }
                }

                // Then we found an near leaf, find if there is intersect
                ObjectNode* objList = current->getObjectList();
                minT = POS_INF;
                while( objList )
                {
                    SceneObject* curObj =objList->getObject();
                    Matrix4x4 invCompMat = (*curObj).m_invTransform;

                    Vector4 eyePosObjSpace = invCompMat*eyePos;
                    Vector4 dObjSpace = invCompMat*d;

                    REAL t = doIntersect( *curObj, eyePosObjSpace, dObjSpace, tempFaceIndex);
                    if( t>0 && t < minT )
                    {
                        minT = t;
                        objectIndex = curObj->m_arrayID;
                        faceIndex = tempFaceIndex;
                    }
                    objList = objList->getNext();
                }
                Vector4 dst = (eyePos + minT*d);
                // Here we need to enlarge the bounding box a little bit
                AABB curBox = AABB( current->getAABB().getPos() - Vector3( EPSILON, EPSILON, EPSILON ),
                               current->getAABB().getSize() + 2*Vector3( EPSILON, EPSILON, EPSILON ));
                if( minT != POS_INF && curBox.contains(Vector3(dst.x, dst.y, dst.z ) ) )
                {
                    resultT = minT;
                    break;
                }
                // Else we need to get one node from the stack
                if( nodeStack.empty() )
                {
                    // No more nodes, meaning there is no intersect
                    break;
                }
                else
                {
                    current = nodeStack.at(nodeStack.size()-1);
                    nodeStack.pop_back();
                }
            }
            /**
                GPU code, preserve for future test
              **/
            /*
            float near, far;
            KdTreeNodeHost root = kdnode_test[0];
            cl_float4 eye4;
            eye4.x = eyePos.x;
            eye4.y = eyePos.y;
            eye4.z = eyePos.z;
            eye4.w = eyePos.w;
            cl_float4 d4;
            d4.x = d.x;
            d4.y = d.y;
            d4.z = d.z;
            d4.w = d.w;
            doIntersectRayKdBox2( eye4, d4, &near, &far, root.boxBegin, root.boxSize );
            if( near <= 0 && far <= 0 )
                return -1;
        //    else
         //      return 1;
            int nodeStack[1024];
            int stackTop = 0;
            int nextIndex = 0;

            while( nextIndex != -1 )
            {
                KdTreeNodeHost current = kdnode_test[nextIndex];

                while( !current.leaf )
                {
                    cl_float3 curBoxStart = current.boxBegin;
                    cl_float3 curBoxSize = current.boxSize;
                    float near, far;
                    doIntersectRayKdBox2( eye4, d4, &near, &far, curBoxStart, curBoxSize );
                    int axis = current.axis;
                    float splitPos = current.split;
                    if( near == far )  // inside the box
                        near = 0;
                    cl_float4 nearPos = add4(eye4, mult4(near, d4));
                    cl_float4 farPos = add4(eye4, mult4(far, d4));
                    if( getAxisElem4(nearPos, axis) <= splitPos  )
                    {
                        if( getAxisElem4(farPos, axis) <= splitPos )
                        {
                            //nextIndex = current.leftIndex;
                            current = kdnode_test[current.leftIndex];
                            continue;
                        }
                        nodeStack[stackTop++] = current.rightIndex;
                        current = kdnode_test[current.leftIndex];

                        // Preserve the right

                    }
                    else
                    {
                        if( getAxisElem4(farPos, axis) > splitPos )
                        {
                         //   nextIndex = current.rightIndex;
                            current = kdnode_test[current.rightIndex];
                            continue;
                        }
                        //KdTreeNodeHost left = kdnode_test[current.leftIndex];
                        nodeStack[stackTop++] = current.leftIndex;
                        current = kdnode_test[current.rightIndex];

                    }
                }

                // Then we found an near leaf, find if there is intersect
                int objIndex = current.objIndex;

                minT = POS_INF;

                while( objIndex != -1 )
                {
                    ObjectNodeHost objList = objnode_test[objIndex];
                    int sceneObjIndex = objList.objectIndex;

                    const SceneObject& curSceneObj = objects[sceneObjIndex];

                    Matrix4x4 invCompMat = curSceneObj.m_invTransform;

                    Vector4 eyePosObjSpace = invCompMat*eyePos;
                    Vector4 dObjSpace = invCompMat*d;

                    REAL t = doIntersect( curSceneObj, eyePosObjSpace, dObjSpace, tempFaceIndex);

                    if( t>0 && t < minT )
                    {
                        minT = t;
                        objectIndex = sceneObjIndex;
                        faceIndex = tempFaceIndex;
                    }
                    objIndex = objList.nextNodeIndex;
                  }


                //cl_float4 dst = add4(eye4,  mult4(minT, d4));
                Vector4 dst = eyePos + minT*d;
                // Here we need to enlarge the bounding box a little bit
                cl_float3 ep1;
                ep1.x = -EPSILON; ep1.y = -EPSILON; ep1.z = -EPSILON;
                cl_float3 ep2;
                ep2.x = 2*EPSILON; ep2.y = 2*EPSILON; ep2.z = 2*EPSILON;
                cl_float3 boxStart = add3(current.boxBegin , ep1);
                cl_float3 boxSize = add3(current.boxSize, ep2 );
                cl_float3 dst3;
                dst3.x = dst.x;
                dst3.y = dst.y;
                dst3.z = dst.z;

                if( minT != POS_INF && boxContain( boxStart, boxSize, dst3 ) )
                {
                    resultT = minT;
                    //resultT = 1;
                    break;
                }
                // Else we need to get one node from the stack
                if( stackTop == 0 )
                {
                    // No more nodes, meaning there is no intersect
                    int a = 0;
                    break;
                }
                else
                {
                    nextIndex = nodeStack[--stackTop];
                }
            }*/
        }
        else
        {
            for( int i = 0; i < objects.size(); i++ )
            {
                const SceneObject& curObj = objects[i];
                Matrix4x4 invCompMat = curObj.m_invTransform;

                Vector4 eyePosObjSpace = invCompMat*eyePos;
                Vector4 dObjSpace = invCompMat*d;

                REAL t = doIntersect( curObj, eyePosObjSpace, dObjSpace, tempFaceIndex);
                if( t>0 && t < minT )
                {
                    minT = t;
                    objectIndex = i;
                    faceIndex = tempFaceIndex;
                }
            }
            if( minT != POS_INF  )
            {
                resultT = minT;
            }
        }
        return resultT;
}

REAL
doIntersect(const SceneObject &object,
            const Vector4& eyePos,
            const Vector4& d,
            int& faceIndex
            )
{
    REAL t = -1;
    switch( object.m_primitive.type )
    {
    case PRIMITIVE_CUBE:
        {
            t = doIntersectUnitCube( eyePos, d, faceIndex );
            break;
        }
    case PRIMITIVE_CONE:
        {
            t = doIntersectUnitCone( eyePos, d, faceIndex );
            break;
        }
    case PRIMITIVE_CYLINDER:
        {
            t = doIntersectUnitCylinder( eyePos, d, faceIndex );
            break;
        }
    case PRIMITIVE_SPHERE:
        {
            t = doIntersectUnitSphere(  eyePos, d );
            break;
        }
    case PRIMITIVE_TORUS:
        {
            // not support torus
            //assert(0);
            break;
        }
    case PRIMITIVE_MESH:
        {
            // not support mesh
            //assert(0);
            break;
        }
    default:
        {
            assert(0);
            break;
        }
    }
    return t;
}

