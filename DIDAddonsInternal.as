namespace DID {
    namespace AddonHandler {
        class FrontSpeedProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/FrontSpeedProvider";
                settings.friendlyName = "Speed (front)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                c.content = Text::Format("%.0f", vis.FrontSpeed * 3.6f);
                return c;
            }

        }
        class SideSpeedProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/SideSpeedProvider";
                settings.friendlyName = "Speed (side)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = Text::Format("%.0f", Math::Abs(VehicleState::GetSideSpeed(vis)) * 3.6f);
                return c;
            }

        }
    }
}
