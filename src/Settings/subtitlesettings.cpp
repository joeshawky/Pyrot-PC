#include "SubtitleSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(Subtitle, "Subtitle")
{
    qmlRegisterUncreatableType<SubtitleSettings>("QGroundControl.SettingsManager", 1, 0, "SubtitleSettings", "Reference only");
}

DECLARE_SETTINGSFACT_NO_FUNC(SubtitleSettings, companyName)
{
    if (!_companyNameFact) {
        // Distance/Area/Speed units settings can't be loaded from json since it creates an infinite loop of meta data loading.

        FactMetaData* metaData = new FactMetaData(FactMetaData::valueTypeString, this);
        metaData->setName("companyName");
        metaData->setShortDescription("Company name that will be displayed in subtitles");


        metaData->setRawDefaultValue("");
        metaData->setQGCRebootRequired(false);
        _companyNameFact = new SettingsFact(_settingsGroup, metaData, this);
    }
    return _companyNameFact;

}

DECLARE_SETTINGSFACT_NO_FUNC(SubtitleSettings, shipName)
{
    if (!_shipNameFact) {
        // Distance/Area/Speed units settings can't be loaded from json since it creates an infinite loop of meta data loading.

        FactMetaData* metaData = new FactMetaData(FactMetaData::valueTypeString, this);
        metaData->setName("shipName");
        metaData->setShortDescription("Company name that will be displayed in subtitles");


        metaData->setRawDefaultValue("");
        metaData->setQGCRebootRequired(false);
        _shipNameFact = new SettingsFact(_settingsGroup, metaData, this);
    }
    return _shipNameFact;

}
