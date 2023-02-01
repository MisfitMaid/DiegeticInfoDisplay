#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
namespace DID {
        
        class RaceTimeHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/RaceTime";
                settings.friendlyName = "Current race time";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;
                
                c.content = (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
                return c;
            }
        }

        class RaceTimeSplitHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/RaceTimeSplit";
                settings.friendlyName = "Current race time (with freezes on checkpoint splits)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;

                if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration)) {
                    c.content = Time::Format(plf.lastCpTime);
                } else {
                    c.content = (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
                }
                return c;
            }
        }

        class SplitDeltaHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/SplitDelta";
                settings.friendlyName = "Checkpoint delta splits verus personal best";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;

                int cpMs;
                if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration) && plf.BestRaceTimes.Length > uint(plf.cpCount)) {
                    cpMs = plf.BestRaceTimes[plf.cpCount-1] - plf.LastCpTime;
                    if (cpMs < 0) {
                        c.content = "+" + Time::Format(cpMs*-1, true, false);
                    } else {
                        c.content = "-" + Time::Format(cpMs, true, false);
                    }
                } else {
                    c.content = "";
                }

                if (deltaTimeColors) {
                    if (cpMs < 0) {
                        c.color = vec4(.869, 0.117, 0.117, .784);
                    } else {
                        c.color = vec4(0, .123, .822, .75);
                    }
                }
                return c;
            }
        }

        class CurrentLapHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/CurrentLap";
                settings.friendlyName = "Lap counter (if multilap)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;
                
                c.content = getTotLaps() == 1 ? "" : Text::Format("%d", (plf.CpCount / (mlf.CpCount+1))+1)+" / "+Text::Format("%d", mlf.LapCount);
                return c;
            }
        }

        class CurrentLapAlwaysHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/CurrentLapAlways";
                settings.friendlyName = "Lap counter (always)";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;
                
                c.content = Text::Format("%d", (plf.CpCount / (mlf.CpCount+1))+1)+" / "+Text::Format("%d", mlf.LapCount);
                return c;
            }
        }

        class CurrenCheckpointHandler : LaneProvider {
            LaneProviderSettings@ getProviderSetup() {
                LaneProviderSettings settings;
                settings.author = "MisfitMaid";
                settings.internalName = "DID/CurrentCheckpoint";
                settings.friendlyName = "Checkpoint counter";
                return settings;
            }

            LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
                LaneConfig c = defaults;
                const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
                const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;
                
                c.content = Text::Format("%d", plf.CpCount % (mlf.CpCount+1))+" / "+Text::Format("%d", mlf.CpCount);
                return c;
            }
        }

}
#endif
