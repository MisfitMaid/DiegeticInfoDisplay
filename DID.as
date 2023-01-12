void Render() {
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
        maxLen = Math::Max(lanes[i].Length, maxLen);
    }
    for (uint i = 0; i < 4; i++) {
        leftPadded[i] = lanes[i];
        while (leftPadded[i].Length < maxLen) {
            leftPadded[i] = " "+leftPadded[i]; // str_pad when 🥺
        }
    }

    int leftOffset = (diegeticHorizontalDistance + maxLen*100) * -1;
    int rightOffset = diegeticHorizontalDistance;
    for (uint i = 0; i < 4; i++) {
        nvg::StrokeColor(laneColors[i]);
        DID::drawString(leftPadded[i], vec2(leftOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
        nvg::StrokeColor(laneColors[i+4]);
        DID::drawString(lanes[i+4], vec2(rightOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
    }
    
    
}

string[] lanes;
vec4[] laneColors;
dictionary font;

void Main() {
    lanes.Resize(8);
    laneColors.Resize(8);
    font = dictionary();
    loadFont();

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

void step() {
    // this is kinda dumb but whatever

    lanes[0] = getInfoText(LineL1, 0);
    lanes[1] = getInfoText(LineL2, 1);
    lanes[2] = getInfoText(LineL3, 2);
    lanes[3] = getInfoText(LineL4, 3);

    lanes[4] = getInfoText(LineR1, 4);
    lanes[5] = getInfoText(LineR2, 5);
    lanes[6] = getInfoText(LineR3, 6);
    lanes[7] = getInfoText(LineR4, 7);

    return;
}


string getInfoText(DIDInformationTypes type, uint slot) {
    laneColors[slot] = diegeticColor;
    if (renderDemo) {
        return "0123456789+-/:.";
    }
    CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
    CSmScriptPlayer@ sapi = cast<CSmScriptPlayer>(VehicleState::GetViewingPlayer().ScriptAPI);
    const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
    const MLFeed::PlayerCpInfo_V3@ plf = mlf.GetPlayer_V3(MLFeed::LocalPlayersName);
    string cpTime;
    int cpMs;
    if (plf.cpCount > 0 && (plf.CurrentRaceTime - plf.LastCpTime) < int(deltaTimeDuration)) {
        
        cpMs = plf.BestRaceTimes[plf.cpCount-1] - plf.LastCpTime;
        if (cpMs < 0) {
            cpTime = "+" + Time::Format(cpMs*-1, true, false);
        } else {
            cpTime = "-" + Time::Format(cpMs, true, false);
        }
    } else {
        cpTime = "";
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
        case DIDInformationTypes::Empty:
            return "";
        case DIDInformationTypes::CurrentRaceTime:
            return (plf.CurrentRaceTime < 0) ? Time::Format(0) : Time::Format(plf.CurrentRaceTime);
        case DIDInformationTypes::LapCounter:
            return getTotLaps() == 1 ? "" : Text::Format("%d", curLap)+" / "+Text::Format("%d", mlf.LapCount);
        case DIDInformationTypes::LapCounterAlways:
            return Text::Format("%d", curLap)+" / "+Text::Format("%d", mlf.LapCount);
        case DIDInformationTypes::CheckpointCounter:
            return Text::Format("%d", curCP)+" / "+Text::Format("%d", mlf.CpCount);
        case DIDInformationTypes::LastCheckpointTime:
            if (deltaTimeColors) {
                if (cpMs < 0) {
                    laneColors[slot] = vec4(.869, 0.117, 0.117, .784);
                } else {
                    laneColors[slot] = vec4(0, .123, .822, .75);
                }
            }
            return cpTime;
        case DIDInformationTypes::LastLapTime:
            return "---"; // todo
        case DIDInformationTypes::VehicleSpeed:
            return Text::Format("%.0f", vis.FrontSpeed * 3.6f);
        case DIDInformationTypes::VehicleSideSpeed:
            return Text::Format("%.0f", VehicleState::GetSideSpeed(vis) * 3.6f);
        case DIDInformationTypes::VehicleWetness:
            return Text::Format("%.01f", vis.WetnessValue01 * 100);
        case DIDInformationTypes::VehicleIcynessFL:
        case DIDInformationTypes::VehicleIcynessFR:
        case DIDInformationTypes::VehicleIcynessRL:
        case DIDInformationTypes::VehicleIcynessRR:
        case DIDInformationTypes::VehicleIcynessOverall:
            return getIcynessPct(type, vis);
        case DIDInformationTypes::VehicleGear:
            return Text::Format("%d", vis.CurGear);
        case DIDInformationTypes::VehicleRPM:
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

string getIcynessPct(DIDInformationTypes tire, CSceneVehicleVisState@ vis) {
    float ice;
    switch (tire) {
        case DIDInformationTypes::VehicleIcynessFL: ice = vis.FLIcing01; break;
        case DIDInformationTypes::VehicleIcynessFR: ice = vis.FRIcing01; break;
        case DIDInformationTypes::VehicleIcynessRL: ice = vis.RLIcing01; break;
        case DIDInformationTypes::VehicleIcynessRR: ice = vis.RRIcing01; break;
        case DIDInformationTypes::VehicleIcynessOverall:
            ice = (vis.FLIcing01 + vis.FRIcing01 + vis.RLIcing01 + vis.RRIcing01) / 4.0;
            break;
        default: // how
            ice = 0;
            break;
    }
    if (ice < 0.01) return "";
    return Text::Format("%.01f", ice * 100);
}

enum DIDInformationTypes {
    Empty,
    CurrentRaceTime,
    LapCounter,
    LapCounterAlways,
    CheckpointCounter,
    LastCheckpointTime,
    LastLapTime,
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

void loadFont() {
    Json::Value json = Json::FromFile("font.nixie.json");
    for (uint i = 0; i < json.GetKeys().Length; i++) {
        string glyph = json.GetKeys()[i];
        vec3[] pts;
        for (uint v = 0; v < json[glyph].Length; v++) {
            pts.InsertLast(vec3(json[glyph][v][0],json[glyph][v][1],json[glyph][v][2]));
        }
        font.Set(glyph, pts);
    }
}
