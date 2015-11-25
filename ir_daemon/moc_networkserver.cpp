/****************************************************************************
** Meta object code from reading C++ file 'networkserver.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.3.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "networkserver.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'networkserver.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.3.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_NetworkServer_t {
    QByteArrayData data[7];
    char stringdata[97];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_NetworkServer_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_NetworkServer_t qt_meta_stringdata_NetworkServer = {
    {
QT_MOC_LITERAL(0, 0, 13),
QT_MOC_LITERAL(1, 14, 17),
QT_MOC_LITERAL(2, 32, 0),
QT_MOC_LITERAL(3, 33, 10),
QT_MOC_LITERAL(4, 44, 15),
QT_MOC_LITERAL(5, 60, 19),
QT_MOC_LITERAL(6, 80, 16)
    },
    "NetworkServer\0startNewRaceEvent\0\0"
    "resetEvent\0newLapTimeEvent\0"
    "incommingConnection\0incommingCommand"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_NetworkServer[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   39,    2, 0x06 /* Public */,
       3,    0,   40,    2, 0x06 /* Public */,
       4,    2,   41,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    0,   46,    2, 0x0a /* Public */,
       6,    1,   47,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString, QMetaType::UInt,    2,    2,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    2,

       0        // eod
};

void NetworkServer::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        NetworkServer *_t = static_cast<NetworkServer *>(_o);
        switch (_id) {
        case 0: _t->startNewRaceEvent(); break;
        case 1: _t->resetEvent(); break;
        case 2: _t->newLapTimeEvent((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< uint(*)>(_a[2]))); break;
        case 3: _t->incommingConnection(); break;
        case 4: _t->incommingCommand((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (NetworkServer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&NetworkServer::startNewRaceEvent)) {
                *result = 0;
            }
        }
        {
            typedef void (NetworkServer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&NetworkServer::resetEvent)) {
                *result = 1;
            }
        }
        {
            typedef void (NetworkServer::*_t)(QString , unsigned int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&NetworkServer::newLapTimeEvent)) {
                *result = 2;
            }
        }
    }
}

const QMetaObject NetworkServer::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_NetworkServer.data,
      qt_meta_data_NetworkServer,  qt_static_metacall, 0, 0}
};


const QMetaObject *NetworkServer::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NetworkServer::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_NetworkServer.stringdata))
        return static_cast<void*>(const_cast< NetworkServer*>(this));
    if (!strcmp(_clname, "Singleton<NetworkServer>"))
        return static_cast< Singleton<NetworkServer>*>(const_cast< NetworkServer*>(this));
    return QObject::qt_metacast(_clname);
}

int NetworkServer::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void NetworkServer::startNewRaceEvent()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void NetworkServer::resetEvent()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void NetworkServer::newLapTimeEvent(QString _t1, unsigned int _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_END_MOC_NAMESPACE
