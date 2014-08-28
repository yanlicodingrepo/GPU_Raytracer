
//Macros
#define EPSILON 1e-4 // A very small number
#define POS_INF 0x7FFFFFFF // A very large number

#define EQ(a, b) (fabs((a) - (b)) < EPSILON)
#define SQ(x) (x)*(x)

#define MIN(x, y) ({							\
			(((x) < (y)) ? (x) : (y));			\
		})

#define MAX_RECURSION 2

#define INVALID_POS ((float4)(-1,-1,-1,-1))
#define INVALID_DIR ((float4)(0, 0, 0, 0))

#define MAX_RAY 128
#define MAX_INDEX_MAP 10
#define MAX_OBJECT_DST 100

// enum
enum PrimitiveType {
	PRIMITIVE_NONE = 0,PRIMITIVE_CUBE = 1, PRIMITIVE_CONE = 2, PRIMITIVE_CYLINDER = 3,
	PRIMITIVE_TORUS = 4, PRIMITIVE_SPHERE = 5,PRIMITIVE_MESH
};

enum LightType {
	LIGHT_POINT = 0, LIGHT_DIRECTIONAL, LIGHT_SPOT, LIGHT_AREA
};

// Structures
typedef struct
{
    int id;
    int type;
    float4 color;
    float3 function;
    float4 pos;
    float4 dir;

    float radius;
    float penumbra;
    float angle;
    float width;
    float height;
} LightDataDevice;

typedef struct
{
    float16 transform;
    float16 invTransform;
    float16 invTTransformWithoutTrans;
    int type;

    // Textures
    // Only support general texture. Bump texture not supported
    int texHandle;
    float texBlend;
    float2 texRepeat;
    int texIsUsed;
    int texMapID;
    int texWidth;
    int texHeight;
    // Materials
    float4 diffuse;
    float4 ambient;
	float4 reflective;
    float4 specular;
    float4 transparent;
    float4 emmisive;
    float shininess;
    float ior;
} ObjectDataDevice;

typedef struct
{
    int useShadow;
    int usePointLight;
    int useDirectionalLight;
    int useSpotLight;
    int showTexture;
    int useSupersampling;
    int traceRecursion;
	int useReflection;
        int useKdTree;
}GlobalSettingDevice;

typedef struct
{
	float3 boxBegin;
	float3 boxSize;
	float split;
	int leaf;
	int axis;
	int leftIndex;
	int rightIndex;
	int objIndex;	
} KdTreeNodeDevice;

typedef struct
{
	int objectIndex;
	int nextNodeIndex;
} ObjectNodeDevice;

typedef struct
{
    float4 nextPos;
    float4 nextDir;
    float4 attenuation;
    int curIndex;
}Ray;

// Sampler
__constant sampler_t sampler = CLK_NORMALIZED_COORDS_TRUE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_LINEAR;

// Forward declaration
inline unsigned int rgbaFloat4ToUint(float4 rgba);
inline float Det4x4(float16 M );
inline float16 Inverse4x4(float16 M);
inline float4 matMult(float16 M, float4 v);
inline float16 transpose(float16 M);
inline int EQ4( float4 v1, float4 v2);
inline float getAxisElem4( float4 vec, int axis );

void checkPos(__global ObjectDataDevice* objects,
int objectCount,
ObjectDataDevice* objectDst,
int* dstCount,
float4 pos,
int* indexMap,
int* mapCount
);

bool checkCube( float4 posInObjSpace );
bool checkCylinder( float4 posInObjSpace  );
bool checkCone( float4 posInObjSpace );
bool checkSphere( float4 posInObjSpace );

bool boxContain( const float3 start, const float3 size, const float3 pos );
bool checkRange( const float4 intersect, const float4 range, const int axis );
void doIntersectRayKdBox(
        const float4 eyePos,
        const float4 d,
        float* near,
        float* far,
        const float3 boxStart,
		const float3 boxSize
	);

float doIntersectPlane( float3 point, float3 norm, float4 eyePos, float4 d);

float
intersect( float4 eyePos,		  
		   __global GlobalSettingDevice* globalSetting,
		   __global ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   int * objectIndex,
		   int* faceIndex,
		   __global KdTreeNodeDevice* kdtreeNodes,
		   int kdtreeNodeCount,
		   __global ObjectNodeDevice* objectNodes,
		   int objectNodeCount
	);

float
intersectLocal( float4 eyePos,
		   ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   int * objectIndex,
		   int* faceIndex
	);

float
doIntersect(ObjectDataDevice* object,
			float4 eyePos,
			float4 d,
            int* faceIndex
	);

float
doIntersectUnitCone(
	float4 eyePos,
	float4  d,
        int *faceIndex
	);

float3
getConeNorm(
                float4 intersect,
                int faceIndex
                );

float2 getConeIntersectTexCoord( 
int faceIndex,
float4 intersect
	);

float
doIntersectUnitCube(
	float4 eyePos,
	float4 d,
        int *faceIndex
	);

float3 getCubeNorm(
                int faceIndex
                );

float2 getCubeIntersectTexCoord(
int faceIndex,
float4 intersect
	);

float
doIntersectUnitCylinder(
	float4 eyePos,
	float4 d,
        int *faceIndex
	);

float3 getCylinderNorm(
        float4 intersectPoint,
        int faceIndex
        );

float2 getCylinderIntersectTexCoord( 
    int faceIndex,
    float4 intersect
	);

float
doIntersectUnitSphere(
	float4 eyePos,
        float4 d
	);

float3 getSphereNorm(
         float4 intersectPoint
        );

float2 getSphereIntersectTexCoord( 
         float4 intersectPoint
	);

float4
computeObjectColor(
	int objectIndex,
    __global ObjectDataDevice* objects,
	int objectCount,
	__global LightDataDevice* lights,
	int lightCount,
	__global GlobalSettingDevice* globalSetting,
	float4 globalData,
	float4 pos,
	float3 norm,
	float4 eyePos,
	float4 textureColor,
	__global unsigned int* pixels,
	int pixelCount,
	__global unsigned int* offsets,
	int offsetCount,
	__global KdTreeNodeDevice* kdtreeNodes,
	int kdtreeNodeCount,
	__global ObjectNodeDevice* objectNodes,
	int objectNodeCount
	);

float4 getPixelColor( float4 eyePos,
					  float4 d,
					  __global GlobalSettingDevice* globalSetting,
					  __global LightDataDevice* lightData,
					  int lightCount,
					  __global ObjectDataDevice* objectData,
					  int objectCount,
					  float4 globalData,
					  __global unsigned int* pixels,
					  int pixelCount,
					  __global unsigned int* offsets,
					  int offsetCount,
					  __global KdTreeNodeDevice* kdtreeNodes,
					  int kdtreeNodeCount,
					  __global ObjectNodeDevice* objectNodes,
					  int objectNodeCount
	);

__kernel void raytrace( __global unsigned int* uiOutputImage,
						unsigned int width,
						unsigned int height,
						__global GlobalSettingDevice* globalSetting,
						__global LightDataDevice* lightData,
						int lightCount,
						__global ObjectDataDevice* objectData,
						int objectCount,
						float4 globalData,
						float4 eyePos,
                                                float eyeNear,
						float16 invMat,
						__global unsigned int* pixels,
						int pixelCount,
						__global unsigned int* offsets,
						int offsetCount,
						__global KdTreeNodeDevice* kdtreeNodes,
						int kdtreeNodeCount,
						__global ObjectNodeDevice* objectNodes,
						int objectNodeCount
	);

