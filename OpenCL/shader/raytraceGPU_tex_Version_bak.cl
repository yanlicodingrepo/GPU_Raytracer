
//Macros
#define EPSILON 1e-4 // A very small number
#define POS_INF 0x7FFFFFFF // A very large number

#define EQ(a, b) (fabs((a) - (b)) < EPSILON)
#define SQ(x) (x)*(x)

#define MIN(x, y) ({       \
			(((x) < (y)) ? (x) : (y));			\
})

#define MAX_RECURSION 2

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
    int type;

    // Textures
    // Only support general texture. Bump texture not supported
    int texHandle;
    float blend;
    float2 repeat;
    int isUsed;
	int texMapID;

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
}GlobalSettingDevice;

// Sampler
__constant sampler_t sampler = CLK_NORMALIZED_COORDS_TRUE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_LINEAR;

// Forward declaration
inline unsigned int rgbaFloat4ToUint(float4 rgba);
inline float Det4x4(float16 M );
inline float16 Inverse4x4(float16 M);
inline float4 matMult(float16 M, float4 v);
inline float16 transpose(float16 M);
inline int EQ4( float4 v1, float4 v2);

float doIntersectPlane( float3 point, float3 norm, float4 eyePos, float4 d);

float
intersect( float4 eyePos,		   
		   __global ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   float3 * norm,
		   int * objectIndex,
		   float4 *textureColor,
		   __read_only image2d_t texture0,
		   __read_only image2d_t texture1,
		   __read_only image2d_t texture2,
		   __read_only image2d_t texture3
	);

float
doIntersect(ObjectDataDevice* object,
			float4 eyePos,
			float4 d,
			float3 *norm,
			float4 *textureColor,
			__read_only image2d_t texture0,
			__read_only image2d_t texture1,
			__read_only image2d_t texture2,
			__read_only image2d_t texture3
	);

float
doIntersectUnitCone(
	float4 eyePos,
	float4  d,
	float3 *norm,
	int *minIndex
	);

float4 getConeIntersectTexColor( ObjectDataDevice* object,
								 int index,
								 float t,
								 float4 eyePos,
								 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
	);

float
doIntersectUnitCube(
	float4 eyePos,
	float4 d,
	float3 *norm,
	int *minIndex
	);

float4 getCubeIntersectTexColor( ObjectDataDevice* object,
								 int index,
								 float t,
								 float4 eyePos,
								 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
	);

float
doIntersectUnitCylinder(
	float4 eyePos,
	float4 d,
	float3 *norm,
	int *minIndex
	);

float4 getCylinderIntersectTexColor( ObjectDataDevice* object,
									 int index,
									 float t,
									 float4 eyePos,
									 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
	);

float
doIntersectUnitSphere(
	float4 eyePos,
	float4 d,
	float3 *norm
	);

float4 getSphereIntersectTexColor( ObjectDataDevice*  object,
                                          float t,
                                          float4 eyePos,
                                          float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
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
		 __read_only image2d_t texture0,
		   __read_only image2d_t texture1,
		   __read_only image2d_t texture2,
		   __read_only image2d_t texture3
	);
float4 getPixelColor( float4 eyePos,
					  float4 d,
					  __global GlobalSettingDevice* globalSetting,
					  __global LightDataDevice* lightData,
					  int lightCount,
					  __global ObjectDataDevice* objectData,
					  int objectCount,
					  float4 globalData,
					  	__read_only image2d_t texture0,
						__read_only image2d_t texture1,
						__read_only image2d_t texture2,
						__read_only image2d_t texture3
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
						float16 invMat,
					    __read_only image2d_t texture0,
						__read_only image2d_t texture1,
						__read_only image2d_t texture2,
						__read_only image2d_t texture3
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
	float3 *norm,
	int *minIndex
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
			*norm = norms[i];
			*minIndex = i;
		}
	}
	if( minT != POS_INF )
		result = minT;

	return result;
}

