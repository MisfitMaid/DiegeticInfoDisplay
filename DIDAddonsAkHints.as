#if DEPENDENCY_AK_HINTS || DEPENDENCY_AK_HINTS_DEV

namespace DID {
    class AkHintsHandler : LaneProvider {
        LaneProviderSettings@ getProviderSetup() {
            LaneProviderSettings settings;
            settings.author = "XertroV";
            settings.internalName = "DID/AkHints";
            settings.friendlyName = "Current action key";
            return settings;
        }

        LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
            try {
                LaneConfig c = defaults;
                auto ak = AkHints::GetAKNumber();
                if (ak > 0 && ak <= 5)
                    c.content = ak == 5 ? "" : tostring(ak);
                return c;
            } catch {
                warn("Exception: " + getExceptionInfo());
            }
            return defaults;
        }
    }
}

#endif