inline unsigned int rgbaFloat4ToUint(float4 rgba)
{
    unsigned int uiPackedPix = 0U;
    uiPackedPix |= 0x000000FF & (unsigned int)(rgba.x * 255);
    uiPackedPix |= 0x0000FF00 & (((unsigned int)(rgba.y * 255)) << 8);
    uiPackedPix |= 0x00FF0000 & (((unsigned int)(rgba.z * 255)) << 16);
    uiPackedPix |= 0xFF000000 & (((unsigned int)(rgba.w * 255)) << 24);
    return uiPackedPix;
}

inline float4 rgbaUintToFloat4( unsigned int rgba )
{
	float4 result;
	unsigned int s3 = (rgba & 0xFF000000)>>24;
	unsigned int s2 = (rgba & 0x00FF0000)>>16;
	unsigned int s1 = (rgba & 0x0000FF00)>>8;
	unsigned int s0 = (rgba & 0x000000FF);
	result.s3 = (float)s3/255.0;
	result.s2 = (float)s2/255.0;
	result.s1 = (float)s1/255.0;
	result.s0 = (float)s0/255.0;
	return result;
}

float4 bilinearInterpTexel( __global unsigned int* texPixels,float x, float y, int width, int height, int offset  )
{
	if( x < 0 )
		x = 0.f;
	if( y < 0 )
		y = 0.f;
	if( x > width - 1 )
		x = width - 1;
	if( y > height - 1 )
		y = height -1;

	int X = (int)x;
	int Y = (int)y;
	float s1 = x - X;
	float s0 = 1.f - s1;
	float t1 = y - Y;
	float t0 = 1.f-t1;
	unsigned int e1, e2, e3,e4;
	float4 r1, r2, r3, r4;
	float4 result;
	e1 = e2 = e3 = e4 = 0;
	e1 = texPixels[offset + Y*width + X];
	if( Y+1 <= height- 1 )
		e2 = texPixels[offset + (Y+1)*width + X];
	if( X +1 <= width -1 )
		e3 = texPixels[offset + (Y)*width + X+1];
	if( Y+1 <= height - 1 && X + 1 <= width - 1)
		e4 = texPixels[offset + (Y+1)*width + X+1];

	r1 = rgbaUintToFloat4(e1);
	r2 = rgbaUintToFloat4(e2);
	r3 = rgbaUintToFloat4(e3);
	r4 = rgbaUintToFloat4(e4);

	result = s0*(t0*r1 + t1*r2) + s1*(t0*r3+t1*r4);
    return result;
}

// Review passed
inline float Det4x4(float16 M )
{
    float a=M.s0, b=M.s1, c=M.s2, d=M.s3;
    float e=M.s4, f=M.s5, g=M.s6, h=M.s7;
    float i=M.s8, j=M.s9, k=M.sa, l=M.sb;
    float m=M.sc, n=M.sd, o=M.se, p=M.sf;
    return a*f*k*p - a*f*l*o - a*g*j*p + a*g*l*n + a*h*j*o -
		a*h*k*n - b*e*k*p + b*e*l*o + b*g*i*p - b*g*l*m -
		b*h*i*o + b*h*k*m + c*e*j*p - c*e*l*n - c*f*i*p +
		c*f*l*m + c*h*i*n - c*h*j*m - d*e*j*o + d*e*k*n +
		d*f*i*o - d*f*k*m - d*g*i*n + d*g*j*m;
}

// Review passed
inline float16 Inverse4x4(float16 M)
{
    float a=M.s0, b=M.s1, c=M.s2, d=M.s3;
    float e=M.s4, f=M.s5, g=M.s6, h=M.s7;
    float i=M.s8, j=M.s9, k=M.sa, l=M.sb;
    float m=M.sc, n=M.sd, o=M.se, p=M.sf;
    float det = Det4x4(M);
    return (float16)(
		(f*k*p+g*l*n+h*j*o-f*l*o-g*j*p-h*k*n)/det,
		(b*l*o+c*j*p+d*k*n-b*k*p-c*l*n-d*j*o)/det,
		(b*g*p+c*h*n+d*f*o-b*h*o-c*f*p-d*g*n)/det,
		(b*h*k+c*f*l+d*g*j-b*g*l-c*h*j-d*f*k)/det,
		(e*l*o+h*k*m+g*i*p-e*k*p-g*l*m-h*i*o)/det,
		(a*k*p+c*l*m+d*i*o-a*l*o-c*i*p-d*k*m)/det,
		(a*h*o+c*e*p+d*g*m-a*g*p-c*h*m-d*e*o)/det,
		(a*g*l+c*h*i+d*e*k-a*h*k-c*e*l-d*g*i)/det,
		(e*j*p+f*l*m+h*i*n-e*l*n-f*i*p-h*j*m)/det,
		(a*l*n+b*i*p+d*j*m-a*j*p-b*l*m-d*i*n)/det,
		(a*f*p+b*h*m+d*e*n-a*h*n-b*e*p-d*f*m)/det,
		(a*h*j+b*e*l+d*f*i-a*f*l-b*h*i-d*e*j)/det,
		(e*k*n+f*i*o+g*j*m-e*j*o-f*k*m-g*i*n)/det,
		(a*j*o+b*k*m+c*i*n-a*k*n-b*i*o-c*j*m)/det,
		(a*g*n+b*e*o+c*f*m-a*f*o-b*g*m-c*e*n)/det,
		(a*f*k+b*g*i+c*e*j-a*g*j-b*e*k-c*f*i)/det);
}

inline float4 matMult(float16 M, float4 v)
{
    return (float4)(dot(M.s0123,v),dot(M.s4567,v), dot(M.s89ab,v),dot(M.scdef,v));
}

inline float16 transpose(float16 M)
{
    return (float16)(M.s0,M.s4,M.s8,M.sc,M.s1,M.s5,M.s9,M.sd,M.s2,M.s6,M.sa,M.se,M.s3,M.s7,M.sb,M.sf);
}

inline int EQ4( float4 v1, float4 v2)
{
    if( EQ(v1.s0,v2.s0) && EQ(v1.s1,v2.s1) && EQ(v1.s2,v2.s2) && EQ(v1.s3,v2.s3) )
        return 1;
    else
        return 0;
}

inline float getAxisElem4( float4 vec, int axis )
{
	if( axis == 0 )
		return vec.x;
	else if( axis == 1 )
		return vec.y;
	else if( axis == 2 )
		return vec.z;
	else
		return -1;
}

inline int EQ16(float16 m1, float16 m2)
{
	if( EQ(m1.s0,m2.s0) && EQ(m1.s1, m2.s1) && EQ(m1.s2, m2.s2) && EQ(m1.s3, m2.s3)
		&& EQ(m1.s4, m2.s4) && EQ(m1.s5, m2.s5) && EQ(m1.s6, m2.s6) && EQ(m1.s7,m2.s7)
		&& EQ(m1.s8, m2.s8) && EQ(m1.s9,m2.s9) && EQ(m1.sa,m2.sa) && EQ(m1.sb, m2.sb)
		&& EQ(m1.sc, m2.sc) && EQ(m1.sd, m2.sd) && EQ(m1.se, m2.se) && EQ(m1.sf,m2.sf)
		)
		return 1;
	else
		return 0;
}

