/*!
    @file kdtreelist.h
    @author: yanli
    @date: May 2013
 */

#ifndef KDTREECOMMON_H
#define KDTREECOMMON_H

#include "scene.h"

// Review passed
// SplitNode structure
struct SplitNode
{
    float splitPos; // Split position
    int leftCount; // Objects count in the left side
    int rightCount; // Objects count in the right side
    SplitNode* next; // Next splitPos
};

// Review passed
// ObjectNode structure
class ObjectNode
{
public:
    ObjectNode() : m_object( NULL ), m_next( NULL ) {}
    ~ObjectNode() { }
    void setObject( SceneObject* obj ) { m_object = obj; }
    SceneObject* getObject() { return m_object; }
    void setNext( ObjectNode* next ) { m_next = next; }
    ObjectNode* getNext() { return m_next; }
private:
    SceneObject* m_object;
    ObjectNode* m_next;
};

#endif // KDTREECOMMON_H
