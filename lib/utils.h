#ifndef UTILS_H
#define UTILS_H

#include "CS123Algebra.h"
#include "CS123SceneData.h"
#include "CS123Common.h"'"
void printMat4x4( char* title, const Matrix4x4& mat );
RGBA bilinearInterpTexel( const unsigned * texPixels, float x, float y, const int width, const int height, const int offset = 0 );
 RGBA rgbaUintToColor( const unsigned int rgba );
unsigned rgbaColorToUint( RGBA rgba );

Vector4 getReflectionDir( Vector3 norm, Vector4 incident );
Vector4 getRefracetionDir( Vector3 norm, Vector4 incident, REAL n1, REAL n2);

template <typename T>
inline void mclamp( T& in, T bottom, T top )
{
    assert( top >= bottom );

    if( in > top )
        in = top;
    else if( in < bottom )
        in = bottom;
}

bool isInString( char* string, const char* search );

#endif // UTILS_H