float4 getReflectionDir( float4 norm, float4 incident )
{

	float cos = -dot( norm, incident );

    float4 reflection = fast_normalize((incident + (float4)( 2*cos*norm.x, 2*cos*norm.y, 2*cos*norm.z, 0 )));

    return reflection;
}

float4 getRefractionDir( float3 norm, float4 incident, float n1, float n2 )
{
	float n = n1/n2;
    float cosI = -(norm.x*incident.x + norm.y*incident.y + norm.z*incident.z);
    float sinT2 = n*n*(1.0 - cosI*cosI);
    float4 norm4 = (float4)( norm.x, norm.y, norm.z, 0 );

    if( sinT2 >= 1.0 )
    {
        return INVALID_DIR;
    }
    return incident*n + norm4*(n*cosI -  sqrt(1.0-sinT2));
}

void checkPos(
__global ObjectDataDevice* objects,
int objectCount,
ObjectDataDevice* objectDst,
int* dstCount,
float4 pos,
int* indexMap,
int* mapCount
)
{
    int index = 0;


    for( int i = 0; i < objectCount; i++ )
    {
        float4 posInObjSpace = matMult(objects[i].invTransform, pos);
        bool in = false;
        switch( objects[i].type )
        {
        case PRIMITIVE_CUBE: in  = checkCube(posInObjSpace); break;
        case PRIMITIVE_CONE: in  = checkCone(posInObjSpace); break;
        case PRIMITIVE_CYLINDER: in  = checkCylinder(posInObjSpace); break;
        case PRIMITIVE_SPHERE: in  = checkSphere(posInObjSpace); break;
        case PRIMITIVE_TORUS:break;
        case PRIMITIVE_MESH:break;
        default:
            break;
        }
        if( in )
        {
             objectDst[index] = objects[i];
            indexMap[index] = i;
            index++;
        }
    }
    *dstCount = index;
    *mapCount = index;
}

bool checkCube( const float4 posInObjSpace )
{
    float3 pos3 = (float3)( posInObjSpace.x/posInObjSpace.w,
                            posInObjSpace.y/posInObjSpace.w,
                            posInObjSpace.z/posInObjSpace.w
                            );

    return pos3.x < 0.5 && pos3.x > -0.5 && pos3.y < 0.5 && pos3.y > -0.5 && pos3.z < 0.5 && pos3.z > -0.5 ? true: false;
}

bool checkCylinder( const float4 posInObjSpace  )
{
    float3 pos3 = (float3)( posInObjSpace.x/posInObjSpace.w,
                            posInObjSpace.y/posInObjSpace.w,
                            posInObjSpace.z/posInObjSpace.w
                            );

    float3 pos3H = (float3)( pos3.x, 0, pos3.z );
    return dot( pos3H, pos3H ) < 0.25 && pos3.y >-0.5 && pos3.y < 0.5 ? true : false;
}

bool checkCone( const float4 posInObjSpace )
{
    float3 pos3 = (float3)( posInObjSpace.x/posInObjSpace.w,
                            posInObjSpace.y/posInObjSpace.w,
                            posInObjSpace.z/posInObjSpace.w
                            );


    if( pos3.y > -0.5 && pos3.y < 0.5 )
    {
        float3 pos3H = (float3)( pos3.x, 0, pos3.z );
        float length = 0.25 - 0.5*pos3.y;
        return dot( pos3H, pos3H ) < (length*length) ? true : false;
    }
   return false;
}

bool checkSphere( const float4 posInObjSpace )
{
    float3 pos3 = (float3)( posInObjSpace.x/posInObjSpace.w,
                            posInObjSpace.y/posInObjSpace.w,
                            posInObjSpace.z/posInObjSpace.w
                            );
    return dot( pos3, pos3 )<0.25? true : false;
}

bool boxContain( const float3 start, const float3 size, const float3 pos )
{
	float3 v1 = start, v2 = start + size;
        return ((pos.x >= v1.x) && (pos.x <= v2.x) &&
                (pos.y >= v1.y) && (pos.y <= v2.y) &&
                (pos.z >= v1.z) && (pos.z <= v2.z));
}

bool checkRange( const float4 intersect, const float4 range, const int axis )
{
    bool result = false;
    switch( axis )
    {
    case 0: // X axis range
        if( intersect.y >= range.x && intersect.y <= range.y &&
                intersect.z >= range.z && intersect.z <= range.w )
          result = true;
        break;
    case 1: // Y axis range
        if( intersect.x >= range.x && intersect.x <= range.y &&
                intersect.z >= range.z && intersect.z <= range.w )
          result = true;
        break;
    case 2: // Z axis range
        if( intersect.x >= range.x && intersect.x <= range.y &&
                intersect.y >= range.z && intersect.y <= range.w )
          result = true;
        break;
    default:
        break;
    }
    return result;
}

void doIntersectRayKdBox(
        const float4 eyePos,
        const float4 d,
        float* near,
        float* far,
        const float3 boxStart,
		const float3 boxSize
        )
{

    *near = -1;
    *far = -1;
    float3 start = boxStart;
    float3 end = boxStart + boxSize;
    float3 norm[3] = {(float3)(1,0,0), (float3)(0,1,0), (float3)(0,0,1) };


    float4 range[3] = {
		(float4)( start.y, end.y, start.z, end.z ),
		(float4)( start.x, end.x, start.z, end.z ),
		(float4)( start.x, end.x, start.y, end.y )
	};
    float t[6];
    t[0] = doIntersectPlane( start, norm[0], eyePos, d );
    t[1] = doIntersectPlane( end, norm[0], eyePos, d );
    t[2] = doIntersectPlane( start, norm[1], eyePos, d );
    t[3] = doIntersectPlane( end, norm[1], eyePos, d );
    t[4] = doIntersectPlane( start, norm[2], eyePos, d );
    t[5] = doIntersectPlane( end, norm[2], eyePos, d );

    float4 intersectPoint[6];
    float min = POS_INF;
    float max = -POS_INF;
    for( int i = 0; i < 6; i++ )
    {
        intersectPoint[i] = eyePos + t[i]*d;
        if( t[i] > 0 && checkRange( intersectPoint[i], range[i/2], i/2 ) && min > t[i] )
        {
            min = t[i];
            *near = t[i];
        }
        if( t[i] > 0 && checkRange( intersectPoint[i], range[i/2], i/2 ) && max < t[i] )
        {
            max = t[i];
            *far = t[i];
        }
    }
}

float doIntersectPlane( float3 point, float3 norm, float4 eyePos, float4 d)
{

    float t = -1;
    float denominator = (norm.x*d.x+norm.y*d.y+norm.z*d.z);
    if(fabs(denominator)>EPSILON)
    {
        t = (dot(norm, point)-dot(norm, (float3)(eyePos.x, eyePos.y, eyePos.z)))/(denominator);
    }

    return t;
}


