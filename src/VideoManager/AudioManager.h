#ifndef AUDIOMANAGER_H
#define AUDIOMANAGER_H

#include <QObject>
#include <QAudioRecorder>
#include <QAudioEncoderSettings>
#include <QMultimedia>
#include <QUrl>
class AudioManager : public QObject
{
    Q_OBJECT
public:
    explicit AudioManager(QObject *parent = nullptr);

public slots:
    void StartRecording(QString videoFile);
    void StopRecording();
    QString Status();

signals:

private:
    QAudioRecorder *m_audioRecorder = nullptr;
};

#endif // AUDIOMANAGER_H
