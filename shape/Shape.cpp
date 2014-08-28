/*!
   @file   Shape.cpp
   @author Yan Li(yan_li@brown.edu)
   @date   Fall 2012

   @brief  Implementation of common functionality of shapes
*/

#include "Shape.h"
#include <qgl.h>

Shape::Shape( int p1, int p2, float p3 )
{
    m_parameter1 = p1;
    m_parameter2 = p2;
    m_parameter3 = p3;

    m_triangles = NULL;
    m_triangleSize = 0;
    m_textureID = 0;
}

Shape::~Shape()
{
    releaseTriangles();
    if( m_textureID != 0 )
    {
           glDeleteTextures(1,&m_textureID );
    }
}

void Shape::releaseTriangles()
{
    if( m_triangles )
    {
        delete []m_triangles;
        m_triangles = NULL;
        m_triangleSize = 0;
    }
}

void Shape::glDrawVertex()
{

    if( m_textureID != 0 )
    {
        glEnable(GL_TEXTURE_2D);
       glBindTexture(GL_TEXTURE_2D,m_textureID );
    }

    glBegin(GL_TRIANGLES);
    for( int i = 0; i < m_triangleSize; i++ )
   {
        glNormal3f( m_triangles[i].p1.normal.x, m_triangles[i].p1.normal.y, m_triangles[i].p1.normal.z);
        if( m_textureID != 0)
            glTexCoord2f( m_triangles[i].p1.u, m_triangles[i].p1.v );
        glVertex3f( m_triangles[i].p1.position.x, m_triangles[i].p1.position.y, m_triangles[i].p1.position.z );

        glNormal3f( m_triangles[i].p2.normal.x, m_triangles[i].p2.normal.y, m_triangles[i].p2.normal.z);

        if( m_textureID != 0 )
            glTexCoord2f( m_triangles[i].p2.u, m_triangles[i].p2.v );
        glVertex3f( m_triangles[i].p2.position.x, m_triangles[i].p2.position.y, m_triangles[i].p2.position.z );

        glNormal3f( m_triangles[i].p3.normal.x, m_triangles[i].p3.normal.y, m_triangles[i].p3.normal.z);

        if( m_textureID != 0 )
            glTexCoord2f( m_triangles[i].p3.u, m_triangles[i].p3.v );

        glVertex3f( m_triangles[i].p3.position.x, m_triangles[i].p3.position.y, m_triangles[i].p3.position.z );
    }
    glEnd();

    if( m_textureID != 0 )
    {
        glDisable( GL_TEXTURE_2D );
    }
}


triangle* Shape::getTriangles()
{
    return m_triangles;
}

int Shape::getTriangleSize()
{
    return m_triangleSize;
}

void Shape::setParameter1( const int p1 )
{
    m_parameter1 = p1;
}

void Shape::setParameter2( const int p2 )
{
    m_parameter2 = p2;
}

void Shape::setParameter3( const float p3 )
{
    m_parameter3 = p3;
}

int Shape::getParameter1()
{
    return m_parameter1;
}

int Shape::getParameter2()
{
    return m_parameter2;
}

float Shape::getParameter3()
{
    return m_parameter3;
}

void Shape::loadTexture(const QString &path)
{
    if( m_textureID != 0 )
        glDeleteTextures(1,&m_textureID );

    QFile file(path);

    QImage image, texture;
    if(!file.exists())
    {
        m_textureID = 0;
        return ;
    }

    image.load(file.fileName());
    texture = QGLWidget::convertToGLFormat(image);
    texture = texture.mirrored(false,false);

    glEnable(GL_TEXTURE_2D);
    glGenTextures(1,&m_textureID);
    glBindTexture(GL_TEXTURE_2D,m_textureID );
    glTexImage2D(GL_TEXTURE_2D,0,3,texture.width(),texture.height(),0,GL_RGBA,GL_UNSIGNED_BYTE,texture.bits());
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
}
