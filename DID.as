void Main() {
    DID::Main();
}

void Render() {
    DID::Render();
}

bool keyHeldDown = false;
void OnKeyPress(bool down, VirtualKey key)
{
    if (!keyHeldDown) {
        if(key == diegeticEnabledShortcut)
        {
            diegeticEnabled = !diegeticEnabled;
        }
    }
	keyHeldDown = down;
}

void RenderMenu() {
	if(UI::MenuItem("\\$8f0" + Icons::InfoCircle + "\\$z Diegetic Information Display", "", diegeticEnabled)) {
		diegeticEnabled = !diegeticEnabled;
	}
}

void OnSettingsChanged() {
    DID::OnSettingsChanged();
}

namespace DID {
    void Render() {
        if (!diegeticEnabled) return;
        if (VehicleState::GetViewingPlayer() is null) return;
        nvg::StrokeWidth(diegeticStrokeWidth);
        nvg::LineCap(nvg::LineCapType::Butt);
        nvg::LineJoin(nvg::LineCapType::Butt);
        nvg::MiterLimit(0);

        // get max length of left items to add padding
        int maxLen = 0;
        string[] leftPadded;
        leftPadded.Resize(4);
        for (uint i = 0; i < 4; i++) {
            maxLen = Math::Max(lanes[i].content.Length, maxLen);
        }
        for (uint i = 0; i < 4; i++) {
            leftPadded[i] = lanes[i].content;
            while (leftPadded[i].Length < maxLen) {
                leftPadded[i] = " "+leftPadded[i]; // str_pad when 🥺
            }
        }

        int leftOffset = (diegeticHorizontalDistance + maxLen*100) * -1;
        int rightOffset = diegeticHorizontalDistance;
        for (uint i = 0; i < 4; i++) {
            AddonHandler::LaneConfig left = lanes[i];
            AddonHandler::LaneConfig right = lanes[i+4];

            if (diegeticOutline.w > 0.0) {    
                nvg::StrokeColor(diegeticOutline);
                nvg::LineCap(nvg::LineCapType::Round);
                nvg::LineJoin(nvg::LineCapType::Round);
                nvg::StrokeWidth(diegeticStrokeWidth*3.0);
                DID::drawString(leftPadded[i], vec2(leftOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
                DID::drawString(lanes[i+4].content, vec2(rightOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
                nvg::StrokeWidth(diegeticStrokeWidth);
                nvg::LineCap(nvg::LineCapType::Butt);
                nvg::LineJoin(nvg::LineCapType::Butt);
            }

            nvg::StrokeColor(lanes[i].color);
            DID::drawString(leftPadded[i], vec2(leftOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
            nvg::StrokeColor(lanes[i+4].color);
            DID::drawString(lanes[i+4].content, vec2(rightOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
        }    
    }

    AddonHandler::LaneConfig@[] lanes;
    dictionary font;

    void Main() {
        init();
        while (true) {
            auto app = cast<CTrackMania>(GetApp());
            auto map = app.RootMap;

            if(map is null || map.MapInfo.MapUid == "" || app.Editor !is null || VehicleState::GetViewingPlayer() is null) {
                yield();
            } else {
                step();
            }
            yield();
        }
    }

    void OnSettingsChanged() {
        init();
    }

    void init() {
        lanes.Resize(8);
        font = dictionary();
        loadFont();

        AddonHandler::registerLaneProviderAddon(AddonHandler::NullProvider());
        AddonHandler::registerLaneProviderAddon(AddonHandler::FrontSpeedProvider());
        
    }

    void step() {
        if (!diegeticEnabled) return;
        // this is kinda dumb but whatever

        @lanes[0] = getInfoText(LineL1, 0);
        @lanes[1] = getInfoText(LineL2, 1);
        @lanes[2] = getInfoText(LineL3, 2);
        @lanes[3] = getInfoText(LineL4, 3);

        @lanes[4] = getInfoText(LineR1, 4);
        @lanes[5] = getInfoText(LineR2, 5);
        @lanes[6] = getInfoText(LineR3, 6);
        @lanes[7] = getInfoText(LineR4, 7);

        return;
    }

    AddonHandler::LaneConfig@ getInfoText(const string &in type, uint slot) {
        AddonHandler::LaneConfig defaults();
        defaults.color = diegeticColor;
        defaults.content = "";
        try {
            if (AddonHandler::hasProvider(type)) {
                AddonHandler::LaneProvider@ lp = AddonHandler::getProvider(type);
                return lp.getLaneConfig(defaults);
            }
        } catch {
            warn("error requesting string for slot " + Text::Format("%d", slot));
        }
        AddonHandler::NullProvider np;
        return np.getLaneConfig(defaults);
    }


    string _getInfoText(InformationTypes type, uint slot) {
        if (renderDemo) {
            return "0123456789+-/:.";
        }
        const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
        const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);

        if (plf.spawnStatus == MLFeed::SpawnStatus::NotSpawned) return "";

        if (VehicleState::GetViewingPlayer() is null) return "";
        CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
        string cpTime, curDeltaTime;
        int cpMs;
        if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration) && plf.BestRaceTimes.Length > uint(plf.cpCount)) {
            cpMs = plf.BestRaceTimes[plf.cpCount-1] - plf.LastCpTime;
            if (cpMs < 0) {
                cpTime = "+" + Time::Format(cpMs*-1, true, false);
            } else {
                cpTime = "-" + Time::Format(cpMs, true, false);
            }
            curDeltaTime = Time::Format(plf.lastCpTime);
        } else {
            cpTime = "";
            curDeltaTime = (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
        }

        

        uint curCP, curLap;
        if (mlf.LapCount > 1) {
            curCP = plf.CpCount % (mlf.CpCount+1);
            curLap = (plf.CpCount / (mlf.CpCount+1))+1;
        } else {
            curCP = plf.CpCount;
            curLap = plf.CpCount;
        }

        switch(type) {
            case InformationTypes::Empty:
                return "";
            case InformationTypes::CurrentRaceTime:
                return (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
            case InformationTypes::CurrentRaceTimeWithSplits:
                return curDeltaTime;
            case InformationTypes::LapCounter:
                return getTotLaps() == 1 ? "" : Text::Format("%d", curLap)+" / "+Text::Format("%d", mlf.LapCount);
            case InformationTypes::LapCounterAlways:
                return Text::Format("%d", curLap)+" / "+Text::Format("%d", mlf.LapCount);
            case InformationTypes::CheckpointCounter:
                return Text::Format("%d", curCP)+" / "+Text::Format("%d", mlf.CpCount);
            case InformationTypes::LastCheckpointTime:
                if (deltaTimeColors) {
                    if (cpMs < 0) {
                        // laneColors[slot] = vec4(.869, 0.117, 0.117, .784);
                    } else {
                        // laneColors[slot] = vec4(0, .123, .822, .75);
                    }
                }
                return cpTime;
            case InformationTypes::VehicleWetness:
                if (vis.WetnessValue01 < 0.01) return "";
                return Text::Format("%.0f", vis.WetnessValue01 * 100);
            case InformationTypes::VehicleIcynessFL:
            case InformationTypes::VehicleIcynessFR:
            case InformationTypes::VehicleIcynessRL:
            case InformationTypes::VehicleIcynessRR:
            case InformationTypes::VehicleIcynessOverall:
                return getIcynessPct(type, vis);
            case InformationTypes::VehicleGear:
                return Text::Format("%d", vis.CurGear);
            case InformationTypes::VehicleRPM:
                return Text::Format("%.01f", VehicleState::GetRPM(vis) / 1000.0f);
            default:
                return "";
        }
    }

    // from checkpoint counter
    uint getTotLaps() {
        CSmArenaClient@ playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        return playground.Map.TMObjective_IsLapRace ? playground.Map.TMObjective_NbLaps : 1;
    }

    // from checkpoint counter
    uint getTotCPs() {
        CSmArenaClient@ playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        MwFastBuffer<CGameScriptMapLandmark@> landmarks = playground.Arena.MapLandmarks;

        uint _maxCP = 0;
        array<int> links = {};
        for(uint i = 0; i < landmarks.Length; i++) {
            if(landmarks[i].Waypoint !is null && !landmarks[i].Waypoint.IsFinish && !landmarks[i].Waypoint.IsMultiLap) {
                // we have a CP, but we don't know if it is Linked or not
                if(landmarks[i].Tag == "Checkpoint") {
                    _maxCP += 1;
                } else if(landmarks[i].Tag == "LinkedCheckpoint") {
                    if(links.Find(landmarks[i].Order) < 0) {
                        _maxCP += 1;
                        links.InsertLast(landmarks[i].Order);
                    }
                } else {
                    warn("The current map, " + string(playground.Map.MapName) + " (" + playground.Map.IdName + "), is not compliant with checkpoint naming rules."
                            + " If the CP count for this map is inaccurate, please report this map on the GitHub issues page:"
                            + " https://github.com/Phlarx/tm-checkpoint-counter/issues");
                    _maxCP += 1;
                }
            }
        }
        return _maxCP;
    }

    string getIcynessPct(InformationTypes tire, CSceneVehicleVisState@ vis) {
        float ice;
        switch (tire) {
            case InformationTypes::VehicleIcynessFL: ice = vis.FLIcing01; break;
            case InformationTypes::VehicleIcynessFR: ice = vis.FRIcing01; break;
            case InformationTypes::VehicleIcynessRL: ice = vis.RLIcing01; break;
            case InformationTypes::VehicleIcynessRR: ice = vis.RRIcing01; break;
            case InformationTypes::VehicleIcynessOverall:
                ice = (vis.FLIcing01 + vis.FRIcing01 + vis.RLIcing01 + vis.RRIcing01) / 4.0;
                break;
            default: // how
                ice = 0;
                break;
        }
        if (ice < 0.01) return "";
        return Text::Format("%.0f", ice * 100);
    }

    void loadFont() {
        Json::Value json;
        switch (diegeticFont) {
            case Fonts::Custom:
                json = Json::FromFile(IO::FromStorageFolder("font.custom.json"));
                break;
            case Fonts::NixieReduced:
                json = Json::FromFile("font.shittyNixie.json");
                break;
            case Fonts::Nixie:
            default:
                json = Json::FromFile("font.nixie.json");
                break;
        }
        for (uint i = 0; i < json.GetKeys().Length; i++) {
            string glyph = json.GetKeys()[i];
            vec3[] pts;
            for (uint v = 0; v < json[glyph].Length; v++) {
                pts.InsertLast(vec3(json[glyph][v][0],json[glyph][v][1],json[glyph][v][2]));
            }
            font.Set(glyph, pts);
        }
    }

    enum InformationTypes {
        Empty,
        CurrentRaceTime,
        CurrentRaceTimeWithSplits,
        LapCounter,
        LapCounterAlways,
        CheckpointCounter,
        LastCheckpointTime,
        VehicleSpeed,
        VehicleSideSpeed,
        VehicleWetness,
        VehicleIcynessOverall,
        VehicleIcynessFL,
        VehicleIcynessFR,
        VehicleIcynessRL,
        VehicleIcynessRR,
        VehicleGear,
        VehicleRPM,
        ReserveForOtherPlugin
    }

    enum Fonts {
        Nixie,
        NixieReduced,
        Custom
    }
}
