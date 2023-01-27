namespace DID {
    namespace AddonHandler {

        LaneProvider@[] laneProviders;
        bool registerLaneProviderAddon(LaneProvider@ provider) {
            if (hasProvider(provider.getProviderSetup().internalName)) return false;

            laneProviders.InsertLast(provider);
            return true;
        }

        bool hasProvider(const string &in identifier) {
            for (uint i = 0; i < laneProviders.Length; i++) {
                LaneProviderSettings@ setup = laneProviders[i].getProviderSetup();
                if (setup.internalName == identifier) {
                    return true;
                }
            }
            return false;
        }

        LaneProvider@ getProvider(const string &in identifier) {
            for (uint i = 0; i < laneProviders.Length; i++) {
                LaneProviderSettings@ setup = laneProviders[i].getProviderSetup();
                if (setup.internalName == identifier) {
                    return laneProviders[i];
                }
            }
            throw("Could not find provider, please check with hasProvider() first!");
            NullProvider thisShouldntEverHappenButItWontCompile;
            return thisShouldntEverHappenButItWontCompile;
        }
    }
}
