#include "kdtreenode.h"
#include "kdtree.h"

KdTreeNode::KdTreeNode(){
    m_left = NULL;
    m_right = NULL;
    m_leaf = true;
    m_objList = NULL;
    m_split = 0;
}

// Review passed
void KdTreeNode::add( SceneObject *object, KdTree* kdtree )
{
    // Always push the new node to the front of the list
    ObjectNode* node = kdtree->newObjectNode();
    node->setObject( object );
    node->setNext( getObjectList() );
    setObjectList( node );
}
