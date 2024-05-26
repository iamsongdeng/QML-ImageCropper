#include "ImageHelper.h"

#include <QDebug>
#include <QBuffer>
#include <QImageReader>

ImageHelper::ImageHelper(QObject *parent)
    : QObject{parent}
{}

QUrl ImageHelper::crop(const QUrl &url, const QRect &rect)
{
    QUrl resultUrl;
    if(url.isEmpty())
        return resultUrl;
    QString fileName = url.isLocalFile() ? url.toLocalFile() : url.toString();

    QImage original(fileName);
    if(original.isNull())
        return resultUrl;

    // do crop image
    QImage cropped = original.copy(rect);

    // using the current timestamps as the filename
    qint64 ms = QDateTime::currentMSecsSinceEpoch();
    QByteArray md5 = QCryptographicHash::hash(QByteArray().setNum(ms), QCryptographicHash::Md5);

    // save to temp directory
    QDir tempDir = QDir::current();
    if(!tempDir.cd(QStringLiteral("temp")))
    {
        tempDir.mkdir(QStringLiteral("temp"));
        tempDir.cd(QStringLiteral("temp"));
    }
    // no suffix
    QString name = tempDir.path() + "/" + QString(md5.toHex()) +".png" ;
    cropped.save(name, "PNG");
    resultUrl = QUrl::fromLocalFile(name);

    return resultUrl;
}

QString ImageHelper::crop2Base64data(const QUrl &url, const QSize &sourceSize, const QRect &corpRect)
{
    QString strRet;
    if(url.isEmpty())
        return strRet;
    QString fileName = url.isLocalFile() ? url.toLocalFile() : url.toString();

    QImageReader imgReader(fileName);
    imgReader.setScaledSize(sourceSize);
    QImage original= imgReader.read();
    if(original.isNull())
        return strRet;

    // do crop image
    QImage cropped = original.copy(corpRect);

    QBuffer buf;
    buf.open(QIODevice::WriteOnly);

    cropped.save(&buf, "PNG");
    strRet = buf.data().toBase64();
    //qDebug() << strRet;

    buf.close();
    return strRet;
}
