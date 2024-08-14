#pragma once


#include "SettingsGroup.h"

class SubtitleSettings : public SettingsGroup
{
    Q_OBJECT
public:
    SubtitleSettings(QObject* parent = nullptr);

    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(companyName)
    DEFINE_SETTINGFACT(shipName)
};

