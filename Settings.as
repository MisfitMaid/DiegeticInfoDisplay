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



[Setting category="Information" min=0 drag name="Delta-Time duration" description="How long (in ms) to show delta times"]
uint deltaTimeDuration = 3000;

[Setting category="Information" min=0 drag name="Delta-Time coloration" description="Color delta-times blue or red"]
bool deltaTimeColors = true;

[Setting category="Information"]
DIDInformationTypes LineL1 = DIDInformationTypes::Empty;

[Setting category="Information"]
DIDInformationTypes LineL2 = DIDInformationTypes::Empty;

[Setting category="Information"]
DIDInformationTypes LineL3 = DIDInformationTypes::LapCounter;

[Setting category="Information"]
DIDInformationTypes LineL4 = DIDInformationTypes::CheckpointCounter;

[Setting category="Information"]
DIDInformationTypes LineR1 = DIDInformationTypes::Empty;

[Setting category="Information"]
DIDInformationTypes LineR2 = DIDInformationTypes::Empty;

[Setting category="Information"]
DIDInformationTypes LineR3 = DIDInformationTypes::LastCheckpointTime;

[Setting category="Information"]
DIDInformationTypes LineR4 = DIDInformationTypes::CurrentRaceTime;

[SettingsTab name="Help & Credits"]
void RenderHelp()
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
