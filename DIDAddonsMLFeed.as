#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
namespace DID {
    const MLFeed::PlayerCpInfo_V3@ plf = null;
    const MLFeed::HookRaceStatsEventsBase_V3@ mlf = null;

    void CacheLocalPlayerCoro() {
        @mlf = MLFeed::GetRaceData_V3();
        while (true) {
            yield();
            if (GetApp().CurrentPlayground is null)
                @plf = null;
            else if (plf is null)
                @plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
                
        }
    }
    Meta::PluginCoroutine@ MLFeedCacheLocalPlayerCoro = startnew(CacheLocalPlayerCoro);

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
            if (plf is null) return c;
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
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;

            if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration)) {
                c.content = Time::Format(plf.lastCpTime);
            } else {
                c.content = (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
            }
            return c;
        }
    }

    void PrepareConfigCpSplitsTime(int cpMs, LaneConfig@ c) {
        if (cpMs < 0) {
            c.content = "+" + Time::Format(cpMs*-1, true, false);
        } else {
            c.content = "-" + Time::Format(cpMs, true, false);
        }

        if (deltaTimeColors) {
            if (cpMs < 0) {
                c.color = vec4(.869, 0.117, 0.117, .784);
            } else {
                c.color = vec4(0, .123, .822, .75);
            }
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
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;

            int cpMs;
            if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration) && plf.BestRaceTimes.Length > uint(plf.cpCount)) {
                cpMs = plf.BestRaceTimes[plf.cpCount-1] - plf.LastCpTime;
                PrepareConfigCpSplitsTime(cpMs, c);
            } else {
                c.content = "";
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
            if (plf is null) return c;
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
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;

            c.content = Text::Format("%d", (plf.CpCount / (mlf.CpCount+1))+1)+" / "+Text::Format("%d", mlf.LapCount);
            return c;
        }
    }

    class CurrentCheckpointHandler : LaneProvider {
        LaneProviderSettings@ getProviderSetup() {
            LaneProviderSettings settings;
            settings.author = "MisfitMaid";
            settings.internalName = "DID/CurrentCheckpoint";
            settings.friendlyName = "Checkpoint counter";
            return settings;
        }

        LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
            LaneConfig c = defaults;
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return defaults;
            c.content = Text::Format("%d", plf.CpCount % (mlf.CpCount+1))+" / "+Text::Format("%d", mlf.CpCount);
            return c;
        }
    }

    class NoRespawnTimeHandler : LaneProvider {
        LaneProviderSettings@ getProviderSetup() {
            LaneProviderSettings settings;
            settings.author = "XertroV";
            settings.internalName = "DID/NoRespawnTime";
            settings.friendlyName = "No-Respawn Time";
            return settings;
        }

        LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
            LaneConfig c = defaults;
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned || plf.TimeLostToRespawns == 0) return defaults;
            c.content = Time::Format(plf.TheoreticalRaceTime);
            return c;
        }
    }

    class NoRespawnSplitsHandler : LaneProvider {
        LaneProviderSettings@ getProviderSetup() {
            LaneProviderSettings settings;
            settings.author = "XertroV";
            settings.internalName = "DID/NoRespawnSplits";
            settings.friendlyName = "No-Respawn Splits vs Personal Best";
            return settings;
        }

        LaneConfig@ getLaneConfig(LaneConfig@ &in defaults) {
            LaneConfig c = defaults;
            if (plf is null) return c;
            if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned || plf.TimeLostToRespawns == 0) return c;
            if (plf.BestRaceTimes.Length < uint(plf.cpCount)) return c;
            auto cpMs = int(plf.BestRaceTimes[plf.cpCount-1]) - plf.LastTheoreticalCpTime;
            if ((plf.TheoreticalRaceTime - plf.LastTheoreticalCpTime) < int(deltaTimeDuration))
                PrepareConfigCpSplitsTime(cpMs, c);
            return c;
        }
    }
}
#endif
