/*!
    @file View.h
    @author: yanli
    @date: May 2013
 */

#ifndef VIEW3D_H
#define VIEW3D_H


#include <qgl.h>
#include <QTime>
#include <QTimer>
#include <QHash>
#include <QVector>
#include <QString>
#include "global.h"
#include "camera.h"
#include "vector.h"
#include "CL/cl.h"
#include "GPUrayscene.h"
#include "GL/glu.h"

class Scene;
class Cube;
class Cone;


struct VboHandles
{
    GLuint cubeVBO;
    GLuint cubeElementVBO;
    GLuint cylinderVBO;
    GLuint cylinderElementVBO;
    GLuint coneVBO;
    GLuint coneElementVBO;
    GLuint sphereVBO;
    GLuint sphereElementVBO;
};

struct CLPack
{
    cl_platform_id m_platform;
    cl_context m_context;
    cl_command_queue m_queue;
    cl_program m_program;
    cl_uint m_uiDevCount;
    cl_device_id m_device;
    cl_kernel m_kernelRay;

    cl_mem m_cmPbo;
    cl_mem m_cmOut;

    size_t m_localWorkSize[2];
    size_t m_globalWorkSize[2];
    QVector<cl_device_id> m_deviceList;
};

class View3D : public QGLWidget
{
    Q_OBJECT

public:

    enum ShapeType
    {
        CUBE = 0,
        CYLINDER,
        SPHERE,
        CONE
    };

    View3D(QWidget *parent);
    ~View3D();

    Scene* loadScene( const QString& sceneName );
      void backGPUScene();
    inline OrbitCamera* getCamera(){ return &m_camera; }
    inline const VboHandles* getVBOs(){ return &m_vbos; }

    Scene* getScene();

    void traceScene();

    inline void activateGPUtrace( bool checked) { m_gpuActivated = checked; }
    inline bool isActivatedGPUtrace(){ return m_gpuActivated;}
    inline void syncGPUGlobalSetting(){if(m_gpuscene)m_gpuscene->syncGlobalSettings(); }

private:

    QTimer m_timer;
    QTime m_clock;
    int m_prevTime;
    float m_prevFps, m_fps;
    float m_delta;

    bool m_mouseLeftDown;
    bool m_mouseRightDown;
    bool m_mouseMiddleDown;

    bool m_gpuActivated;

    bool mouse_move;
    bool m_useGPU;
    bool m_supportGPU;

    OrbitCamera m_camera;
    //QFont m_font; // font for rendering text

    GLuint m_fontBase; // Display list base for font, we are goint to use texture font
    GLuint m_fontHandle;

    Scene* m_scene; // scene

    GPURayScene* m_gpuscene;

    VboHandles m_vbos;

    int m_curShape;

    CLPack m_cl;

    GLuint m_testTex;

    GLuint m_screenTex;

    GLuint m_pbo;

    unsigned int* m_bufImage;

    GLUquadric* m_quad; // For drawing quadric

private:
    // GL functions

    void initializeGL();
    void paintGL();
    void initCL();
    void releaseCL();
    void initCLProgramAndKernel();
    void renderScene();
    void resizeGL(int width, int height);

    // Mouse handler
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);

    void keyPressEvent(QKeyEvent *event);
    void keyReleaseEvent(QKeyEvent *event);

    // paint text
    void paintText();

    void updateTime();

    void drawAxis();

    void initializeShapes();

    void releaseShapes();

    void initResources();

    void drawShape( ShapeType type, bool drawNormals );

    void testOpenCL();

    void initBuffer();

    void createPBO( GLuint* pbo, const int imageWidth, const int imageHeight );

    void deletePBO(GLuint* pbo );

    void GPUrender();

    void genFontDisplayList();

    void killFont();

    void printText( int x, int y, const char* string, int set );

private slots:
    void tick();
};

#endif // View_H
