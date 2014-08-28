#ifndef POS_CHECK_H
#define POS_CHECK_H

#include "CS123SceneData.h"
#include <QVector>
#include "scene.h"
#include <QMap>
// Check if the pos is inside any objects, return a list of all the objects which the pos is inside
QVector<SceneObject>
checkPos(const QVector<SceneObject>& objects, const Vector4& pos, QMap<int, int>& indexMap );

bool checkCube( const Vector4& posInObjSpace );
bool checkCylinder( const Vector4& posInObjSpace  );
bool checkCone( const Vector4& posInObjSpace );
bool checkSphere( const Vector4& posInObjSpace );

#endif // POS_CHECK_H
