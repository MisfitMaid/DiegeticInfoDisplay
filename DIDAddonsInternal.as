namespace DID {
    namespace AddonHandler {

        class DemoProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/Demo";
                settings.friendlyName = "Font demo";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                
                c.content = "0123456789+-/:.";
                return c;
            }

        }

        class FrontSpeedProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/FrontSpeed";
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
                settings.internalName = "DID/SideSpeed";
                settings.friendlyName = "Speed (side)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                c.content = Text::Format("%.0f", Math::Abs(VehicleState::GetSideSpeed(vis)) * 3.6f);
                return c;
            }

        }

        class SteeringProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/Steering";
                settings.friendlyName = "Steering Angle";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                if (vis.InputSteer < 0.01 && vis.InputSteer > -0.01) {
                    c.content = "";
                } else {
                    c.content = Text::Format("%.0f", vis.InputSteer * 100);
                }
                return c;
                return c;
            }

        }

        class WetTiresProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/WetTires";
                settings.friendlyName = "Tire wetness (all tires)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                if (vis.WetnessValue01 < 0.01) {
                    c.content = "";
                } else {
                    c.content = Text::Format("%.0f", vis.WetnessValue01 * 100);
                }
                return c;
            }

        }

        class GearProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/Gear";
                settings.friendlyName = "Current gear";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                c.content = Text::Format("%d", vis.CurGear);
                return c;
            }

        }

        class RPMProvider : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/RPM";
                settings.friendlyName = "Current engine RPM";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
                c.content = Text::Format("%.01f", VehicleState::GetRPM(vis) / 1000.0f);
                return c;
            }

        }

        class IceTireProviderAvg : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/IceTiresAvg";
                settings.friendlyName = "Tire icing (all tires average)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = getIcynessPct("Avg", VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState);
                return c;
            }
        }

        class IceTireProviderFL : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/IceTiresFL";
                settings.friendlyName = "Tire icing (Front Left)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = getIcynessPct("FL", VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState);
                return c;
            }
        }

        class IceTireProviderFR : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/IceTiresFR";
                settings.friendlyName = "Tire icing (Front Right)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = getIcynessPct("FR", VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState);
                return c;
            }
        }

        class IceTireProviderRL : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/IceTiresRL";
                settings.friendlyName = "Tire icing (Rear Left)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = getIcynessPct("RL", VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState);
                return c;
            }
        }

        class IceTireProviderRR : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/IceTiresRR";
                settings.friendlyName = "Tire icing (Rear Right)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                c.content = getIcynessPct("RR", VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState);
                return c;
            }
        }

        string getIcynessPct(const string &in tire, CSceneVehicleVisState@ vis) {
            float ice;

            if (tire == "FL") ice = vis.FLIcing01;
            if (tire == "FR") ice = vis.FRIcing01;
            if (tire == "RL") ice = vis.RLIcing01;
            if (tire == "RR") ice = vis.RRIcing01;
            if (tire == "Avg") ice = (vis.FLIcing01 + vis.FRIcing01 + vis.RLIcing01 + vis.RRIcing01) / 4.0;

            if (ice < 0.01) return "";
            return Text::Format("%.0f", ice * 100);
        }
    }
}