float4 getConeIntersectTexColor( ObjectDataDevice* object,
								 int index,
								 float t,
								 float4 eyePos,
								 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
                                          )
{
    float4 resultColor = (float4)(0,0,0,0);

    if( t > 0 )
    {
        float4 intersect = eyePos + t*d;
		//       int width = object.m_texture.m_texWidth;
        //int height = object.m_texture.m_texHeight;

//        int x,y;
        float2 texCoord;
        switch( index )
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
                // x = (int)((width-1)*u);
                // y = (int)((height-1)*v);
                break;
            }
        default:
            break;
        }
        /*float4 texColor = object.m_texture.m_texPointer[width*y+x];
        unsigned char col[4];
        memcpy(col, &texColor, sizeof(unsigned));*/
		switch( object->texMapID )
		{
		case 0:resultColor = read_imagef(texture0, sampler, texCoord); break;
		case 1:resultColor = read_imagef(texture1, sampler, texCoord);break;
		case 2:resultColor = read_imagef(texture2, sampler, texCoord);break;
		case 3:resultColor = read_imagef(texture3, sampler, texCoord);break;
		default:break;
		}
    }
    return resultColor;
}

float doIntersectUnitCube(
	float4 eyePos,
	float4 d,
	float3 *norm,
	int *minIndex
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
			*norm = norms[i];
			*minIndex = i;
		}
	}
	if(minT != POS_INF)
		result = minT;

	return result;
}

float4 getCubeIntersectTexColor( ObjectDataDevice* object,
								 int index,
								 float t,
								 float4 eyePos,
								 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
	)
{
    float4 resultColor = (float4)(0,0,0,0);
    if( t > 0 )
    {
        float4 intersect = eyePos + t*d;
		// int width = object.m_texture.m_texWidth;
        //int height = object.m_texture.m_texHeight;

        //int y,x;

		float2 texCoord;
        switch( index )
        {
        // front
        case 0:
        {
            //y = (int)((height-1)*(( intersect.y+ 0.5 )));
            //x = (int)((width-1)*(( intersect.x + 0.5 )));
            texCoord.s0 =  intersect.x+ 0.5;
			texCoord.s1 =  intersect.y+ 0.5;
			break;
        }
            // back
        case 1:
        {
            //y = (int)((height-1)*(( intersect.y+ 0.5 )));
            //x = (int)((width-1)*(( 0.5 - intersect.x )));
			texCoord.s0 =  0.5 - intersect.x;
			texCoord.s1 =  intersect.y+ 0.5;
            break;
        }
            // left
        case 2:
        {
            //y = (int)((height-1)*((  intersect.y + 0.5 )));
            //x = (int)((width-1)*(( intersect.z + 0.5 )));
			texCoord.s0 =  intersect.z + 0.5;
			texCoord.s1 =  intersect.y + 0.5;
            break;
        }
            // right
        case 3:
        {
            //y = (int)((height-1)*(( 0.5+ intersect.y )));
            //x = (int)((width-1)*(( 0.5- intersect.z )));
			texCoord.s0 =  0.5 - intersect.z;
			texCoord.s1 =  intersect.y + 0.5;
            break;
        }
            // top
        case 4:
        {
            //y = (int)((height-1)*(( 0.5- intersect.z )));
            //x = (int)((width-1)*(( 0.5+ intersect.x )));
			texCoord.s0 =  0.5 + intersect.x;
			texCoord.s1 =  0.5 - intersect.z;
            break;
        }
            // down
        case 5:
        {
            //y = (int)((height-1)*(( 0.5+ intersect.z )));
            //x = (int)((width-1)*(( 0.5+ intersect.x )));
			texCoord.s0 =  0.5 + intersect.x;
			texCoord.s1 =  0.5 + intersect.z;
            break;
        }
        default:
            break;
        }
       switch( object->texMapID )
		{
		case 0:resultColor = read_imagef(texture0, sampler, texCoord); break;
		case 1:resultColor = read_imagef(texture1, sampler, texCoord);break;
		case 2:resultColor = read_imagef(texture2, sampler, texCoord);break;
		case 3:resultColor = read_imagef(texture3, sampler, texCoord);break;
		default:break;
		}
    }
    return resultColor;
}

float doIntersectUnitCylinder(
	float4 eyePos,
	float4 d,
	float3 *norm,
	int *minIndex
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
	norms[2] = (float3)(eyePos.x+t[2]*d.x,0,eyePos.z+t[2]*d.z);
	norms[2] = fast_normalize(norms[2]);

	float minT = POS_INF;
	for( int i = 0; i < 3; i++ )
	{
		if(t[i]>0&&t[i]<minT)
		{
			minT = t[i];
			*norm = norms[i];
			*minIndex = i;
		}
	}

	if( minT != POS_INF )
		result = minT;
	
	return result;
}

