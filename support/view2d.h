#ifndef VIEW2D_H
#define VIEW2D_H

#include <QWidget>
#include "CS123Common.h"
#include "global.h"

class Scene;
class CPURayScene;
class OrbitCamera;

class View2D : public QWidget
{
    Q_OBJECT
public:
    View2D( QWidget *parent );
    ~View2D();

    BGRA *data() { return (BGRA *)m_image->bits(); }

    void resize( int width, int height );

    bool loadImage(const QString &file);
    bool saveImage(const QString &file);


    //! Load a black 500x500 image
    void newImage();

    //! Show a file dialog and perform the save action if the user picks a file.  Return true on success.
    bool saveImage();
    
    void setScene( CPURayScene* scene );

    void traceScene( OrbitCamera* camera, int width, int height );

protected:

    virtual void paintEvent(QPaintEvent *);  /// overridden from SupportCanvas2D

   /* virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseMoveEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);
    virtual void mouseDown(int x, int y);    /// called when the left mouse button is pressed down on the canvas
    virtual void mouseDragged(int x, int y); /// called when the left mouse button is dragged on the canvas
    virtual void mouseUp(int x, int y);      /// called when the left mouse button is released
*/
    QImage *m_image;


signals:
    
public slots:

private:

    CPURayScene* m_scene;
};

#endif // CANVAS2D_H
