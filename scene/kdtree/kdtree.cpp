#include "kdtree.h"
#include <fstream>

KdTree::KdTree()
{
    m_allocated = false;
    m_root = NULL;
    m_splitList = NULL;
    m_splitPool = NULL;
    m_kdPtr = NULL;
    m_objPtr = NULL;
    m_kdMem = NULL;
    m_objMem = NULL;

    allocateMem();
    m_root = newKdTreeNode();
}

KdTree::~KdTree()
{
    freeMem();
}

// Review passed
void KdTree::build( Scene *scene )
{
    if( !m_allocated )
        assert(0);

    QVector<SceneObject*> objects = scene->getObjectPointers();

    int objectCount = objects.size();
    AABB extends = scene->getExtends();

    QVector<SceneObject*>::Iterator iter;
    for ( iter = objects.begin(); iter != objects.end(); iter++)
        m_root->add( (*iter), this );
    m_root->setAABB( scene->getExtends() );

    // Build the list
    // COF: why plus 8
    SplitNode* header;
    header= new SplitNode[objectCount * 2+1];
    m_splitPool = header;
    int i = 0;
    for ( ;i < (objectCount * 2); i++ )
        m_splitPool[i].next = &m_splitPool[i + 1];
    m_splitPool[i].next = 0;

    // Init an empty split list
    m_splitList = 0;
    if( objectCount > 2 )
    {
        m_root->setLeaf(false);
        subdivide( m_root, extends, 0, objectCount );
    }
    // Release the memory
    if( header )
        delete []header;
}

// Review passed
void KdTree::insertSplitPos( float splitPos )
{
    SplitNode* newNode = m_splitPool; // Pointer to an unused split node
    m_splitPool = m_splitPool->next;
    newNode->next = 0;
    newNode->splitPos = splitPos;
    newNode->leftCount = 0;
    newNode->rightCount = 0;

    if (!m_splitList )
    {
        m_splitList = newNode;
    }
    else
    {
        // splitList is a sorted list whose node stores the split position
        // Sort
        if ( splitPos < m_splitList->splitPos ) // Add to the front
        {
            newNode->next = m_splitList;
            m_splitList = newNode;
        }
        else if ( splitPos == m_splitList->splitPos)
        {
            // Recycle this node
            newNode->next = m_splitPool;
            m_splitPool = newNode;
        }
        else
        {
            SplitNode* list = m_splitList;
            // Find the appropriate pos to insert
            while ((list->next) && (splitPos  >= list->next->splitPos))
            {
                if (splitPos == list->next->splitPos)
                {
                    // Recycle this node
                    newNode->next = m_splitPool;
                    m_splitPool = newNode;
                    return;
                }
                list = list->next;
            }
            // Still works when list->next is NULL
            newNode->next = list->next;
            list->next = newNode;
        }
    }
}