float doIntersectUnitCone(
	float4 eyePos,
	float4  d,
        int *faceIndex
	)
{
	//!  cone has two parts, the bottom cap and the side.

	float result = -1;
	float3 norms[2];
	float t[2];

	// firstly check if the ray intersects the bottom;
	t[0] = -1;
	norms[0] = (float3)(0,-1,0);

	t[0] = doIntersectPlane( (float3)( 0, -0.5, 0 ), norms[0], eyePos, d );
	float4 intersect = eyePos + t[0]*d;
	if ( !(SQ(intersect.x) + SQ(intersect.z) <= 0.25))
		t[0] = -1;

	// then check the intersect point on the side
	t[1] = -1;
	float A = d.x*d.x + d.z*d.z -0.25*d.y*d.y;
	float B = 2*eyePos.x*d.x + 2*eyePos.z*d.z - 0.5*eyePos.y*d.y + 0.25*d.y;
	float C = eyePos.x*eyePos.x + eyePos.z*eyePos.z - 0.25*eyePos.y*eyePos.y + 0.25*eyePos.y - 0.0625;

	float determinant = B*B - 4*A*C;
	if( determinant >= 0)
	{
		float t1 = (-B + sqrt(determinant))/(2*A);
		float t2 = (-B - sqrt(determinant))/(2*A);

		if( !(eyePos.y + t1*d.y <= 0.5+EPSILON
			  &&eyePos.y + t1*d.y >= -0.5-EPSILON) )
		{
			t1 = -1;
		}

		if( !(eyePos.y + t2*d.y <= 0.5+EPSILON
			  &&eyePos.y + t2*d.y >= -0.5-EPSILON) )
		{
			t2 = -1;
		}

		if ( t1>0 && t2 <= 0)
			t[1] = t1;
		else if( t1<=0 && t2 >0 )
			t[1] = t2;
		else if ( t1 > 0&& t2 >0 )
			t[1] = MIN(t1,t2);
	}

	intersect = eyePos + t[1]*d;
	norms[1] = (float3)(2*(intersect.x), 0.25 - 0.5*(intersect.y), 2*(intersect.z));
	norms[1] = fast_normalize(norms[1]);
	float minT = POS_INF;
	for( int i = 0; i < 2; i++ )
	{
		if(t[i]>0&&t[i]<minT)
		{
			minT = t[i];
                        *faceIndex = i;
		}
	}
	if( minT != POS_INF )
		result = minT;

	return result;
}

float3 getConeNorm(
        float4 intersect,
        int faceIndex
        )
{
     float3 norms[2];
      norms[0] = (float3)(0,-1,0);
      norms[1] = (float3)(2*(intersect.x), 0.25 - 0.5*(intersect.y), 2*(intersect.z));
     norms[1] = fast_normalize(norms[1]);

     return norms[faceIndex];
}

float2 getConeIntersectTexCoord( 
        int faceIndex,
        float4 intersect
	)
{
    float2 texCoord = (float2)(-1,-1);

        switch( faceIndex )
        {
            // bottom
        case 0:
		{
			texCoord.s0 = (0.5 + intersect.x);
			texCoord.s1 = 1 - (0.5 - intersect.z);
			//              x = (int)((width-1)*u);
			// y = (int)((height-1)*v);
			break;
		}
        case 1:
		{

			texCoord.s1 = 0.5 + intersect.y;
			float3 Vp = (float3)(intersect.s0, intersect.s1, intersect.s2 );
			Vp = fast_normalize(Vp);
			float theta = atan2( Vp.z, Vp.x );
			if( Vp.z < 0 )
			{
				theta = theta + 2*M_PI;
			}
			texCoord.s0 = 1 - theta/(2*M_PI);
			break;
		}
        default:
            break;
        }
    return texCoord;
}

float doIntersectUnitCube(
	float4 eyePos,
	float4 d,
        int *faceIndex
	)
{
	//! Cube has six faces, we do intersection test in these six planes


	float result = -1;

	float3 norms[6];
	// front
	norms[0] = (float3)(0,0,1);
	// back
	norms[1] = (float3)(0,0,-1);
	// left
	norms[2] = (float3)(-1,0,0);
	// right
	norms[3] = (float3)(1,0,0);
	// top
	norms[4] = (float3)(0,1,0);
	// down
	norms[5] = (float3)(0,-1,0);

	float3 points[6];
	// front
	points[0] = (float3)(0,0,0.5);
	// back
	points[1] = (float3)(0,0,-0.5);
	// left
	points[2] = (float3)(-0.5,0,0);
	// right
	points[3] = (float3)(0.5,0,0);
	// top
	points[4] = (float3)(0,0.5,0);
	// bottom
	points[5] = (float3)(0,-0.5,0);


	float t[6];
	for( int i = 0; i < 6; i++ )
	{
		t[i] = doIntersectPlane(points[i],norms[i],eyePos,d);
	}

	float4 intersect = eyePos + t[0]*d;

	if(!(intersect.y <= 0.5+EPSILON
		 &&intersect.y>=-0.5-EPSILON
		 &&intersect.x>=-0.5-EPSILON
		 &&intersect.x<=0.5+EPSILON))
		t[0] = -1;
	intersect = eyePos + t[1]*d;
	if(!(intersect.y <= 0.5+EPSILON
		 &&intersect.y>=-0.5-EPSILON
		 &&intersect.x>=-0.5-EPSILON
		 &&intersect.x<=0.5+EPSILON))
		t[1] = -1;

	intersect = eyePos + t[2]*d;
	if(!(intersect.y <= 0.5+EPSILON
		 &&intersect.y>=-0.5-EPSILON
		 &&intersect.z>=-0.5-EPSILON
		 &&intersect.z<=0.5+EPSILON))
		t[2] = -1;

	intersect = eyePos + t[3]*d;
	if(!(intersect.y <= 0.5+EPSILON
		 &&intersect.y>=-0.5-EPSILON
		 &&intersect.z>=-0.5-EPSILON
		 &&intersect.z<=0.5+EPSILON))
		t[3] = -1;

	intersect = eyePos + t[4]*d;
	if(!(intersect.z <= 0.5+EPSILON
		 &&intersect.z>=-0.5-EPSILON
		 &&intersect.x>=-0.5-EPSILON
		 &&intersect.x<=0.5+EPSILON))
		t[4] = -1;

	intersect = eyePos + t[5]*d;
	if(!(intersect.z <= 0.5+EPSILON
		 &&intersect.z>=-0.5-EPSILON
		 &&intersect.x>=-0.5-EPSILON
		 &&intersect.x<=0.5+EPSILON))
		t[5] = -1;

	float minT = POS_INF;

	for( int i = 0; i < 6; i++ )
	{
		if(t[i]>0&&t[i]<minT)
		{
			minT = t[i];
                        *faceIndex = i;
		}
	}
	if(minT != POS_INF)
		result = minT;

	return result;
}

float3 getCubeNorm(
        int faceIndex
        )
{
    float3 norms[6];
    // front
    norms[0] = (float3)(0,0,1);
    // back
    norms[1] = (float3)(0,0,-1);
    // left
    norms[2] = (float3)(-1,0,0);
    // right
    norms[3] = (float3)(1,0,0);
    // top
    norms[4] = (float3)(0,1,0);
    // down
    norms[5] = (float3)(0,-1,0);

    return norms[faceIndex];
}

