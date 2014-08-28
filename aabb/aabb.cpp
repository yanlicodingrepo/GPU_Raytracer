#include "aabb.h"
#include "CS123Common.h"
#include <qgl.h>

AABB computeCubeAABB(Matrix4x4 transform )
{
    AABB result;

    Vector4 vertices[8] =
    {
        Vector4( 0.5, 0.5, 0.5, 1 ),
        Vector4( 0.5, 0.5, -0.5, 1 ),
        Vector4( 0.5, -0.5, 0.5, 1 ),
        Vector4( 0.5, -0.5, -0.5, 1 ),
        Vector4( -0.5, 0.5, 0.5, 1 ),
        Vector4( -0.5, 0.5, -0.5, 1 ),
        Vector4( -0.5, -0.5, 0.5, 1 ),
        Vector4( -0.5, -0.5, -0.5, 1 )
    };

    Vector3 min = Vector3(POS_INF, POS_INF, POS_INF),  max = Vector3( -POS_INF, -POS_INF, -POS_INF );
    for( int i = 0; i < 8; i++ )
    {
        Vector4 tmp = transform*vertices[i];
        tmp = Vector4( tmp.x/tmp.w, tmp.y/tmp.w, tmp.z/tmp.w, 1 );
        if( tmp.x < min.x )
            min.x = tmp.x;
        if( tmp.y < min.y )
            min.y = tmp.y;
        if( tmp.z < min.z )
            min.z = tmp.z;

        if( tmp.x > max.x )
            max.x = tmp.x;
        if( tmp.y > max.y )
            max.y = tmp.y;
        if( tmp.z > max.z )
            max.z = tmp.z;
    }
    Vector3 size = max - min;
    result = AABB( min, size );
    return result;
}

// For sphere, we just use the method of Cube
AABB computeSphereAABB(Matrix4x4 transform )
{
    AABB result;
    Matrix4x4 tmp = transform;
    tmp.d = 0;tmp.h = 0; tmp.l = 0;//Ignore translation
    // If the matrix is rigid, we use a tight AABB
    if( checkOrthonormal( tmp ) )
    {
        Vector4 verticeOrigin = transform*Vector4(0,0,0,1);
        Vector4 verticeTop = transform*Vector4(0,0.5,0,1);
        Vector3 verticeOrigin3 = Vector3( verticeOrigin.x/verticeOrigin.w, verticeOrigin.y/verticeOrigin.w, verticeOrigin.z/verticeOrigin.w );
        Vector3 verticeTop3 = Vector3( verticeTop.x/verticeTop.w, verticeTop.y/verticeTop.w, verticeTop.z/verticeTop.w );
        Vector3 distv = verticeTop3 - verticeOrigin3;
        float r = sqrt(SQ(distv.x) + SQ(distv.y) + SQ(distv.z));
        Vector3 r3 = Vector3(r,r,r);

        result.getPos() = verticeOrigin3 - r3;
        result.getSize() = 2*r3;
    }
    else
        result =computeCubeAABB(transform);
    return result;
}

// For sphere, we just use the method of Cube
AABB computeConeAABB(Matrix4x4 transform )
{
    AABB result;
    Matrix4x4 tmp = transform;
    tmp.d = 0;tmp.h = 0; tmp.l = 0;//Ignore translation
    if( checkOrthonormal(tmp) )
    {
        Vector4 vertices[2];
        vertices[0] = transform*Vector4(0,0.5,0,1);
        vertices[1] = transform*Vector4(0,-0.5,0,1);

        float ATop,BCenter,CTop,DCenter,ETop,FCenter;
        ATop = vertices[0].x/vertices[0].w;
        BCenter = vertices[1].x/vertices[1].w;
        CTop = vertices[0].y/vertices[0].w;
        DCenter = vertices[1].y/vertices[1].w;
        ETop = vertices[0].z/vertices[0].w;
        FCenter = vertices[1].z/vertices[1].w;

        float kx = sqrt((SQ(CTop-DCenter)+SQ(ETop-FCenter))/(SQ(ATop-BCenter)+SQ(CTop-DCenter)+SQ(ETop-FCenter)));
        result.getPos().x = min(ATop, BCenter-kx*0.5);
        result.getSize().x = max(ATop, BCenter+kx*0.5) - result.getPos().x;

        float ky =sqrt((SQ(ATop-BCenter)+SQ(ETop-FCenter))/(SQ(ATop-BCenter)+SQ(CTop-DCenter)+SQ(ETop-FCenter)));
        result.getPos().y = min(CTop, DCenter-ky*0.5);
        result.getSize().y = max(CTop, DCenter+ky*0.5) - result.getPos().y;

        float kz = sqrt((SQ(ATop-BCenter)+SQ(CTop-DCenter))/(SQ(ATop-BCenter)+SQ(CTop-DCenter)+SQ(ETop-FCenter)));
        result.getPos().z =min(ETop, FCenter-kz*0.5);
        result.getSize().z = max(ETop, FCenter+kz*0.5) - result.getPos().z;
    }
    else
        result =computeCubeAABB(transform);

    return result;
}