void KdTree::subdivide( KdTreeNode *node, AABB aabb, int depth, int objCount )
{
    // recycle used split nodes
    if (m_splitList)
    {
        SplitNode* list = m_splitList;
        while (list->next)
            list = list->next;
        list->next = m_splitPool;
        m_splitPool = m_splitList;
        // Reset the split list
        m_splitList = 0;
    }

    // Find the split axis, we split the aixs of maximum size
    Vector3 s = aabb.getSize(); // Get the size
    int axis;
    if ( (s.x >= s.y) && (s.x >= s.z) ) // Split x
        axis = 0;
    else if ( (s.y >= s.x) && (s.y >= s.z) ) // Split y
       axis = 1; // y axis
    else // Split z
        axis = 2;  // z axis
    node->setAxis( axis );

    // make a list of the split position candidates
    ObjectNode* objNodes = node->getObjectList();

    float posStart = aabb.getPos().xyz[axis];
    float posEnd = aabb.getPos().xyz[axis] + aabb.getSize().xyz[axis];
    float* eleft = new float[objCount];
    float* eright = new float[objCount];
    SceneObject** parray = new SceneObject*[objCount];
    int id = 0;
    while (objNodes)
    {
        SceneObject* p = parray[id] = objNodes->getObject();
        calculateAABBRange( p->m_boundingBox, eleft[id], eright[id], axis );

        // Insert all of the split positions
        if( eleft[id] >= posStart && eleft[id] <= posEnd )
            insertSplitPos( eleft[id] );
        if( eright[id] >= posStart && eright[id] <= posEnd )
            insertSplitPos( eright[id] );
        id++;
        // Get next one
        objNodes = objNodes->getNext();
    }
    // Calculate left count and right count for each split choice
    AABB leftAABB, rightAABB;
    // Need to do this to give the initial value of axis other than the axis we gonna split
    AABB leftAABBTmp = aabb, rightAABBTmp = aabb;
    SplitNode* splist = m_splitList;
    float leftAABBStartTmp = aabb.getPos().xyz[axis];
    float rightAABBEndTmp = aabb.getPos().xyz[axis] + aabb.getSize().xyz[axis];
    while ( splist )
    {
        rightAABBTmp.getPos().xyz[axis] = splist->splitPos;
        rightAABBTmp.getSize().xyz[axis] = posEnd - splist->splitPos;
        leftAABBTmp.getSize().xyz[axis] = splist->splitPos - posStart;

        //SUB: float leftAABBEndTmp =splist->splitPos;
        float leftAABBEndTmp = leftAABBTmp.getPos().xyz[axis] + leftAABBTmp.getSize().xyz[axis];
        //SUB:splist->splitPos;
        float rightAABBStartTmp = rightAABBTmp.getPos().xyz[axis];

        /*
         *Intersect problematic
         */
        for ( int i = 0; i < objCount; i++ )
        {
                SceneObject* p = parray[i];
                // SUB
                if ((eleft[i] <= leftAABBEndTmp) && (eright[i] >= leftAABBStartTmp))
                {
                    if (p->m_boundingBox.intersectAABB(  leftAABBTmp  ))
                        splist->leftCount++;
                }
                // SUB
                if ((eleft[i] <= rightAABBEndTmp) && (eright[i] >= rightAABBStartTmp ))
                {
                    if (p->m_boundingBox.intersectAABB( rightAABBTmp ))
                        splist->rightCount++;
                }
        }
        splist = splist->next;
    }
    // calculate surface area for current node
    float SAV = 1.f / calculateSA( aabb );
    // calculate cost for not splitting
    float costNoSplit = objCount;
    // determine optimal split plane position
    splist = m_splitList;
    float min = POS_INF;
    float bestpos = 0;

    leftAABBTmp = rightAABBTmp = aabb;
    while (splist)
    {
        // calculate child node extends
         rightAABBTmp.getPos().xyz[axis] = splist->splitPos;
         rightAABBTmp.getSize().xyz[axis] = posEnd - splist->splitPos;
        leftAABBTmp.getSize().xyz[axis] = splist->splitPos - posStart;
        // calculate child node cost
        float SA1 = calculateSA( leftAABBTmp );
        float SA2 = calculateSA( rightAABBTmp );
        float splitcost = 0.3f + 1.0f * (SA1 * SAV * splist->leftCount + SA2 * SAV * splist->rightCount );
        // update best cost tracking variables
        if (splitcost < min)
        {
            min = splitcost;
            bestpos = splist->splitPos;

            // Record the best left AABB and right AABB
            leftAABB = leftAABBTmp;
            rightAABB =  rightAABBTmp;
        }
        splist = splist->next;
    }

    if ( min > costNoSplit)
    {
        node->setLeaf( true );
        return;
    }

    node->setSplitPos( bestpos );
    // construct child nodes
    KdTreeNode* left = newKdTreeNodePair();
    KdTreeNode* right = left + 1;

    // COF: total, useless?
    int leftCount, rightCount, totalCount;
    leftCount = rightCount = totalCount = 0;
    // assign primitives to both sides
    float leftAABBStart = leftAABB.getPos().xyz[axis];
    float leftAABBEnd = leftAABB.getPos().xyz[axis] + leftAABB.getSize().xyz[axis];
    float rightAABBStart = rightAABB.getPos().xyz[axis];
    float rightAABBEnd = rightAABB.getPos().xyz[axis] + rightAABB.getSize().xyz[axis];

    for ( int i = 0; i < objCount; i++ )
    {
        SceneObject* p = parray[i];
        totalCount++;

        // TIG
        if ((eleft[i] <= leftAABBEnd) && (eright[i] >=  leftAABBStart))
        {
            if (p->m_boundingBox.intersectAABB( leftAABB ))
            {
                left->add( p, this );
                leftCount++;
            }
        }

        // TIG
        if ((eleft[i] <=  rightAABBEnd) && (eright[i] >= rightAABBStart ))
        {
            if (p->m_boundingBox.intersectAABB( rightAABB ))
            {
                right->add( p, this );
                rightCount++;
            }
        }
    }

    // Release
    if( eleft )
        delete []eleft;
    if( eright )
        delete []eright;
    if( parray )
        delete []parray;

    left->setAABB( leftAABB );
    right->setAABB( rightAABB );
    node->setLeft( left );
    node->setRight(right);
    node->setLeaf( false );
    if (depth < MAX_TREE_DEPTH)
    {
        if (leftCount > 2)
            subdivide( left, leftAABB, depth + 1, leftCount);
        if (rightCount > 2)
            subdivide( right, rightAABB, depth + 1, rightCount );
    }
}