float2 getCubeIntersectTexCoord( 
        int faceIndex,
        float4 intersect
	)
{
    float2 texCoord = (float2)(-1,-1);

        switch( faceIndex )
        {
			// front
        case 0:
        {
            texCoord.s0 =  intersect.x+ 0.5;
			texCoord.s1 =  intersect.y+ 0.5;
			break;
        }
		// back
        case 1:
        {
			texCoord.s0 =  0.5 - intersect.x;
			texCoord.s1 =  intersect.y+ 0.5;
            break;
        }
		// left
        case 2:
        {
			texCoord.s0 =  intersect.z + 0.5;
			texCoord.s1 =  intersect.y + 0.5;
            break;
        }
		// right
        case 3:
        {
			texCoord.s0 =  0.5 - intersect.z;
			texCoord.s1 =  intersect.y + 0.5;
            break;
        }
		// top
        case 4:
        {
			texCoord.s0 =  0.5 + intersect.x;
			texCoord.s1 =  0.5 - intersect.z;
            break;
        }
		// down
        case 5:
        {
			texCoord.s0 =  0.5 + intersect.x;
			texCoord.s1 =  0.5 + intersect.z;
            break;
        }
        default:
            break;
        }
    return texCoord;
}

float doIntersectUnitCylinder(
	float4 eyePos,
	float4 d,
        int* faceIndex
	)
{
	// Cylinder has three parts: top, bottom and side.
	float result = -1;

	float t[3];
	float3 norms[3];

	// firstly check if the ray intersects the bottom;
	t[0] = -1;
	norms[0] = (float3)(0,-1,0);
	t[0] = doIntersectPlane( (float3)(0,-0.5,0), norms[0], eyePos, d );
	float4 intersect = eyePos + t[0]*d;
	if ( t[0] != -1 && !(SQ(intersect.x) + SQ(intersect.z) <= 0.25))
		t[0] = -1;

	// secondly check if the ray intersects the top
	t[1] = -1;
	norms[1] = (float3)(0,1,0);
	t[1] = doIntersectPlane( (float3)(0,0.5,0), norms[1], eyePos, d );

	intersect = eyePos + t[1]*d;
	if ( t[1] != -1 && !(SQ(intersect.x) + SQ(intersect.z) <= 0.25))
		t[1] = -1;

	// at last check if the ray intersects the side
	t[2] = -1;
	float A = d.x*d.x + d.z*d.z;
	float B = 2*eyePos.x*d.x + 2*eyePos.z*d.z;
	float C = eyePos.x*eyePos.x + eyePos.z*eyePos.z - 0.25;
	float determinant = B*B - 4*A*C;
	if( determinant >= 0)
	{
		float t1 = (-B + sqrt(determinant))/(2*A);
		float t2 = (-B - sqrt(determinant))/(2*A);

		if( !(eyePos.y + t1*d.y <= 0.5+EPSILON&&eyePos.y + t1*d.y >= -0.5-EPSILON) )
		{
			t1 = -1;
		}

		if( !(eyePos.y + t2*d.y <= 0.5+EPSILON&&eyePos.y + t2*d.y >= -0.5-EPSILON) )
		{
			t2 = -1;
		}
		if ( t1>0 && t2 <= 0)
			t[2] = t1;
		else if( t1<=0 && t2 >0 )
			t[2] = t2;
		else if ( t1 > 0&& t2 >0 )
			t[2] = MIN(t1,t2);
	}

	float minT = POS_INF;
	for( int i = 0; i < 3; i++ )
	{
		if(t[i]>0&&t[i]<minT)
		{
			minT = t[i];
                        *faceIndex = i;
		}
	}

	if( minT != POS_INF )
		result = minT;

	return result;
}

float3 getCylinderNorm(
        float4 intersectPoint,
        int faceIndex
        )
{
   float3 norms[3];
    norms[0] = (float3)(0,-1,0);
    norms[1] = (float3)(0,1,0);
    norms[2] = fast_normalize((float3)(intersectPoint.x, 0, intersectPoint.z));

    return norms[faceIndex];
}

float2 getCylinderIntersectTexCoord( 
        int faceIndex,
        float4 intersect
	)
{
	float2 texCoord = (float2)(-1,-1);
        switch( faceIndex )
        {
            // bottom
        case 0:
		{
			texCoord.s0 = (0.5 + intersect.x);
			texCoord.s1 = 1 - (0.5 - intersect.z);
			break;
		}
		// top
        case 1:
		{
			texCoord.s0 = (0.5 + intersect.x);
			texCoord.s1 = (0.5 - intersect.z);
			break;
		}
        case 2:
		{
			float4 Ve = (float4)(1,0,0,0);
			float4 Vp = (float4)(intersect.x, 0, intersect.z, 0);
			Vp = fast_normalize(Vp);
			float theta = acos( dot(Vp,Ve) );
			if( Vp.z > 0 )
				theta = theta + 2*(M_PI - theta );
			texCoord.s0 = theta/(2*M_PI);
			texCoord.s1 = 0.5 + intersect.y;
			break;
		}
        default:
            //assert(0);
            break;
        }
    return texCoord;
}

float doIntersectUnitSphere(
	float4 eyePos,
        float4 d
	)
{
	// Sphere has only one part that needs to be checked!
	float result = -1;

	float t = -1;
	float3 norms;
	float A = d.x*d.x + d.y*d.y + d.z*d.z;
	float B = 2*eyePos.x*d.x + 2*eyePos.y*d.y+ 2*eyePos.z*d.z;
	float C = eyePos.x*eyePos.x + eyePos.y*eyePos.y + eyePos.z*eyePos.z - 0.25;
	float determinant = B*B - 4*A*C;

	if( determinant >= 0)
	{
		float t1 = (-B + sqrt(determinant))/(2*A);
		float t2 = (-B - sqrt(determinant))/(2*A);
		if ( t1>EPSILON && t2 <= EPSILON)
			t= t1;
		else if( t1<=EPSILON && t2 >EPSILON )
			t = t2;
		else if ( t1 > EPSILON&& t2 >EPSILON )
			t = MIN(t1,t2);
	}

	if ( t > 0 )
	{
		result = t;
	}

	return result;
}

float3 getSphereNorm(
         float4 intersectPoint
        )
{
    float3 norm = (float3)( intersectPoint.x/intersectPoint.w, intersectPoint.y/intersectPoint.w, intersectPoint.z/intersectPoint.w );

    return fast_normalize(norm);
}

float2 getSphereIntersectTexCoord( 
        float4 intersectPoint
	)
{
	float2 texCoord = (float2)(-1,-1);

    // Get the texture color if the following condition is satisfied

        float4 Vn  = (float4)(0,1,0,0);
        float4 Ve = (float4)(1,0,0,0);
        float4 Vp = intersectPoint;
		Vp.s3 = 0;
		Vp = fast_normalize(Vp);
        float phi = acos( -dot( Vn, Vp ) );
		texCoord.s1 = phi/M_PI;

        float theta = (acos(dot(Vp,Ve)/sin(phi)))/(2*M_PI);
        theta = atan2( Vp.z, Vp.x );
        if( theta < 0 )
        {
            theta = theta + 2*M_PI;
        }
        texCoord.s0 = 1- theta/(2*M_PI);
    return texCoord;
}