float4 getCylinderIntersectTexColor( ObjectDataDevice* object,
									 int index,
									 float t,
									 float4 eyePos,
									 float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
									 __read_only image2d_t texture3
	)
{
    float4 resultColor = (float4)(1,1,1,1);
    //resultColor.r = resultColor.g = resultColor.b = resultColor.a = 0;

    if( t > 0 )
    {
        float4 intersect = eyePos + t*d;
        //int width = object.m_texture.m_texWidth;
        //int height = object.m_texture.m_texHeight;
        //int y,x;
        float2 texCoord;
        switch( index )
        {
            // bottom
        case 0:
            {
                texCoord.s0 = (0.5 + intersect.x);
                texCoord.s1 = 1 - (0.5 - intersect.z);
				//  x = (int)((width-1)*u);
                //y = (int)((height-1)*v);

                break;
            }
            // top
        case 1:
            {
                texCoord.s0 = (0.5 + intersect.x);
                texCoord.s1 = (0.5 - intersect.z);
                //x = (int)((width-1)*u);
                //y = (int)((height-1)*v);
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
                // x = (int)((width-1)*u);
                // y = (int)((height-1)*v);
                break;
            }
        default:
            //assert(0);
            break;
        }

		/*  unsigned texColor = object.m_texture.m_texPointer[width*y+x];
        unsigned char col[4];
        memcpy(col, &texColor, sizeof(unsigned));

        resultColor.r = (float)col[0]/255.f;
        resultColor.g = (float)col[1]/255.f;
        resultColor.b = (float)col[2]/255.f;
        resultColor.a = 0;
		*/

		switch( object->texMapID )
		{
		case 0:resultColor = read_imagef(texture0, sampler, texCoord); break;
		case 1:resultColor = read_imagef(texture1, sampler, texCoord);break;
		case 2:resultColor = read_imagef(texture2, sampler, texCoord);break;
		case 3:resultColor = read_imagef(texture3, sampler, texCoord);break;
		default:break;
		}
    }
    return resultColor;
}

float doIntersectUnitSphere(
	float4 eyePos,
	float4 d,
	float3 *norm
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
		norms = (float3)(eyePos.x + t*d.x, eyePos.y + t*d.y, eyePos.z + t*d.z );
		norms = fast_normalize(norms);
		*norm = norms;
		result = t;
	}

	return result;
}

float4 getSphereIntersectTexColor( ObjectDataDevice*  object,
                                          float t,
                                          float4 eyePos,
								   float4 d,
								 __read_only image2d_t texture0,
								 __read_only image2d_t texture1,
								 __read_only image2d_t texture2,
								 __read_only image2d_t texture3
                                          )
{
	float4 resultColor = (float4)(0,0,0,0);

    // Get the texture color if the following condition is satisfied
    if( t > 0 )
    {
        float4 intersectPoint = eyePos + t*d;
        // int width = object.m_texture.m_texWidth;
        // int height = object.m_texture.m_texHeight;
        // int y,x;

        float4 Vn  = (float4)(0,1,0,0);
        float4 Ve = (float4)(1,0,0,0);
        float4 Vp = intersectPoint;
		Vp.s3 = 0;
		Vp = fast_normalize(Vp);
        float phi = acos( -dot( Vn, Vp ) );
        float2 texCoord;
		texCoord.s1 = phi/M_PI;

        float theta = (acos(dot(Vp,Ve)/sin(phi)))/(2*M_PI);
        theta = atan2( Vp.z, Vp.x );
        if( theta < 0 )
        {
            theta = theta + 2*M_PI;
        }
        texCoord.s0 = 1- theta/(2*M_PI);
        //x = (int)((width - 1)*u);
        //y = (int)((height - 1)*v);
		
		switch( object->texMapID )
		{
		case 0:resultColor = read_imagef(texture0, sampler, texCoord); break;
		case 1:resultColor = read_imagef(texture1, sampler, texCoord);break;
		case 2:resultColor = read_imagef(texture2, sampler, texCoord);break;
		case 3:resultColor = read_imagef(texture3, sampler, texCoord);break;
		default:break;
		}

    }
    return resultColor;
}

