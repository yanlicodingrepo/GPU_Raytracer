
#ifndef SCENE_H
#define SCENE_H

#include <CS123Algebra.h>
#include "CS123SceneData.h"
#include "aabb.h"

#include <qgl.h>
#include <QHash>

class KdTree;
class KdTreeNode;
class View3D;
class Camera;
class CS123ISceneParser;
struct VboHandles;

struct TexInfo
{
    int m_mapIndex;
    GLuint m_textureHandle;
    unsigned *m_texPointer; // Point to the actual data of texture
    int m_texWidth; // The width of texture;
    int m_texHeight; // The height of texture
};

class SceneObject
{
public:
    SceneObject();
    ~SceneObject();
    Matrix4x4 m_transform;
    Matrix4x4 m_invTransform;
    Matrix4x4 m_invTTransformWithoutTrans;
    CS123ScenePrimitive m_primitive;
    AABB m_boundingBox;
    int m_textureMapID;
    int m_arrayID;
    TexInfo m_texture;
};

class Scene
{
public:

    Scene();

    Scene(Scene& s);
    virtual ~Scene();

    void render( View3D* context );

    static void parse(Scene *sceneToFill, CS123ISceneParser *parser);

    static void recursiveParseNode( Scene *sceneToFill, CS123SceneNode *node, Matrix4x4 transform );

    inline const CS123SceneGlobalData & getGlobal() { return m_globalData; }
    inline const QList<CS123SceneLightData> & getLight() { return m_lightData; }
    inline const QVector<SceneObject> & getObjects() { return m_objects; }
    inline QVector<SceneObject>* getObjectPointer() { return &m_objects; }
    inline QVector<SceneObject*> getObjectPointers()
    { QVector<SceneObject*> result;
        for(int i = 0; i < m_objects.size(); i++ )
            result.push_back( &m_objects[i] );
        return result;
    }
    inline QMap<int, TexInfo> getTexMap(){return m_textureMap; }
    inline AABB getExtends(){ return m_extends; }
    inline KdTree* getKdTree(){ return m_tree; }

    void setLights();

    void initExtends();

    void buildKdTree();

    void dumpKdTree();

private:

    void drawPrimitive( PrimitiveType type, const VboHandles* vbos, GLuint texHandle );

    void drawPrimitiveNormals( PrimitiveType type, const VboHandles* vbos );

    void renderGeometry( bool useMaterials, const VboHandles* vbos );

    void applyMaterial( const CS123SceneMaterial &material );



    void setLight( const CS123SceneLightData &light );

    void renderNormals( const VboHandles* vbos );

    void renderKdTree();

    void renderKdTreeLeaf(  KdTreeNode* node );

protected:

    /*! Adds a primitive to the scene. */
    virtual void addPrimitive(const CS123ScenePrimitive &scenePrimitive, const Matrix4x4 matrix);

    /*! Adds a light to the scene. */
    virtual void addLight(const CS123SceneLightData &sceneLight);

    /*! Sets the global data for the scene. */
    virtual void setGlobal(const CS123SceneGlobalData &global);


    CS123SceneGlobalData m_globalData;
    QList<CS123SceneLightData> m_lightData;

    QVector<SceneObject> m_objects;

    QMap<int, TexInfo> m_textureMap;
    QMap<QString, TexInfo> m_texInfoMap;
    int m_mapEnd;

    AABB m_extends;
    KdTree* m_tree;

};

#endif // SCENE_H
