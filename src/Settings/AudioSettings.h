#pragma once

#include "SettingsGroup.h"

class AudioSettings : public SettingsGroup
{
    Q_OBJECT
public:
    AudioSettings(QObject* parent = nullptr);

    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(captureAudioInput)

};

