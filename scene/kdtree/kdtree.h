/*!
    @file kdtree.h
    @author: yanli
    @date: May 2013
 */

#ifndef KDTREE_H
#define KDTREE_H

#include "kdtreecommon.h"
#include "kdtreenode.h"
#include "aabb.h"
#include "scene.h"

#define MAX_TREE_DEPTH 32
#define KDTREE_ARRAY_SIZE 100000
// Review passed
class KdTree
{
public:
    KdTree();
    ~KdTree();
    void build( Scene* scene );
    inline KdTreeNode* getRoot() { return m_root; }
    inline void setRoot( KdTreeNode* root ) { m_root = root; }
    // tree generation
    void insertSplitPos( float splitPos );
    void subdivide( KdTreeNode* node, AABB aabb, int depth, int objCount );
    ObjectNode* newObjectNode();
    KdTreeNode* newKdTreeNodePair();
    KdTreeNode* newKdTreeNode();

    KdTreeNode* getKdTreeNodeArray() { return m_kdMem; }
    ObjectNode* getObjectNodeArray() { return m_objMem; }

private:
    // Memory operations
    void allocateMem();

    void freeObjectNode( ObjectNode* node );

    void freeMem();

    void calculateAABBRange( AABB aabb, float& left, float& right, const int axis );

    inline float calculateSA( AABB aabb ){ return 2 * (aabb.w() * aabb.d() + aabb.w() * aabb.h() + aabb.d() * aabb.h()); }

private:
    bool m_allocated;

    KdTreeNode* m_root; // Pointer to the root node
    SplitNode* m_splitList; // Pointer to the split list
    SplitNode*m_splitPool; // Pointer to the empty split node

private:

    KdTreeNode* m_kdPtr;
    ObjectNode* m_objPtr;

     KdTreeNode* m_kdMem; // Pointer to the memory of all the nodes in byte
    ObjectNode* m_objMem; // Pointer to the memory of all the object nodes in byte
};

void dumpKdTreeInfo( KdTree* tree );
void dumpKdTreeInfoLeaf( KdTreeNode* node, std::ofstream& ofile, int depth );

#endif