float
intersect( float4 eyePos,		 
		   __global GlobalSettingDevice* globalSetting,
		   __global ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   int * objectIndex,
		   int* faceIndex,
		   __global KdTreeNodeDevice* kdtreeNodes,
		   int kdtreeNodeCount,
		   __global ObjectNodeDevice* objectNodes,
		   int objectNodeCount
	)
{


	float minT = POS_INF;
	float resultT = -1;
	int tempFaceIndex = -1;
	if( !globalSetting->useKdTree )
	{
		for( int i = 0; i < objectCount; i++ )
		{

			ObjectDataDevice current = objectData[i];

			float4 eyePosObjSpace = matMult(current.invTransform, eyePos);
			float4 dObjSpace = matMult(current.invTransform, d);


			float t = doIntersect( &current, eyePosObjSpace, dObjSpace, &tempFaceIndex );

			if( t>0 && t < minT )
			{
				minT = t;
				*objectIndex = i;
				*faceIndex = tempFaceIndex;
			}
		}
		if( minT != POS_INF )
			resultT = minT;
	}
	else
	{
		float near, far;
		KdTreeNodeDevice root = kdtreeNodes[0];
		doIntersectRayKdBox( eyePos, d, &near, &far, root.boxBegin, root.boxSize );
		if( near <= 0 && far <= 0 )
			return -1;

		int nodeStack[1024];
		int stackTop = 0;
		int nextIndex = 0;
		
		while( nextIndex != -1 )
		{
			KdTreeNodeDevice current = kdtreeNodes[nextIndex];
			
			while( !current.leaf )
			{
				float3 curBoxStart = current.boxBegin;
				float3 curBoxSize = current.boxSize;
				float near, far;
				doIntersectRayKdBox( eyePos, d, &near, &far, curBoxStart, curBoxSize );
				int axis = current.axis;
				float splitPos = current.split;
				if( near == far )  // inside the box
					near = 0;
				float4 nearPos = eyePos + d*near;
				float4 farPos = eyePos + d*far;
				if( getAxisElem4(nearPos, axis) <= splitPos  )
				{
					if( getAxisElem4(farPos, axis) <= splitPos )
					{
                                                current = kdtreeNodes[current.leftIndex];
						continue;
					}
                                        nodeStack[stackTop++] = current.rightIndex;
					current = kdtreeNodes[current.leftIndex];
				}
				else
				{
					if( getAxisElem4(farPos, axis) > splitPos )
					{
                                                current = kdtreeNodes[current.rightIndex];
						continue;
					}
                                         nodeStack[stackTop++] = current.leftIndex;
                                         current = kdtreeNodes[current.rightIndex];;
				}
			}

			// Then we found an near leaf, find if there is intersect
			int objIndex = current.objIndex;

			minT = POS_INF;
		   
                        while( objIndex != -1 )
			{
				ObjectNodeDevice objList = objectNodes[objIndex];
				int sceneObjIndex = objList.objectIndex;

				ObjectDataDevice curSceneObj = objectData[sceneObjIndex];

				float4 eyePosObjSpace = matMult(curSceneObj.invTransform, eyePos);
				float4 dObjSpace = matMult(curSceneObj.invTransform, d);


				float t = doIntersect( &curSceneObj, eyePosObjSpace, dObjSpace, &tempFaceIndex );

				if( t>0 && t < minT )
				{
					minT = t;
					*objectIndex = sceneObjIndex;
					*faceIndex = tempFaceIndex;
				}
				objIndex = objList.nextNodeIndex;
                        }


			float4 dst = (eyePos + minT*d);
			// Here we need to enlarge the bounding box a little bit
			float3 boxStart = current.boxBegin - (float3)( EPSILON, EPSILON, EPSILON );
			float3 boxSize = current.boxSize + 2*(float3)( EPSILON, EPSILON, EPSILON );

			if( minT != POS_INF && boxContain( boxStart, boxSize, (float3)(dst.x, dst.y, dst.z ) ) )
			{
                                resultT = minT;
				break;
			}
			// Else we need to get one node from the stack
			if( stackTop == 0 )
			{
				// No more nodes, meaning there is no intersect
				break;
			}
			else
			{
                                nextIndex = nodeStack[--stackTop];
			}
			}
	}

	return resultT;
}

float
intersectLocal( float4 eyePos,
		   ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   int * objectIndex,
		   int* faceIndex
	)
{


	float minT = POS_INF;
	float resultT = -1;
        int tempFaceIndex = -1;
	for( int i = 0; i < objectCount; i++ )
	{

		ObjectDataDevice current = objectData[i];

                float4 eyePosObjSpace = matMult(current.invTransform, eyePos);
                float4 dObjSpace = matMult(current.invTransform, d);


                float t = doIntersect( &current, eyePosObjSpace, dObjSpace, &tempFaceIndex );

		if( t>0 && t < minT )
		{
			minT = t;
			*objectIndex = i;
                        *faceIndex = tempFaceIndex;
		}
	}
	if( minT != POS_INF )
		resultT = minT;

	return resultT;
}


float
doIntersect(ObjectDataDevice* object,
			float4 eyePos,
			float4 d,
			int* faceIndex
	)
{
	float t = -1;
	switch( object->type )
	{
	case 1:
	{
		t = doIntersectUnitCube( eyePos, d, faceIndex );
		break;
	}
	case 2:
	{
		t = doIntersectUnitCone( eyePos, d, faceIndex );
		break;
	}
	case 3:
	{
		t = doIntersectUnitCylinder( eyePos, d, faceIndex );
		break;
	}
	case 5:
	{
		t = doIntersectUnitSphere(  eyePos, d  );
		break;
	}
	case PRIMITIVE_TORUS:
	{
		// not support torus
		//assert(0);
		break;
	}
	case PRIMITIVE_MESH:
	{
		// not support mesh
		//assert(0);
		break;
	}
	default:
	{
		break;
	}
	}
	return t;
}

