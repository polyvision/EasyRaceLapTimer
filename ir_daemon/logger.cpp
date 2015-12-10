#include "logger.h"

#include <math.h>
#include <ctype.h>
#include <algorithm>

#include <syslog.h>
#include <cstdarg>
#include <stdarg.h>
#include <stdio.h>

#include <QDateTime>
#include "configuration.h"

#define SYSLOG_MESSAGE_BUFFER_SIZE 4000

char const * Logger::SeveritiesShort[] = {
    "ERR",
    "WRN",
    "INF",
    "DBG",
    "TRC"
};

Logger::Logger()
{
}

bool Logger::init()
{
    m_location = Configuration::instance()->logLocations();
    m_severity = Configuration::instance()->logSeverity();

    return true;
}

void Logger::log(int facility, Severity severity, const char *format, ...)
{
    Q_UNUSED(facility);

    if(!enabled(severity))
        return;

    QByteArray newFormat = QString("%1: %2").arg(SeveritiesShort[severity], format).toLocal8Bit();

    if(m_location & CONSOLE) {
        va_list vl;
        va_start(vl, format);
        FILE *dest = severity <= WARNING ? stderr : stdout;
        fprintf(dest, "%s - ", qPrintable(QDateTime::currentDateTime().toString("yyyy-MM-ddThh:mm:ss.zzz")));
        vfprintf(dest, newFormat.constData(), vl);
        va_end(vl);
    }
    else if(m_location & SYSLOG) {
        char buffer[SYSLOG_MESSAGE_BUFFER_SIZE];
        buffer[0] = 0;

        va_list vl;
        va_start(vl, format);
        if (SYSLOG_MESSAGE_BUFFER_SIZE <= vsnprintf(buffer, SYSLOG_MESSAGE_BUFFER_SIZE, newFormat.constData(), vl))
            strcpy(buffer + SYSLOG_MESSAGE_BUFFER_SIZE - 5, "...\n");
        va_end(vl);

        syslog(1, "%s", buffer);
    }
    else if(m_location & FSLOG)  {
        //TODO
    }
}
