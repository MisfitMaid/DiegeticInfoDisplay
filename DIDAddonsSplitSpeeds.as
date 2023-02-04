#if DEPENDENCY_SPLITSPEEDS
namespace DID {
    vec4 DIDColor = vec4(1,0,0,1);
    string DIDTextTotal = "";
    string DIDTextDiff = "";

    class SplitSpeedsSpeedProvider : DID::LaneProvider {
        DID::LaneProviderSettings@ getProviderSetup() {
            DID::LaneProviderSettings settings;
            settings.author = "RuteNL";
            settings.internalName = "SplitSpeeds/TotalSpeed";
            settings.friendlyName = "Split Speeds (Current)";
            return settings;
        }

        DID::LaneConfig@ getLaneConfig(DID::LaneConfig@ &in defaults) {
            DID::LaneConfig c = defaults;
            c.content = SplitSpeeds::visible ? SplitSpeeds::speedText : "";
            return c;
        }
    }

    class SplitSpeedsDiffProvider : DID::LaneProvider {
        DID::LaneProviderSettings@ getProviderSetup() {
            DID::LaneProviderSettings settings;
            settings.author = "RuteNL";
            settings.internalName = "SplitSpeeds/SpeedDelta";
            settings.friendlyName = "Split Speeds (Difference)";
            return settings;
        }

        DID::LaneConfig@ getLaneConfig(DID::LaneConfig@ &in defaults) {
            DID::LaneConfig c = defaults;
            c.content = (SplitSpeeds::visible && SplitSpeeds::hasDifference) ? SplitSpeeds::differenceText : "";
            c.color = SplitSpeeds::currentColour;
            return c;
        }
    }
}
#endif