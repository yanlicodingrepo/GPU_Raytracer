#ifndef RESOURCELOADER_H
#define RESOURCELOADER_H

#include <QString>
#include <qgl.h>

GLuint loadTexture(const QString &path, float blend = -1 );
void createTexture( GLuint *texName, const int sizeX, const int sizeY );
bool loadBMPTexture( GLuint* texName, const char* filename );

#endif // RESOURCELOADER_H