float
intersect( float4 eyePos,		   
		   __global ObjectDataDevice* objectData,
		   int objectCount,
		   float4 d,
		   float3 * norm,
		   int * objectIndex,
		   float4* textureColor,
		   __read_only image2d_t texture0,
		   __read_only image2d_t texture1,
		   __read_only image2d_t texture2,
		   __read_only image2d_t texture3
	)
{


	float minT = POS_INF;
        float resultT = -1;
        for( int i = 0; i < objectCount; i++ )
	{
		
		ObjectDataDevice current = objectData[i];
		float16 invCompMat = Inverse4x4( current.transform );

		float4 eyePosObjSpace = matMult(invCompMat, eyePos);
		float4 dObjSpace = matMult(invCompMat, d);

		float3 tempNorm;
		float4 tempTexColor;
        float t = doIntersect( &current, eyePosObjSpace, dObjSpace, &tempNorm, &tempTexColor, texture0, texture1, texture2, texture3 );

		if( t>0 && t < minT )
		{
			minT = t;
			*norm = tempNorm;
			*objectIndex = i;
			*textureColor = tempTexColor;
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
			float3 *norm,
			float4* textureColor,
			__read_only image2d_t texture0,
			__read_only image2d_t texture1,
			__read_only image2d_t texture2,
			__read_only image2d_t texture3			
	)
{
	float t = -1;
	int minIndex;
	switch( object->type )
	{
        case 1:
	{
		t = doIntersectUnitCube( eyePos, d, norm, &minIndex );
		break;
	}
        case 2:
	{
		t = doIntersectUnitCone( eyePos, d, norm, &minIndex );
		break;
	}
        case 3:
	{
		t = doIntersectUnitCylinder( eyePos, d, norm, &minIndex );
		break;
	}
        case 5:
	{
		t = doIntersectUnitSphere(  eyePos, d, norm );
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
	// Then get the tex color
	if( t > 0 && object->texHandle && object->texMapID < 4 )
	{
		switch( object->type )
		{
		case 1:
		{
			*textureColor = getCubeIntersectTexColor(object, minIndex, t, eyePos, d, texture0, texture1, texture2, texture3 );
			break;
		}
		case 2:
		{
			*textureColor = getConeIntersectTexColor(object, minIndex, t, eyePos, d, texture0, texture1, texture2, texture3 );
			break;
		}
		case 3:
		{
			*textureColor = getCylinderIntersectTexColor(object, minIndex, t, eyePos, d, texture0, texture1, texture2, texture3  );
			break;
		}
		case 5:
		{
			*textureColor = getSphereIntersectTexColor(object, t, eyePos, d, texture0, texture1, texture2, texture3 );
			break;
		}
		case PRIMITIVE_TORUS:
		{
			break;
		}
		case PRIMITIVE_MESH:
		{
			break;
		}
		default:
		{
			break;
		}
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
		 __read_only image2d_t texture0,
		   __read_only image2d_t texture1,
		   __read_only image2d_t texture2,
		   __read_only image2d_t texture3
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

        //float dotLN = lightDir.x*norm.x + lightDir.y*norm.y + lightDir.z*norm.z;
        
// in intersect assignment, this is used for checking if the object is in shadow
		float dotLN = dot( lightDir, norm4 );
        if( dotLN < 0.0)
            dotLN = 0.0;

       // Check if the object is in shadow of light
       if( globalSetting->useShadow )
        {
           float3 tempNorm;
           int index = -1;
           float4 lightPos;
		   float4 dummyTexColor;
           if( currentLight.type != LIGHT_DIRECTIONAL )
		   {
               lightPos = currentLight.pos;
			   intersect( lightPos, objects, objectCount, (-lightDir), &tempNorm, &index, &dummyTexColor, texture0, texture1, texture2, texture3);
		   }
           else
           {
			   intersect( pos + (norm4)*EPSILON, objects, objectCount, (lightDir), &tempNorm, &index, &dummyTexColor, texture0, texture1, texture2, texture3 );
            }
          
          
           // this means the object is in shadow

           // We don't need to check if intersectpoint is equal to pos because the pos we
           // pass into this function is always the first point intersected of each shape
           if( index != objectIndex && index != -1 )
                   continue;
                   
        }

        // compute diffuse light color
        // if using texture mapping, then blend the diffuse with diffuse color
       if( globalSetting->showTexture && object.texHandle && object.texMapID < 4 && object.isUsed )
       {
           float blend =0;
           if( object.blend >=0 && object.blend <= 1 )
                blend = object.blend;

		   lightSum += attenuation*lightIntensity*dotLN*(globalData.s1*((object.diffuse*(1-blend)) + textureColor*blend));
          
       }
       else
       {
           // simply compute diffuse color

		    lightSum += attenuation*lightIntensity*dotLN*globalData.s1*(object.diffuse);
	   }
       float projection = dotLN;

       // No specular

        // the following steps are computing the specular color
        float4 sight = eyePos - pos;
        sight = fast_normalize(sight);

        float4 temp4 = (float4)(2*projection*norm.x, 2*projection*norm.y, 2*projection*norm.z, 0);

        float4 reflection = temp4 - lightDir;
        reflection = fast_normalize(reflection);
        float dotEN  = sight.x*reflection.x + sight.y*reflection.y + sight.z*reflection.z;
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
					  __read_only image2d_t texture0,
					  __read_only image2d_t texture1,
					  __read_only image2d_t texture2,
					  __read_only image2d_t texture3
	)
{

	float4 result = (float4)(0, 0, 0, 0);
	float4 nextPos = eyePos;
	float4 nextDir = d;
	float4 lastk = (float4)(1,1,1,1);
    for( int i = 0; i < globalSetting->traceRecursion; i++ )
	{
		float4 texColor = (float4)(0, 0, 0, 0);
		int objectIndex;
		float3 norm;
		float t = intersect( nextPos, objectData, objectCount, nextDir, &norm, &objectIndex, &texColor, texture0, texture1, texture2, texture3 );


		if( t > 0 )
		{
			float4 colorNormal = (float4)(0, 0, 0, 0);
			//	float4 colorReflection = (float4)(0, 0, 0, 0);

			float4 intersectPoint = nextPos + t*nextDir;
			float4 tempNorm = (float4)( norm.s0, norm.s1, norm.s2, 0);

			float16 compMat = objectData[objectIndex].transform;
			compMat.s3 = 0;
			compMat.s7 = 0;
			compMat.sb = 0;
			float16 invMat = Inverse4x4(compMat);
			float16 invTransposeMat = transpose(invMat);
			tempNorm = matMult( invTransposeMat, tempNorm );
			norm = (float3)(tempNorm.s0, tempNorm.s1, tempNorm.s2);
			norm = fast_normalize(norm);

			colorNormal = computeObjectColor( objectIndex, objectData, objectCount, lightData, lightCount, globalSetting, globalData, intersectPoint, norm, nextPos, texColor, texture0, texture1, texture2, texture3 );

			if( globalSetting->useReflection )
			{					
				if( i >= 1 )
				{
					colorNormal = colorNormal*lastk;
				}
				lastk *= globalData.s2*objectData[objectIndex].reflective;
				float4 sight = fast_normalize(nextPos - intersectPoint);
				
				float projection = sight.x*norm.x + sight.y*norm.y + sight.z*norm.z;

				if( projection > 0 )
				{
					float4 norm4 = (float4)(norm.x, norm.y, norm.z, 0);
					float4 reflection = fast_normalize(2*projection*norm4 - sight);

					nextPos = intersectPoint + reflection*EPSILON;
					nextPos.s3 = 1;
					nextDir = reflection;
					result += colorNormal;
				}
				else
				{
					break;
				}
			}
			else
			{
				result += colorNormal;
				break;
			}
		}
		else
		{
			break;
		}
	}
	result.s0 = clamp(result.s0,0.f,1.f);
	result.s1 = clamp(result.s1,0.f,1.f);
	result.s2 = clamp(result.s2,0.f,1.f);
	result.s3 = clamp(result.s3,0.f,1.f);
	return result;
}

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
						float16 invMat,
						__read_only image2d_t texture0,
						__read_only image2d_t texture1,
						__read_only image2d_t texture2,
						__read_only image2d_t texture3
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

				colorSum += weight*getPixelColor( eyePos, d, globalSetting, lightData, lightCount, objectData, objectCount, globalData, texture0, texture1, texture2, texture3 );


				k++;
			}while(k<size);
        uiOutputImage[globalPosY*width + globalPosX] = rgbaFloat4ToUint(colorSum);
    }

}
