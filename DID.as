void Render() {
    if (VehicleState::GetViewingPlayer() is null) return;
    nvg::StrokeWidth(diegeticStrokeWidth);
    nvg::StrokeColor(vec4(1,1,1,1));
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
        DID::drawString(leftPadded[i], vec2(leftOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
        DID::drawString(lanes[i+4], vec2(rightOffset, 0)+diegeticCustomOffset.xy, diegeticCustomOffset.z + i*diegeticLineSpacing*-1);
    }
    
    
}

string[] lanes;

void Main() {
    lanes.Resize(8);

	while (true) {
		auto app = cast<CTrackMania>(GetApp());
		auto map = app.RootMap;

		if(map is null || map.MapInfo.MapUid == "" || app.Editor !is null) {
			yield();
		} else {
			step();
		}
		yield();
	}
}

void step() {
    // this is kinda dumb but whatever

    lanes[0] = getInfoText(LineL1);
    lanes[1] = getInfoText(LineL2);
    lanes[2] = getInfoText(LineL3);
    lanes[3] = getInfoText(LineL4);

    lanes[4] = getInfoText(LineR1);
    lanes[5] = getInfoText(LineR2);
    lanes[6] = getInfoText(LineR3);
    lanes[7] = getInfoText(LineR4);

    return;
}


string getInfoText(DIDInformationTypes type) {
    if (VehicleState::GetViewingPlayer() is null) return "";
    CSceneVehicleVisState@ vis = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
    CSmScriptPlayer@ sapi = cast<CSmScriptPlayer>(VehicleState::GetViewingPlayer().ScriptAPI);
    PlayerState::sTMData@ TMData = PlayerState::GetRaceData(); // todo: replace
    const MLFeed::HookRaceStatsEventsBase_V3@ mlf = MLFeed::GetRaceData_V3();
    trace(mlf.GetPlayer_V3(MLFeed::LocalPlayersName).ToString());


    switch(type) {
        case DIDInformationTypes::Empty:
            return "";
        case DIDInformationTypes::CurrentRaceTime:
            return Time::Format(TMData.dPlayerInfo.CurrentRaceTime);
        case DIDInformationTypes::LapCounter:
            return getTotLaps() == 1 ? "" : Text::Format("%d", TMData.dPlayerInfo.CurrentLapNumber)+" / "+Text::Format("%d", getTotLaps());
        case DIDInformationTypes::LapCounterAlways:
            return Text::Format("%d", TMData.dPlayerInfo.CurrentLapNumber)+" / "+Text::Format("%d", getTotLaps());
        case DIDInformationTypes::CheckpointCounter:
            return Text::Format("%d", TMData.dPlayerInfo.NumberOfCheckpointsPassed)+" / "+Text::Format("%d", getTotCPs());
        case DIDInformationTypes::LastCheckpointTime:
        case DIDInformationTypes::LastLapTime:
            return "---"; // todo
        case DIDInformationTypes::VehicleSpeed:
            return Text::Format("%.0f", vis.FrontSpeed * 3.6f);
        case DIDInformationTypes::VehicleSideSpeed:
            return Text::Format("%.0f", VehicleState::GetSideSpeed(vis) * 3.6f);
        case DIDInformationTypes::VehicleWetness:
            return Text::Format("%.01f", vis.WetnessValue01 * 100);
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
    VehicleGear,
    VehicleRPM,
    ReserveForOtherPlugin
}
