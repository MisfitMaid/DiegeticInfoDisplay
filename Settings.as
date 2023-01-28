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

[Setting category="Rendering" min=0 max=5000 drag name="Horizontal Distance" description="How far apart the left and right columns are"]
uint diegeticHorizontalDistance = 1000;

[Setting category="Rendering" min=0 max=5 drag name="Line Spacing" description="How far apart to place each row"]
float diegeticLineSpacing = 0.75;

[Setting category="Rendering" min=50 max=200 drag name="Letter Spacing" description="How much spacing to put between each character"]
float diegeticLetterSpacing = 110.0;

[Setting category="Rendering" name="Custom offset" description="Advanced adjustment, good luck!"]
vec3 diegeticCustomOffset = vec3(0,0,0);

[Setting category="Rendering" drag name="Scale" description="Advanced adjustment, good luck!"]
float diegeticScale = 1.0;

[Setting category="Rendering" color name="Diegetic Text Color"]
vec4 diegeticColor = vec4(1.0,1.0,1.0,0.75);

[Setting category="Rendering" color name="Diegetic Text Outline Color" description="Set alpha to 0 to disable. Note that this causes a pretty big performance hit if enabled."]
vec4 diegeticOutline = vec4(0,0,0,0);

[Setting category="Rendering" name="Font" description="Select a less-performance-intensive font, or add your own custom font (~/OpenplanetNext/PluginStorage/DID/font.custom.json)"];
DID::Fonts diegeticFont = DID::Fonts::Nixie;

[Setting category="Information" min=0 drag name="Delta-Time duration" description="How long (in ms) to show delta times"]
uint deltaTimeDuration = 3000;

[Setting category="Information" name="Delta-Time coloration" description="Color delta-times blue or red"]
bool deltaTimeColors = true;

[Setting category="Information" color name="Custom Color (L1)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL1 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (L2)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL2 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (L3)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL3 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (L4)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineL4 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (R1)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR1 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (R2)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR2 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (R3)" description="Set alpha to 0 to use default text color."]
vec4 CustomColorLineR3 = vec4(0,0,0,0);

[Setting category="Information" color name="Custom Color (R4)" description="Set alpha to 0 to use default text color."]
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
string LineR1 = "DID/NullProvider";

[Setting category="Information" hidden]
string LineR2 = "DID/NullProvider";

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

[SettingsTab name="Info to display"]
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
}

string laneSelectionDropdown(const string &in current, const string &in label) {
	if (UI::BeginCombo(label, friendlyDropdownName(DID::AddonHandler::getProvider(current).getProviderSetup()), UI::ComboFlags::None)) {
		for (uint i = 0; i < DID::AddonHandler::laneProviders.Length; i++) {
			DID::AddonHandler::LaneProvider@ lp = DID::AddonHandler::laneProviders[i];
			if (UI::Selectable(friendlyDropdownName(lp.getProviderSetup()), lp.getProviderSetup().internalName == current)) {
				UI::EndCombo();
				return lp.getProviderSetup().internalName;
			}
		}
		UI::EndCombo();
	}
	return current;
}

string friendlyDropdownName(DID::AddonHandler::LaneProviderSettings settings) {
	return "\\$z" + settings.friendlyName + "\\$666 by " + settings.author + "\\$z";
}

[SettingsTab name="Help & Credits"]
void RenderSettingsHelp()
{
	UI::TextWrapped("DID is currently in early development. If you encounter any issues or have a feature request, please reach out so that I can get it taken care of! :)");
	
	UI::Separator();
	
	UI::TextWrapped("If you are interested in supporting this project or just want to say hi, please consider taking a look at the below links "+Icons::Heart);
	
	UI::Markdown(Icons::Patreon + " [https://patreon.com/MisfitMaid](https://patreon.com/MisfitMaid)");
	UI::Markdown(Icons::Paypal + " [https://paypal.me/MisfitMaid](https://paypal.me/MisfitMaid)");
	UI::Markdown(Icons::Github + " [https://github.com/sylae/DiegeticInfoDisplay](https://github.com/sylae/DiegeticInfoDisplay)");
	UI::Markdown(Icons::Discord + " [https://discord.gg/BdKpuFcYzG](https://discord.gg/BdKpuFcYzG)");
	UI::Markdown(Icons::Twitch + " [https://twitch.tv/MisfitMaid](https://twitch.tv/MisfitMaid)");
}
