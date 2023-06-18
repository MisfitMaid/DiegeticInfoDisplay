[Setting category="Rendering" name="Enable" description="Toggle the plugin on or off"]
bool diegeticEnabled = true;

[Setting category="Rendering" name="Hide with hidden UI" description="Hides the plugin when UI is disabled"]
bool diegeticDisabledWithUI = false;

[Setting category="Rendering" name="Quick enable toggle" description="Toggle the plugin via keyboard"]
VirtualKey diegeticEnabledShortcut;

[Setting category="Rendering" name="Render Demo" description="Places text in every line to aid in configuring layout"]
bool renderDemo = false;

[Setting category="Rendering" min=0 max=10 drag name="Stroke Width" description="How thicc to draw the diegetic text"]
float diegeticStrokeWidth = 3.0;

[Setting category="Rendering" name="Font" description="Select a less-performance-intensive font, or add your own custom font (~/OpenplanetNext/PluginStorage/DID/font.custom.json)"];
DID::Fonts diegeticFont = DID::Fonts::SixteenSegment;

[Setting category="Colors" color name="Diegetic Text Color"]
vec4 diegeticColor = vec4(1.0,1.0,1.0,0.75);

[Setting category="Colors" color name="Diegetic Text Outline Color" description="Set alpha to 0 to disable. Note that this causes a pretty big performance hit if enabled."]
vec4 diegeticOutline = vec4(0,0,0,0);

[Setting category="Colors" min=0 drag name="Delta-Time duration" description="How long (in ms) to show delta times"]
uint deltaTimeDuration = 3000;

[Setting category="Colors" name="Delta-Time coloration" description="Color delta-times blue or red"]
bool deltaTimeColors = true;

[Setting category="Colors" color name="Custom Color (L1)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL1 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (L2)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL2 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (L3)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL3 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (L4)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL4 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (R1)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR1 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (R2)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR2 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (R3)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR3 = vec4(0,0,0,0);

[Setting category="Colors" color name="Custom Color (R4)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR4 = vec4(0,0,0,0);

[Setting category="Information" hidden]
string LineL1 = "DID/NullProvider";

[Setting category="Information" hidden]
string LineL2 = "DID/NullProvider";

[Setting category="Information" hidden]
string LineL3 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/CurrentLap";
#else
	"DID/NullProvider";
#endif

[Setting category="Information" hidden]
string LineL4 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/CurrentCheckpoint";
#else
	"DID/NullProvider";
#endif

[Setting category="Information" hidden]
string LineR1 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/NoRespawnSplits";
#else
	"DID/NullProvider";
#endif

[Setting category="Information" hidden]
string LineR2 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/NoRespawnTime";
#else
	"DID/NullProvider";
#endif

[Setting category="Information" hidden]
string LineR3 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/SplitDelta";
#else
	"DID/NullProvider";
#endif

[Setting category="Information" hidden]
string LineR4 =
#if DEPENDENCY_MLFEEDRACEDATA && DEPENDENCY_MLHOOK
	"DID/RaceTimeSplit";
#else
	"DID/NullProvider";
#endif

[SettingsTab name="Info to display" order="1" icon="InfoCircle"]
void RenderSettingsInformation() {
	LineL1 = laneSelectionDropdown(LineL1, "Top Left");
	LineL2 = laneSelectionDropdown(LineL2, "Upper Mid Left");
	LineL3 = laneSelectionDropdown(LineL3, "Lower Mid Left");
	LineL4 = laneSelectionDropdown(LineL4, "Bottom Left");
	UI::Separator();
	LineR1 = laneSelectionDropdown(LineR1, "Top Right");
	LineR2 = laneSelectionDropdown(LineR2, "Upper Mid Right");
	LineR3 = laneSelectionDropdown(LineR3, "Lower Mid Right");
	LineR4 = laneSelectionDropdown(LineR4, "Bottom Right");
#if !DEPENDENCY_MLFEEDRACEDATA
	UI::Markdown("Some builtin info providers require [MLFeed](https://openplanet.dev/plugin/mlfeedracedata), which is not loaded. Please install this plugin to enable these.");
#endif
}

string laneSelectionDropdown(const string &in current, const string &in label) {
	string currentLabel;
	try {
		currentLabel = friendlyDropdownName(DID::getProvider(current).getProviderSetup());
	} catch {
		currentLabel = "";
	}
	if (UI::BeginCombo(label, currentLabel, UI::ComboFlags::None)) {
		for (uint i = 0; i < DID::laneProviders.Length; i++) {
			DID::LaneProvider@ lp = DID::laneProviders[i];
			if (UI::Selectable(friendlyDropdownName(lp.getProviderSetup()), lp.getProviderSetup().internalName == current)) {
				UI::EndCombo();
				return lp.getProviderSetup().internalName;
			}
		}
		UI::EndCombo();
	}
	return current;
}

string friendlyDropdownName(DID::LaneProviderSettings settings) {
	return "\\$z" + settings.friendlyName + "\\$666 by " + settings.author + "\\$z";
}

[SettingsTab name="Help & Credits" order="2" icon="QuestionCircle"]
void RenderSettingsHelp()
{
	UI::TextWrapped("DID is currently in early development. If you encounter any issues or have a feature request, please reach out so that I can get it taken care of! :)");

	UI::Separator();

	UI::TextWrapped("If you are interested in supporting this project or just want to say hi, please consider taking a look at the below links "+Icons::Heart);

	UI::Markdown(Icons::Patreon + " [https://patreon.com/MisfitMaid](https://patreon.com/MisfitMaid)");
	UI::Markdown(Icons::Paypal + " [https://paypal.me/MisfitMaid](https://paypal.me/MisfitMaid)");
	UI::Markdown(Icons::Github + " [https://github.com/MisfitMaid/DiegeticInfoDisplay](https://github.com/MisfitMaid/DiegeticInfoDisplay)");
	UI::Markdown(Icons::Discord + " [https://discord.gg/BdKpuFcYzG](https://discord.gg/BdKpuFcYzG)");
	UI::Markdown(Icons::Twitch + " [https://twitch.tv/MisfitMaid](https://twitch.tv/MisfitMaid)");
	
	UI::Separator();
	
	switch (useCameraDetection) {
		case CameraDetectionMode::Auto:
			UI::TextWrapped("Advanced camera detection support: " + Camera::CameraNodSafe);
			break;
		case CameraDetectionMode::On:
			UI::TextWrapped("Forced on, current reported status: " + Camera::CameraNodSafe);
			break;
		case CameraDetectionMode::Off:
			UI::TextWrapped("Forced off, current reported status: " + Camera::CameraNodSafe);
			break;
	}
	
	UI::TextWrapped("Game version: " + GetApp().SystemPlatform.ExeVersion);
	UI::SameLine();
	if (UI::Button(Icons::Clipboard)) {
		IO::SetClipboard(GetApp().SystemPlatform.ExeVersion);
	}
}
