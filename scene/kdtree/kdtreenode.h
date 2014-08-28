/*!
    @file kdtreenode.h
    @author: yanli
    @date: May 2013
 */

#ifndef KDTREENODE_H
#define KDTREENODE_H

#include "kdtreecommon.h"

class KdTree;

// Review passed
class KdTreeNode
{
public:
    KdTreeNode();
    ~KdTreeNode(){}
    inline void setAxis( int axis ) { m_axis = axis; }
    inline int getAxis() { return m_axis; }
    inline void setSplitPos( float pos ) { m_split = pos; }
    inline float getSplitPos() { return m_split; }
    inline void setLeft( KdTreeNode* left ) { m_left = left; }
    inline void setRight( KdTreeNode* right ) { m_right = right; }
    inline  KdTreeNode* getLeft() { return m_left;  }
    inline KdTreeNode* getRight() { return m_right; }
    void add( SceneObject* object, KdTree* kdtree );
    inline  bool isLeaf() { return m_leaf; }
    inline   void setLeaf( bool leaf ) { m_leaf = leaf; }
    inline  ObjectNode* getObjectList() { return  m_objList; }
    inline   void setObjectList( ObjectNode* node ) { m_objList = node; }
    inline void setAABB( AABB box ){ m_box = box; }
    inline AABB getAABB(){return m_box; }

private:

    AABB m_box;
    float m_split;
    bool m_leaf;
    int m_axis;
    KdTreeNode* m_left;
    KdTreeNode* m_right;
    ObjectNode* m_objList;
};

#endif // KDTREENODE_H