// For sphere, we just use the method of Cube
AABB computeCylinderAABB(Matrix4x4 transform )
{
    AABB result;
    Matrix4x4 tmp = transform;
    tmp.d = 0;tmp.h = 0; tmp.l = 0;//Ignore translation
    if( checkOrthonormal(tmp) )
    {
        Vector4 vertices[2];
        vertices[0] = transform*Vector4(0,0.5,0,1);
        vertices[1] = transform*Vector4(0,-0.5,0,1);

        float A,B,C,D,E,F;
        A = vertices[0].x/vertices[0].w;
        B = vertices[1].x/vertices[1].w;
        C = vertices[0].y/vertices[0].w;
        D = vertices[1].y/vertices[1].w;
        E = vertices[0].z/vertices[0].w;
        F = vertices[1].z/vertices[1].w;

        if(B<A)
        {
            float tmp = A;
            A = B;
            B = tmp;
        }
        float kx = sqrt((SQ(C-D)+SQ(E-F))/(SQ(A-B)+SQ(C-D)+SQ(E-F)));
        result.getPos().x =A-kx*0.5;result.getSize().x = B-A+2*kx*0.5;

        if(D<C)
        {
            float tmp = C;
            C = D;
            D = tmp;
        }
        float ky =sqrt((SQ(A-B)+SQ(E-F))/(SQ(A-B)+SQ(C-D)+SQ(E-F)));
        result.getPos().y =C-ky*0.5;result.getSize().y = D-C+2*ky*0.5;

        if(F<E)
        {
            float tmp = E;
            E = F;
            F = tmp;
        }
        float kz = sqrt((SQ(A-B)+SQ(C-D))/(SQ(A-B)+SQ(C-D)+SQ(E-F)));
        result.getPos().z =E-kz*0.5;result.getSize().z = F-E+2*kz*0.5;

    }
    else
        result =computeCubeAABB(transform);

    return result;
}

// Not applicable now
AABB computeMeshAABB(Matrix4x4 transform )
{

}

void drawAABB( AABB& aabb, float color[3] )
{
    glDisable(GL_LIGHTING);
   // glDisable(GL_DEPTH_TEST);
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE );

    glBegin(GL_QUADS );
    glColor3fv( color );
        // Bottom face
    glNormal3f(0.f, -1.f, 0.f );

    glVertex3fv( aabb.getPos().xyz );
    glVertex3fv( (aabb.getPos() + Vector3(aabb.getSize().x, 0, 0 )).xyz );
    glVertex3fv( (aabb.getPos() + Vector3(aabb.getSize().x, 0, aabb.getSize().z )).xyz );
    glVertex3fv(  (aabb.getPos() + Vector3(0, 0, aabb.getSize().z )).xyz );

    // Top face
    glNormal3f(0.f, 1.f, 0.f );
    glVertex3fv( (aabb.getPos() + Vector3( 0, aabb.getSize().y, 0 )).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0, aabb.getSize().y, aabb.getSize().z )).xyz );
    glVertex3fv( (aabb.getPos() + aabb.getSize()).xyz );
    glVertex3fv(  (aabb.getPos() + Vector3( aabb.getSize().x, aabb.getSize().y, 0 )).xyz );

    // Left face
    glNormal3f( -1.f, 0.f, 0.f );
    glVertex3fv( (aabb.getPos() ).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0,0, aabb.getSize().z )).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0, aabb.getSize().y, aabb.getSize().z )).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0, aabb.getSize().y,0 )).xyz );

    // Right face
    glNormal3f( 1.f, 0.f, 0.f );
    glVertex3fv( (aabb.getPos() + Vector3( aabb.getSize().x, 0, 0 )).xyz );
    glVertex3fv( (aabb.getPos() + Vector3(  aabb.getSize().x, aabb.getSize().y,0 )).xyz );
    glVertex3fv( (aabb.getPos() + aabb.getSize()).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( aabb.getSize().x, 0, aabb.getSize().z )).xyz );

    // Front face
    glNormal3f( 0.f, 0.f, 1.f );
    glVertex3fv( (aabb.getPos() + Vector3( aabb.getSize().x, 0, aabb.getSize().z ) ).xyz );
    glVertex3fv( (aabb.getPos() + aabb.getSize()).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0,  aabb.getSize().y, aabb.getSize().z ) ).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0, 0, aabb.getSize().z ) ).xyz );

    // Back face
    glNormal3f( 0.f, 0.f, -1.f );
    glVertex3fv( (aabb.getPos() ).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( 0, aabb.getSize().y, 0)).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( aabb.getSize().x,  aabb.getSize().y, 0 ) ).xyz );
    glVertex3fv( (aabb.getPos() + Vector3( aabb.getSize().x, 0, 0 ) ).xyz );

    glEnd();

    glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
    glEnable(GL_LIGHTING);
  //  glEnable(GL_DEPTH_TEST);
}