ObjectNode* KdTree::newObjectNode()
{
    ObjectNode* retval;
    retval = m_objPtr;
    m_objPtr = m_objPtr->getNext();
    retval->setNext( NULL );
    retval->setObject( NULL );
    return retval;
}

KdTreeNode* KdTree::newKdTreeNodePair()
{
    *m_kdPtr = KdTreeNode();
    *(m_kdPtr+1) = KdTreeNode();
    KdTreeNode* node = m_kdPtr;
    m_kdPtr += 2;
    return node;
}

KdTreeNode* KdTree::newKdTreeNode()
{
    *m_kdPtr = KdTreeNode();
    KdTreeNode* node = m_kdPtr;
    m_kdPtr+=1;
    return node;
}

void KdTree::allocateMem()
{
    // m_kdMem is used to hold all of the child nodes
    m_kdMem = (new KdTreeNode[KDTREE_ARRAY_SIZE]);
    m_objMem= (new ObjectNode[KDTREE_ARRAY_SIZE]);

    m_kdPtr = m_kdMem;
    m_objPtr = m_objMem;

    ObjectNode* ptr = m_objPtr;
    for ( int i = 0; i < KDTREE_ARRAY_SIZE; i++ )
    {
        ptr->setNext( ptr + 1 );
        ptr++;
    }
    ptr->setNext( NULL );

    m_allocated = true;
}

void KdTree::freeObjectNode( ObjectNode* node )
{
    ObjectNode* nodeToFree = node;
    while (nodeToFree->getNext()) nodeToFree= nodeToFree->getNext();
    nodeToFree->setNext( m_objPtr );
    m_objPtr = node;
}

void KdTree::freeMem()
{
    if( m_kdMem )
        delete []m_kdMem;
    if( m_objMem )
        delete []m_objMem;
}

// Review passed
void KdTree::calculateAABBRange( AABB aabb, float& left, float& right, const int axis )
{
    // Invalid axis
    if( axis > 2 || axis < 0 )
        assert(0);

    left = aabb.getPos().xyz[axis];
    right = aabb.getPos().xyz[axis] + aabb.getSize().xyz[axis];
}

void dumpKdTreeInfo( KdTree* tree)
{
    std::ofstream out("./output/kdtree.txt");
    if(! out.is_open() )
    {
        cerr<<"Cannot open file kdtree.txt"<<endl;
        return;
    }
    if( !tree )
    {
        cerr<<"Tree is not initialized"<<endl;
        return;
    }
    KdTreeNode* root = tree->getRoot();
    AABB extends = root->getAABB();
    out<<"Extends: "<<endl<<extends.getPos().x<<" "<<extends.getPos().y<<" "
      <<extends.getPos().z<<endl;
    out<<(extends.getPos()+extends.getSize()).x<<" "
      <<(extends.getPos()+extends.getSize()).y<<" "
        <<(extends.getPos()+extends.getSize()).z<<endl;

    dumpKdTreeInfoLeaf( root, out, 0 );
}

void dumpKdTreeInfoLeaf( KdTreeNode* node, std::ofstream& ofile, int depth )
{
    if( !node )
        return;

    for( int i = 0; i < depth; i++ )
    {
        ofile<<"    ";
    }
    ofile<<"Node:   "<<" depth "<<depth
        <<" Leaf "<<(node->isLeaf()?"true ":"false ")
      <<" axis "<<node->getAxis()
     <<" splitpos "<<node->getSplitPos()
     <<endl<<endl;
    if( node->isLeaf() )
    {
        // If it is a leaf, dump the objects
        ObjectNode* obj = node->getObjectList();
        ofile<<" obj list: ";
        while( obj )
        {
            ofile <<"("<< obj->getObject()->m_primitive.type<<") ";
            obj = obj->getNext();
        }
        return;
    }
    if( node->getLeft() )
    {
        dumpKdTreeInfoLeaf( node->getLeft(), ofile, depth+1 );
    }
    if( node->getRight())
    {
        dumpKdTreeInfoLeaf( node->getRight(), ofile, depth+1);
    }
}
