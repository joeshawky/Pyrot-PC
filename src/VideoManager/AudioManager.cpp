#include "AudioManager.h"

AudioManager::AudioManager(QObject *parent)
    : QObject{parent}
{
    m_audioRecorder = new QAudioRecorder();
    QAudioEncoderSettings settings;
    settings.setCodec("Default");
    settings.setSampleRate(0);
    settings.setBitRate(0);
    settings.setChannelCount(-1);
    settings.setQuality(QMultimedia::VeryHighQuality);
    settings.setEncodingMode(QMultimedia::ConstantQualityEncoding);
    QString container = "";

    m_audioRecorder->setEncodingSettings(settings, QVideoEncoderSettings(), container);

}

void AudioManager::StartRecording(QString videoFile)
{
    QFileInfo videoFileInfo(videoFile);
    QString audioFilePath = QStringLiteral("%1/%2.wav").arg(videoFileInfo.path(), videoFileInfo.completeBaseName());

    m_audioRecorder->setOutputLocation(QUrl::fromLocalFile(audioFilePath));

    if (m_audioRecorder->state() != QMediaRecorder::StoppedState)
        m_audioRecorder->stop();


    m_audioRecorder->record();
}

void AudioManager::StopRecording()
{
    if (m_audioRecorder->state() != QMediaRecorder::StoppedState)
        m_audioRecorder->stop();
}

QString AudioManager::Status()
{
    return m_audioRecorder->state();
}


