#ifndef LIRC_CONNECTION_H
#define LIRC_CONNECTION_H

#include <QObject>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QDebug>

class LircConnection : public QObject
{
    Q_OBJECT
public:
    explicit LircConnection(QObject *parent = 0);

    void doConnect();

signals:

public slots:
    void connected();
    void disconnected();
    void bytesWritten(qint64 bytes);
    void readyRead();

private:
    QTcpSocket *socket;

};

#endif
