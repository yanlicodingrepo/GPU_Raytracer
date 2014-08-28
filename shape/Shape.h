/*!
   @file   Shape.h
   @author Yan Li (yan_li@brown.edu)
   @date   Fall 2012
*/

#ifndef SHAPE_H
#define SHAPE_H

#include <CS123Common.h>
#include "CS123Algebra.h"
#include "vector.h"
#include <QtOpenGL>

struct Vertex
{
    Vector3 position;
    Vector3 normal;
    float u,v;
};

//! A structure to store triangle
struct triangle
{
    Vertex p1;
    Vertex p2;
    Vertex p3;
};


/**

 @class Shape.h

 @brief This is the superclass for all shapes.

 @author  Yan Li(yan_li@brown.edu)
 @date    Fall 2012

*/

class Shape{
public:
    Shape( int p1, int p2, float p3);
    virtual ~Shape();

    //! Make triangles, need to be implemented in subclasses
    virtual void makeTriangles() = 0;

    void releaseTriangles();

    //! The draw function for drawing all shapes
    void glDrawVertex();

    triangle* getTriangles();

    int getTriangleSize();

    virtual void setParameter1( const int p1 );

    virtual void setParameter2( const int p2 );

    void setParameter3( const float p3 );

    int getParameter1();

    int getParameter2();

    float getParameter3();

    void loadTexture(const QString& path);

protected:


    int m_parameter1;
    int m_parameter2;
    float m_parameter3;

    //! triangle list
    triangle *m_triangles;
    int m_triangleSize;
    GLuint m_textureID;
};

#endif // SHAPE_H
