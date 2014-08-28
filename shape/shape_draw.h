/*!
    @file shapeDraw.h
    @author: yanli
    @date: May 2013
 */

#ifndef SHAPEDRAW_H
#define SHAPEDRAW_H

#include <qgl.h>

extern int cubeTess;
extern int sphereTess[2];
extern int cylinderTess;
extern int coneTess;

void buildCubeVBO( int tess, GLuint & vbo, GLuint & vboIndex );
void buildCylinderVBO( int tess, GLuint& vbo, GLuint& vboIndex );
void buildConeVBO( int tess, GLuint& vbo, GLuint& vboIndex );
void buildSphereVBO( int tess1, int tess2, GLuint& vbo, GLuint& vboIndex );

void drawCube( GLuint vbo, GLuint vboElement, GLuint texHandle = 0 );
void drawCylinder( GLuint vbo, GLuint vboElement, GLuint texHandle = 0 );
void drawCone( GLuint vbo, GLuint vboElement, GLuint texHandle = 0 );
void drawSphere( GLuint vbo, GLuint vboElement, GLuint texHandle = 0 );

void drawNormals( GLuint vbo, int vertNum );

#endif
