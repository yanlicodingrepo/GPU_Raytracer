/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created: Thu Jul 4 18:04:47 2013
**      by: Qt User Interface Compiler version 4.8.4
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QCheckBox>
#include <QtGui/QDockWidget>
#include <QtGui/QGroupBox>
#include <QtGui/QHeaderView>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QPushButton>
#include <QtGui/QRadioButton>
#include <QtGui/QStatusBar>
#include <QtGui/QTabWidget>
#include <QtGui/QWidget>
#include "view2d.h"
#include "view3d.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionOpen;
    QAction *actionExit;
    QWidget *centralwidget;
    QTabWidget *tabWidget;
    QWidget *tab_1;
    View3D *view3D;
    QWidget *tab_2;
    View2D *view2D;
    QMenuBar *menubar;
    QMenu *menuFile;
    QStatusBar *statusbar;
    QDockWidget *dockWidget;
    QWidget *dockWidgetContents;
    QGroupBox *groupBox;
    QRadioButton *radioButtonGPUTrace;
    QRadioButton *radioButtonCPUTrace;
    QCheckBox *checkBox_shadow;
    QCheckBox *checkBox_spot_light;
    QCheckBox *checkBox_point_light;
    QCheckBox *checkBox_supersampling;
    QCheckBox *checkBox_dir_light;
    QCheckBox *checkBox_multi_thread;
    QCheckBox *checkBox_use_kdtree;
    QPushButton *traceButton;
    QPushButton *stopButton;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(961, 741);
        actionOpen = new QAction(MainWindow);
        actionOpen->setObjectName(QString::fromUtf8("actionOpen"));
        actionExit = new QAction(MainWindow);
        actionExit->setObjectName(QString::fromUtf8("actionExit"));
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        tabWidget = new QTabWidget(centralwidget);
        tabWidget->setObjectName(QString::fromUtf8("tabWidget"));
        tabWidget->setGeometry(QRect(20, 10, 600, 630));
        tab_1 = new QWidget();
        tab_1->setObjectName(QString::fromUtf8("tab_1"));
        view3D = new View3D(tab_1);
        view3D->setObjectName(QString::fromUtf8("view3D"));
        view3D->setGeometry(QRect(-1, -1, 600, 600));
        tabWidget->addTab(tab_1, QString());
        tab_2 = new QWidget();
        tab_2->setObjectName(QString::fromUtf8("tab_2"));
        view2D = new View2D(tab_2);
        view2D->setObjectName(QString::fromUtf8("view2D"));
        view2D->setGeometry(QRect(0, 0, 600, 600));
        tabWidget->addTab(tab_2, QString());
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 961, 29));
        menuFile = new QMenu(menubar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        MainWindow->setStatusBar(statusbar);
        dockWidget = new QDockWidget(MainWindow);
        dockWidget->setObjectName(QString::fromUtf8("dockWidget"));
        dockWidget->setMinimumSize(QSize(176, 41));
        dockWidgetContents = new QWidget();
        dockWidgetContents->setObjectName(QString::fromUtf8("dockWidgetContents"));
        groupBox = new QGroupBox(dockWidgetContents);
        groupBox->setObjectName(QString::fromUtf8("groupBox"));
        groupBox->setGeometry(QRect(10, 20, 171, 391));
        radioButtonGPUTrace = new QRadioButton(groupBox);
        radioButtonGPUTrace->setObjectName(QString::fromUtf8("radioButtonGPUTrace"));
        radioButtonGPUTrace->setGeometry(QRect(10, 110, 131, 26));
        radioButtonGPUTrace->setChecked(false);
        radioButtonCPUTrace = new QRadioButton(groupBox);
        radioButtonCPUTrace->setObjectName(QString::fromUtf8("radioButtonCPUTrace"));
        radioButtonCPUTrace->setGeometry(QRect(10, 140, 131, 26));
        radioButtonCPUTrace->setChecked(true);
        checkBox_shadow = new QCheckBox(groupBox);
        checkBox_shadow->setObjectName(QString::fromUtf8("checkBox_shadow"));
        checkBox_shadow->setGeometry(QRect(10, 180, 141, 26));
        checkBox_spot_light = new QCheckBox(groupBox);
        checkBox_spot_light->setObjectName(QString::fromUtf8("checkBox_spot_light"));
        checkBox_spot_light->setGeometry(QRect(10, 240, 94, 26));
        checkBox_spot_light->setChecked(false);
        checkBox_point_light = new QCheckBox(groupBox);
        checkBox_point_light->setObjectName(QString::fromUtf8("checkBox_point_light"));
        checkBox_point_light->setGeometry(QRect(10, 270, 94, 26));
        checkBox_point_light->setChecked(true);
        checkBox_supersampling = new QCheckBox(groupBox);
        checkBox_supersampling->setObjectName(QString::fromUtf8("checkBox_supersampling"));
        checkBox_supersampling->setGeometry(QRect(10, 210, 131, 26));
        checkBox_dir_light = new QCheckBox(groupBox);
        checkBox_dir_light->setObjectName(QString::fromUtf8("checkBox_dir_light"));
        checkBox_dir_light->setGeometry(QRect(10, 300, 131, 26));
        checkBox_dir_light->setChecked(true);
        checkBox_multi_thread = new QCheckBox(groupBox);
        checkBox_multi_thread->setObjectName(QString::fromUtf8("checkBox_multi_thread"));
        checkBox_multi_thread->setGeometry(QRect(10, 330, 151, 26));
        checkBox_use_kdtree = new QCheckBox(groupBox);
        checkBox_use_kdtree->setObjectName(QString::fromUtf8("checkBox_use_kdtree"));
        checkBox_use_kdtree->setEnabled(true);
        checkBox_use_kdtree->setGeometry(QRect(10, 360, 141, 26));
        checkBox_use_kdtree->setChecked(true);
        traceButton = new QPushButton(dockWidgetContents);
        traceButton->setObjectName(QString::fromUtf8("traceButton"));
        traceButton->setGeometry(QRect(40, 440, 96, 31));
        stopButton = new QPushButton(dockWidgetContents);
        stopButton->setObjectName(QString::fromUtf8("stopButton"));
        stopButton->setGeometry(QRect(40, 480, 96, 31));
        dockWidget->setWidget(dockWidgetContents);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), dockWidget);

        menubar->addAction(menuFile->menuAction());
        menuFile->addAction(actionOpen);
        menuFile->addAction(actionExit);

        retranslateUi(MainWindow);

        tabWidget->setCurrentIndex(1);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0, QApplication::UnicodeUTF8));
        actionOpen->setText(QApplication::translate("MainWindow", "Open", 0, QApplication::UnicodeUTF8));
        actionExit->setText(QApplication::translate("MainWindow", "Exit", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_1), QApplication::translate("MainWindow", "View3D", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_2), QApplication::translate("MainWindow", "View2D", 0, QApplication::UnicodeUTF8));
        menuFile->setTitle(QApplication::translate("MainWindow", "File", 0, QApplication::UnicodeUTF8));
        groupBox->setTitle(QApplication::translate("MainWindow", "Option", 0, QApplication::UnicodeUTF8));
        radioButtonGPUTrace->setText(QApplication::translate("MainWindow", "GPU Raytracing", 0, QApplication::UnicodeUTF8));
        radioButtonCPUTrace->setText(QApplication::translate("MainWindow", "CPU Raytracing", 0, QApplication::UnicodeUTF8));
        checkBox_shadow->setText(QApplication::translate("MainWindow", "Use shadow", 0, QApplication::UnicodeUTF8));
        checkBox_spot_light->setText(QApplication::translate("MainWindow", "Spot light", 0, QApplication::UnicodeUTF8));
        checkBox_point_light->setText(QApplication::translate("MainWindow", "Point light", 0, QApplication::UnicodeUTF8));
        checkBox_supersampling->setText(QApplication::translate("MainWindow", "Supersampling", 0, QApplication::UnicodeUTF8));
        checkBox_dir_light->setText(QApplication::translate("MainWindow", "Directional light", 0, QApplication::UnicodeUTF8));
        checkBox_multi_thread->setText(QApplication::translate("MainWindow", "Multi-thread (CPU)", 0, QApplication::UnicodeUTF8));
        checkBox_use_kdtree->setText(QApplication::translate("MainWindow", "Use KdTree", 0, QApplication::UnicodeUTF8));
        traceButton->setText(QApplication::translate("MainWindow", "Trace", 0, QApplication::UnicodeUTF8));
        stopButton->setText(QApplication::translate("MainWindow", "Stop", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
