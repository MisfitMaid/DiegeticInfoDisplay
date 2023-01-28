namespace DID {
        shared interface LaneProvider {
            LaneProviderSettings@ getProviderSetup();
            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults);
        }

        shared class LaneConfig {
            string content;
            vec4 color;
        }

        shared class LaneProviderSettings {
            string internalName;
            string friendlyName;
            string author;
        }

        class NullProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/NullProvider";
                settings.friendlyName = "Empty";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                return defaults;
            }

        }

}
