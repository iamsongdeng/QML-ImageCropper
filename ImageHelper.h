#ifndef IMAGEHELPER_H
#define IMAGEHELPER_H

#include <QObject>
#include <QCryptographicHash>
#include <QImage>
#include <QDateTime>
#include <QDir>
#include <QUrl>

class ImageHelper : public QObject
{
    Q_OBJECT
public:
    explicit ImageHelper(QObject *parent = nullptr);

    Q_INVOKABLE QUrl crop(const QUrl &url, const QRect &rect);
    Q_INVOKABLE QString crop2Base64data(const QUrl &url, const QSize &sourceSize, const QRect &corpRect);

signals:
};

#endif // IMAGEHELPER_H
