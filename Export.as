namespace DID {
    import bool hasGottenAddonsFrom(const string &in plugin) from "DID";
    import void setGottenAddonsFrom(const string &in plugin) from "DID";

    import bool registerLaneProviderAddon(LaneProvider@ provider) from "DID";
    import bool overrideDiegeticDisplayStatus() from "DID";
    import void overrideDiegeticDisplay(bool disabled) from "DID";
}
