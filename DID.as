void Main() {
    DID::Main();
}

void Render() {
    if (UI::IsGameUIVisible() || !diegeticDisabledWithUI) {
        if (!DID::diegeticDisplayOverridden) {
            DID::Render();
        }
    }
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
        auto vp = VehicleState::GetViewingPlayer();
        if (vp is null) return;
        auto vis = VehicleState::GetVis(GetApp().GameScene, vp);
        if (vis is null) return;

        if (GetApp().Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) return;

        DID::ResetDrawState(vis);

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
        // copying to leftPadded is cheap enough to be negligiable performance wise
        for (uint i = 0; i < 4; i++) {
            leftPadded[i] = LOOOOOOOONG.SubStr(0, maxLen - lanes[i].content.Length) + lanes[i].content;
        }

        int leftOffset = (diegeticHorizontalDistance + maxLen*100) * -1;
        int rightOffset = diegeticHorizontalDistance;
        for (uint i = 0; i < 4; i++) {
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

    DID::LaneConfig@[] lanes;


    void Main() {
        init();
        while (true) {
            auto app = cast<CTrackMania>(GetApp());
            auto map = app.RootMap;

            if(map is null || map.MapInfo.MapUid == "" || VehicleState::GetViewingPlayer() is null) {
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

        registerLaneProviderAddon(NullProvider());
        registerLaneProviderAddon(FrontSpeedProvider());
        registerLaneProviderAddon(SideSpeedProvider());
        registerLaneProviderAddon(SteeringProvider());
        registerLaneProviderAddon(WetTiresProvider());
        registerLaneProviderAddon(GearProvider());
        registerLaneProviderAddon(RPMProvider());
        registerLaneProviderAddon(IceTireProviderAvg());
        registerLaneProviderAddon(IceTireProviderFL());
        registerLaneProviderAddon(IceTireProviderFR());
        registerLaneProviderAddon(IceTireProviderRL());
        registerLaneProviderAddon(IceTireProviderRR());

#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
        registerLaneProviderAddon(RaceTimeHandler());
        registerLaneProviderAddon(RaceTimeSplitHandler());
        registerLaneProviderAddon(SplitDeltaHandler());
        registerLaneProviderAddon(CurrentLapHandler());
        registerLaneProviderAddon(CurrentLapAlwaysHandler());
        registerLaneProviderAddon(CurrenCheckpointHandler());
        registerLaneProviderAddon(NoRespawnTimeHandler());
        registerLaneProviderAddon(NoRespawnSplitsHandler());
#endif


#if DEPENDENCY_SPLITSPEEDS
        DID::registerLaneProviderAddon(SplitSpeedsDiffProvider());
        DID::registerLaneProviderAddon(SplitSpeedsSpeedProvider());
#endif

        // fill all our slots with empty info to prevent NPE on first frame running
        for (uint i = 0; i < 8; i++) {
            @lanes[i] = getInfoText("DID/NullProvider", i);
        }

        SetLaneProvidersFromSettings();
    }

    // Currently, this takes about 0.3ms for me which is approx 1/3 of total execution time with a basic DID layout.
    // This is most likely due to bad memory reuse.
    // Suggestion: add a `.Update` method to `LaneConfig` that can copy values from an update source.
    // Recreating the objects each frame is SLOOOOOOOW
    void SetLaneProvidersFromSettings() {
        @lanes[0] = getInfoText(LineL1, 0);
        @lanes[1] = getInfoText(LineL2, 1);
        @lanes[2] = getInfoText(LineL3, 2);
        @lanes[3] = getInfoText(LineL4, 3);

        @lanes[4] = getInfoText(LineR1, 4);
        @lanes[5] = getInfoText(LineR2, 5);
        @lanes[6] = getInfoText(LineR3, 6);
        @lanes[7] = getInfoText(LineR4, 7);
    }

    void step() {
        if (!diegeticEnabled) return;
        // this is kinda dumb but whatever
        SetLaneProvidersFromSettings();
        return;
    }

    // using one instance of this only saves 0.05ms
    LaneConfig defaults();
    LaneConfig@ getInfoText(const string &in type, uint slot) {
        defaults.color = getDefaultLaneColor(slot);

        if (renderDemo) {
            DemoProvider dp;
            return dp.getLaneConfig(defaults);
        }

        try {
            if (hasProvider(type)) {
                LaneProvider@ lp = getProvider(type);
                return lp.getLaneConfig(defaults);
            }
        } catch {
            warn("error requesting string for slot " + Text::Format("%d", slot));
        }
        NullProvider np;
        return np.getLaneConfig(defaults);
    }

    vec4 getDefaultLaneColor(uint slot) {
        vec4 customSlotColor;
        if (slot == 0) customSlotColor = CustomColorLineL1;
        if (slot == 1) customSlotColor = CustomColorLineL2;
        if (slot == 2) customSlotColor = CustomColorLineL3;
        if (slot == 3) customSlotColor = CustomColorLineL4;
        if (slot == 4) customSlotColor = CustomColorLineR1;
        if (slot == 5) customSlotColor = CustomColorLineR2;
        if (slot == 6) customSlotColor = CustomColorLineR3;
        if (slot == 7) customSlotColor = CustomColorLineR4;

        if (customSlotColor.w == 0.0) return diegeticColor;
        return customSlotColor;
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


    dictionary font;
    /**
     * Only chars included currently: [0-9+-.:/]
     * ascii: 0x30-39 for 0-9
     * 0x2b for `+`, then `,-./` in order
     * 0x3a for `:`
     */
    vec3[][] fontGlyphs = array<array<vec3>>(256);
    const vec3[]@ GetFontGlyph(uint8 char) {
        auto ret = fontGlyphs[char];
        if (char == 0x20 || ret.Length > 0) return ret;
        throw('No glyph for char: ' + char);
        return {};
    }

    void loadFont() {
        Json::Value json;
        switch (diegeticFont) {
            case Fonts::Custom:
                json = Json::FromFile(IO::FromStorageFolder("font.custom.json"));
                break;
            case Fonts::SevenSegment:
                json = Json::FromFile("font.sevenSegment.json");
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
            auto char = glyph[0];
            auto gIx = int(char); // - fontCharOffset;
            fontGlyphs[gIx].Resize(pts.Length);
            for (uint v = 0; v < pts.Length; v++) {
                fontGlyphs[gIx][v] = pts[v];
            }
            font.Set(glyph, pts);
        }
    }

    enum Fonts {
        Nixie,
        NixieReduced,
        SevenSegment,
        Custom
    }
}
