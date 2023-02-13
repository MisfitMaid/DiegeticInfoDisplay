// Check https://github.com/sylae/DiegeticInfoDisplay/wiki/Addons to see how to use these
namespace DID {
    import bool registerLaneProviderAddon(LaneProvider@ provider) from "DID";
    import LaneProvider@[]@ getAllProviders() from "DID";
    import bool overrideDiegeticDisplayStatus() from "DID";
    import void overrideDiegeticDisplay(bool disabled) from "DID";
}
