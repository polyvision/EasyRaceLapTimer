#ifndef LOGGER_H
#define LOGGER_H

#include <singleton.h>
#include <QObject>
#include <string.h>

enum Severity {
    ERROR,
    WARNING,
    INFO,
    DEBUG,
    TRACE
};

enum Location {
    NONE = 0x00,
    CONSOLE = 0x01,
    SYSLOG = 0x02,
    FSLOG = 0x04
};

#define FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#define LOG_DBG(fac, fmt, ...) do { if(Logger::instance()->enabled(DEBUG)) Logger::instance()->log(fac, DEBUG, "%s, %d: " fmt "\n", FILENAME, __LINE__, __VA_ARGS__); } while(0)
#define LOG_WARN(fac, fmt, ...) do { if(Logger::instance()->enabled(WARNING)) Logger::instance()->log(fac, WARNING, "%s, %d: " fmt "\n", FILENAME, __LINE__, __VA_ARGS__); } while(0)
#define LOG_ERROR(fac, fmt, ...) do { if(Logger::instance()->enabled(ERROR)) Logger::instance()->log(fac, ERROR, "%s, %d: " fmt "\n", FILENAME, __LINE__, __VA_ARGS__); } while(0)
#define LOG_INFO(fac, fmt, ...) do { if(Logger::instance()->enabled(INFO)) Logger::instance()->log(fac, INFO, "%s, %d: " fmt "\n", FILENAME, __LINE__, __VA_ARGS__); } while(0)
#define LOG_TRACE(fac, fmt, ...) do { if(Logger::instance()->enabled(TRACE)) Logger::instance()->log(fac, TRACE, "%s, %d: " fmt "\n", FILENAME, __LINE__, __VA_ARGS__); } while(0)

#define LOG_ERRORS(fac, str) LOG_ERROR(fac, "%s", str)
#define LOG_INFOS(fac, str)   LOG_INFO(fac, "%s", str)
#define LOG_WARNS(fac, str)  LOG_WARN(fac, "%s", str)
#define LOG_DBGS(fac, str)   LOG_DBG(fac, "%s", str)

#define SEVERITY_COUNT 5

#define LOG_CONFIG_FACILITY 1
#define LOG_FACILTIY_COMMON 2

class Logger : public Singleton<Logger>
{
public:
    Logger();

    static char const *SeveritiesShort[SEVERITY_COUNT];

    bool init();
    void log(int facility, Severity severity, const char *format, ...);

    void setLocation(quint8 location) { m_location = location; }
    quint8 location() { return m_location; }

    bool enabled(Severity sev) { return sev >= m_severity; }

private:
    quint8 m_location;
    Severity m_severity;

    friend class Singleton<Logger>;
};

#endif // LOGGER_H
