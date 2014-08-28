#ifndef CLDUMPGPUINFO_H
#define CLDUMPGPUINFO_H

#include "CL/cl.h"
#include <QVector>
#include <QString>
void dumpGPUInfo();

QVector<cl_platform_id> getPlatformList();
QVector<cl_device_id> getDeviceList(cl_platform_id platform, cl_device_type type);
QString getPlatformName(cl_platform_id platform);
QString getDeviceName(cl_device_id device);

#endif // CLDUMPGPUINFO_H