float4
computeObjectColor(
	int objectIndex,
	__global ObjectDataDevice* objects,
	int objectCount,
	__global LightDataDevice* lights,
	int lightCount,
	__global GlobalSettingDevice* globalSetting,
	float4 globalData,
	float4 pos,
	float3 norm,
	float4 eyePos,
	float4 textureColor,
	__global unsigned int* pixels,
	int pixelCount,
	__global unsigned int* offsets,
	int offsetCount,
	__global KdTreeNodeDevice* kdtreeNodes,
	int kdtreeNodeCount,
	__global ObjectNodeDevice* objectNodes,
	int objectNodeCount
	)
{
    ObjectDataDevice object = objects[objectIndex];

    float4 ambient = object.ambient*globalData.s0;

	//ambient = object.ambient*globalData.s0;
	ambient.s3 = 0;

    // lightSum contains the sum of the diffuse color, ambient color(hack),
    // specular color, and reflective color(recursive)
    float4 lightSum = (float4)(0,0,0,0);
	float4 norm4 = (float4)(norm.x, norm.y, norm.z, 0);
    for( int i = 0; i < lightCount; i++ )
    {
        LightDataDevice currentLight = lights[i];
        float4 lightDir = (float4)(0,1,0,0);

        bool unapplicable = false;

        float attenuation = 1;
        if( currentLight.type != LIGHT_DIRECTIONAL )
        {
            // compute the attenuation
            float dLight = sqrt( SQ(currentLight.pos.x - pos.x) + SQ(currentLight.pos.y - pos.y) + SQ(currentLight.pos.z - pos.z) );
            attenuation = MIN( 1.0/(currentLight.function.x + currentLight.function.y*dLight + currentLight.function.z*SQ(dLight)), 1 );
        }

        float4 lightIntensity = currentLight.color;
        switch( currentLight.type )
        {
        case LIGHT_POINT:
		{
			if( globalSetting->usePointLight )
			{
				lightDir = fast_normalize( (currentLight.pos - pos) );
			}
			else
			{
				unapplicable = true;
			}
			break;
		}
        case LIGHT_DIRECTIONAL:
		{
			if( globalSetting->useDirectionalLight )
			{
				lightDir = -fast_normalize(currentLight.dir);
			}
			else
			{
				unapplicable = true;
			}
			break;
		}
        case LIGHT_SPOT:
		{
			if( globalSetting->useSpotLight )
			{

				lightDir = fast_normalize((currentLight.pos - pos));
				float4 majorDir = -fast_normalize(currentLight.dir);

				float lightRadians = currentLight.penumbra/180.0*M_PI;

				float spotIntensity = dot(lightDir, majorDir);

				// the object is not in the cone
				if( spotIntensity < cos(lightRadians) )
				{
					// the intersect point is out of the cone of the light, should not be lightted
					lightIntensity.s0 = lightIntensity.s1 = lightIntensity.s2;
				}
				else
				{
					float temp = pow(spotIntensity, 5 );
					lightIntensity = temp*lightIntensity;
				}
			}
			else
			{

				unapplicable = true;
			}
			break;
		}
        case LIGHT_AREA:
		{
			unapplicable = true;
			break;
		}
        default:
		{
			unapplicable = true;
			break;
		}
        }
        if( unapplicable )
            continue;
        
// in intersect assignment, this is used for checking if the object is in shadow
        float dotLN = dot( lightDir, norm4 );
        if( dotLN < 0.0)
            dotLN = 0.0;

		// Check if the object is in shadow of light
		if( globalSetting->useShadow )
        {
			int objectIndex2 = -1;
			int faceIndex = -1;
			float4 lightPos;

			if( currentLight.type != LIGHT_DIRECTIONAL )
			{
				lightPos = currentLight.pos;
				intersect( lightPos, globalSetting, objects, objectCount, (-lightDir),  &objectIndex2, &faceIndex, kdtreeNodes, kdtreeNodeCount, objectNodes, objectNodeCount );
			}
			else
			{
				intersect( pos + (norm4)*EPSILON, globalSetting, objects, objectCount, (lightDir), &objectIndex2, &faceIndex, kdtreeNodes, kdtreeNodeCount, objectNodes, objectNodeCount );
			}
			// this means the object is in shadow

			// We don't need to check if intersectpoint is equal to pos because the pos we
			// pass into this function is always the first point intersected of each shape
			if( objectIndex2 != objectIndex && objectIndex2 != -1 )
				continue;

        }

        // compute diffuse light color
        // if using texture mapping, then blend the diffuse with diffuse color
		if( globalSetting->showTexture && object.texHandle > 0 )
		{
			lightSum += attenuation*lightIntensity*dotLN*(globalData.s1*((object.diffuse*textureColor)));

		}
		else
		{
			// simply compute diffuse color

		    lightSum += attenuation*lightIntensity*dotLN*globalData.s1*(object.diffuse);
		}
		// No specular

        // the following steps are computing the specular color
        float4 sight = eyePos - pos;
        sight = fast_normalize(sight);

        float4 reflection = getReflectionDir( norm4, -lightDir );
        float dotEN  = dot( sight, reflection );
        if( dotEN < 0.0 )
        {
            dotEN = 0.0;
        }
        dotEN = pow(dotEN, object.shininess );
        lightSum += attenuation*lightIntensity*dotEN*globalData.s2*object.specular;

    }

	lightSum = ambient + lightSum;

    lightSum.s0 = clamp(lightSum.s0,0.f,1.f);
    lightSum.s1 = clamp(lightSum.s1,0.f,1.f);
    lightSum.s2 = clamp(lightSum.s2,0.f,1.f);
    lightSum.s3 = 0.f;

    return lightSum;
}

