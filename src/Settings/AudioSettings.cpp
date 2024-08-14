#include "AudioSettings.h"
#include <QQmlEngine>
#include <QtQml>


DECLARE_SETTINGGROUP(Audio, "Audio")
{
    qmlRegisterUncreatableType<AudioSettings>("QGroundControl.SettingsManager", 1, 0, "AudioSettings", "Reference only");
}


DECLARE_SETTINGSFACT_NO_FUNC(AudioSettings, captureAudioInput)
{
    if (!_captureAudioInputFact) {
        // Distance/Area/Speed units settings can't be loaded from json since it creates an infinite loop of meta data loading.

        FactMetaData* metaData = new FactMetaData(FactMetaData::valueTypeBool, this);
        metaData->setName("captureAudioInput");
        metaData->setShortDescription("Determins whether the user's microphone is captured or not");


        metaData->setRawDefaultValue(true);
        metaData->setQGCRebootRequired(false);
        _captureAudioInputFact = new SettingsFact(_settingsGroup, metaData, this);
    }
    return _captureAudioInputFact;

}