float4 getPixelColor( float4 eyePos,
					  float4 d,
					  __global GlobalSettingDevice* globalSetting,
					  __global LightDataDevice* lightData,
					  int lightCount,
					  __global ObjectDataDevice* objectData,
					  int objectCount,
					  float4 globalData,
					  __global unsigned int* pixels,
					  int pixelCount,
					  __global unsigned int* offsets,
					  int offsetCount,
					  __global KdTreeNodeDevice* kdtreeNodes,
					  int kdtreeNodeCount,
					  __global ObjectNodeDevice* objectNodes,
					  int objectNodeCount
	)
{

	float4 result = (float4)(0, 0, 0, 0);
    Ray rays[MAX_RAY];
    rays[0].nextPos = eyePos;
    rays[0].nextDir = d;
    rays[0].curIndex = -1;
    rays[0].attenuation = (float4)(1,1,1,1);

    int last = 0;
    int nextCount = 1;
    for( int i = 0; i < globalSetting->traceRecursion; i++ )
	{
		// No more rays
		if( last == nextCount )
			break;

		int curCount = nextCount;
		for( int j = last; j < curCount; j++ )
		{
			if( EQ4(rays[j].nextPos, INVALID_POS) )
				continue;

			int objectIndex = -1;
			int faceIndex = -1;
			float4 curNextPos = rays[j].nextPos;
			float4 curNextDir = rays[j].nextDir;
			float t = intersect( curNextPos, globalSetting, objectData, objectCount, curNextDir, &objectIndex, &faceIndex, kdtreeNodes, kdtreeNodeCount, objectNodes, objectNodeCount );
			if( t > 0 )
			{
                                        float4 colorNormal = (float4)(0, 0, 0, 0);
				float4 texColor = (float4)(0, 0, 0, 0);
				float3 norm = (float3)(0,1,0);
				float4 intersectPoint = curNextPos + t*curNextDir;
				float4 eyeSpaceIntersectPoint = matMult(objectData[objectIndex].invTransform,curNextPos) + t*matMult(objectData[objectIndex].invTransform, curNextDir);

				switch( objectData[objectIndex].type )
				{
				case PRIMITIVE_CUBE: norm = getCubeNorm( faceIndex );break;
				case PRIMITIVE_CYLINDER: norm = getCylinderNorm( eyeSpaceIntersectPoint, faceIndex);break;
				case PRIMITIVE_CONE: norm = getConeNorm( eyeSpaceIntersectPoint,  faceIndex);break;
				case PRIMITIVE_SPHERE: norm= getSphereNorm( eyeSpaceIntersectPoint );break;
				case PRIMITIVE_MESH: break;
				case PRIMITIVE_TORUS: break;
				default:break;
				}

				if( objectData[objectIndex].texHandle > 0
					&& globalSetting->showTexture
					)
				{
					float2 texCoord = (float2)( -1, -1 );
					switch( objectData[objectIndex].type )
					{
					case PRIMITIVE_CUBE: texCoord = getCubeIntersectTexCoord(  faceIndex, eyeSpaceIntersectPoint );break;
					case PRIMITIVE_CYLINDER: texCoord = getCylinderIntersectTexCoord( faceIndex, eyeSpaceIntersectPoint );break;
					case PRIMITIVE_CONE: texCoord = getConeIntersectTexCoord( faceIndex, eyeSpaceIntersectPoint );break;
					case PRIMITIVE_SPHERE: texCoord = getSphereIntersectTexCoord( eyeSpaceIntersectPoint );break;
					case PRIMITIVE_MESH: break;
					case PRIMITIVE_TORUS: break;
					default:break;
					}

					if( texCoord.s0 != -1 && texCoord.s1 != -1 )
					{
						float xt = texCoord.s0*objectData[objectIndex].texWidth;
						float yt = texCoord.s1*objectData[objectIndex].texHeight;
						texColor = bilinearInterpTexel( pixels,
														xt,
														yt,
														objectData[objectIndex].texWidth,
														objectData[objectIndex].texHeight,
														offsets[objectData[objectIndex].texMapID]
							);
					}
				}
				float4 tempNorm = (float4)( norm.s0, norm.s1, norm.s2, 0);

				tempNorm = matMult( objectData[objectIndex].invTTransformWithoutTrans, tempNorm );
				norm = (float3)(tempNorm.s0, tempNorm.s1, tempNorm.s2);
				norm = fast_normalize(norm);

				colorNormal = computeObjectColor( objectIndex, objectData, objectCount, lightData, lightCount, globalSetting, globalData, intersectPoint, norm, curNextPos, texColor,pixels, pixelCount, offsets, offsetCount, kdtreeNodes, kdtreeNodeCount, objectNodes, objectNodeCount );


                                        result += colorNormal*rays[j].attenuation;

				if( globalSetting->useReflection )
				{
					bool zeroReflection = EQ4(objectData[objectIndex].reflective, (float4)(0,0,0,0));

					float projection = -(curNextDir.x*norm.x + curNextDir.y*norm.y + curNextDir.z*norm.z);

					if( projection > 0 && globalData.s2 > 0 && !zeroReflection )
					{
						float4 norm4 = (float4)(norm.x, norm.y, norm.z, 0);

						float4 reflection = getReflectionDir( norm4, curNextDir );
						rays[nextCount].nextPos = intersectPoint + reflection*EPSILON;
						rays[nextCount].nextPos.s3 = 1;
						rays[nextCount].nextDir = reflection;
						rays[nextCount].curIndex = rays[j].curIndex;
						rays[nextCount].attenuation = rays[j].attenuation*objectData[objectIndex].reflective*globalData.s2;
						nextCount++;
					}

						bool zeroRefraction = EQ4(objectData[objectIndex].transparent,0);
					if( !zeroRefraction )
					{
						// Refracetion part
						float n1,n2;
						int curIndex = rays[j].curIndex;
						if( curIndex != -1 )
						{
							// The ray may be inside an object
							n1 = objectData[curIndex].ior;
							float3 normFace;
							// bump the start point to be a little bit
							if( curNextDir.x*norm.x + curNextDir.y*norm.y + curNextDir.z*norm.z > 0 )
								normFace = (float3)( -norm.x, -norm.y, -norm.z );
							else
								normFace = norm;

							int indexMap[MAX_INDEX_MAP];
							int indexCount;
							ObjectDataDevice list[MAX_OBJECT_DST];
							int listCount;
							float4 bumpPos = intersectPoint + (float4)( -normFace.x, -normFace.y, -normFace.z, 0 )*EPSILON*2;
                
							checkPos( objectData, objectCount, list, &listCount, bumpPos, indexMap, &indexCount );
							int dummyObjectIndex = -1, dummyFaceindex = -1;
							float t2 = -1;
							if( listCount != 0 )
								t2 = intersectLocal( bumpPos, list, listCount, (float4)( -normFace.x, -normFace.y, -normFace.z, 0), &dummyObjectIndex, &dummyFaceindex );
							if( t2 > 0 )
							{
								n2 = list[dummyObjectIndex].ior;
								curIndex = indexMap[dummyObjectIndex];
							}
							else
							{
								// The ray is towards air
								n2 = 1;
								curIndex = -1;
							}
						}
						else
						{
							// If curIndex == -1, then the ray is from air
							n1 = 1;
							n2 =objectData[objectIndex].ior;
							curIndex = objectIndex;
						}

						float4 refraction;
						// Check the angle between incident ray and norm
						if( curNextDir.x*norm.x + curNextDir.y*norm.y + curNextDir.z*norm.z > 0 )
							refraction = getRefractionDir( -norm, curNextDir, n1, n2 );
						else
							refraction = getRefractionDir( norm, curNextDir, n1, n2 );

						if( !EQ4(refraction, INVALID_DIR) )
						{
							rays[nextCount].nextPos = intersectPoint + refraction*EPSILON*2;
							rays[nextCount].nextPos.s3 = 1;
							rays[nextCount].nextDir = refraction;
							rays[nextCount].attenuation = rays[j].attenuation*objectData[objectIndex].transparent;
							rays[nextCount].curIndex = curIndex;
							nextCount++;
						}
						}
                                                }
			}
			else
			{
			}
		}
		last = curCount;
	}

	result.s0 = clamp(result.s0,0.f,1.f);
	result.s1 = clamp(result.s1,0.f,1.f);
	result.s2 = clamp(result.s2,0.f,1.f);
	result.s3 = clamp(result.s3,0.f,1.f);
	return result;
}

__kernel void raytrace(
    __global unsigned int* uiOutputImage,
	unsigned int width,
	unsigned int height,
	__global GlobalSettingDevice* globalSetting,
	__global LightDataDevice* lightData,
	int lightCount,
	__global ObjectDataDevice* objectData,
	int objectCount,
	float4 globalData,
	float4 eyePos,
        float eyeNear,
	float16 invMat,
	__global unsigned int* pixels,
	int pixelCount,
	__global unsigned int* offsets,
	int offsetCount,
	__global KdTreeNodeDevice* kdtreeNodes,
	int kdtreeNodeCount,
	__global ObjectNodeDevice* objectNodes,
	int objectNodeCount
	)
{
    size_t globalPosX = get_global_id(0);
    size_t globalPosY = get_global_id(1);

    if( globalPosX >= 0 && globalPosX < width && globalPosY >= 0 && globalPosY < height )
    {
		int k = 0, size = 1;
		float2 poses[5];
		poses[0] = (float2)(globalPosX, globalPosY);
		float weight = 1.f;
		float4 colorSum = (float4)(0,0,0,0);

		if( globalSetting->useSupersampling)
		{
			poses[1] = (float2)( globalPosX-0.5, globalPosY-0.5 );
			poses[2] = (float2)( globalPosX-0.5, globalPosY+0.5 );
			poses[3] = (float2)( globalPosX+0.5, globalPosY-0.5 );
			poses[4] = (float2)( globalPosX+0.5, globalPosY+0.5 );

			weight = 1.f/5;
			size = 5;
		}
		do
		{
			float4   pFilmCam = (float4)(((float)(2*poses[k].x))/width-1, 1-((float)(2*poses[k].y))/height, -1, 1);
			float4 pFilmWorld = matMult(invMat, pFilmCam );
			float4 d = pFilmWorld - eyePos;

			d = fast_normalize(d);
                        float4 eyePosNear = eyePos + d*eyeNear;
                        colorSum += weight*getPixelColor( eyePosNear, d, globalSetting, lightData, lightCount, objectData, objectCount, globalData, pixels, pixelCount, offsets, offsetCount, kdtreeNodes, kdtreeNodeCount, objectNodes, objectNodeCount );


			k++;
		}while(k<size);
		uiOutputImage[globalPosY*width + globalPosX] = rgbaFloat4ToUint(colorSum);
	}
}
