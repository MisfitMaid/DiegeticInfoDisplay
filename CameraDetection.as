/**
 * pulled from https://github.com/openplanet-nl/camera/pull/2
 * 
 * todo: remove once this is in openplanet proper
 */

namespace Camera {
    enum ActiveCam {
        None = 0,
        Cam1 = 1,
        Cam2 = 2,
        Cam3 = 3,
        Cam1Alt = 4,
        Cam2Alt = 5,
        Cam3Alt = 6,
        FreeCam = 7,
        Backwards = 8,
        EditorOrbital,
        Orbital3d,
        Helico,
        HmdExternal,
        ThirdPerson,
        FirstPerson,
        Target,
        Cam0,
        Other,
        Loading
    }

	vec3 GetCurrentLookingDirection()
	{
		return g_direction;
	}

	ActiveCam GetCurrentGameCamera() {
		return g_activeCam;
	}

    mat4 g_rotation = mat4::Identity();
    vec3 g_direction = vec3();
    ActiveCam g_activeCam = ActiveCam::None;
}

void RenderEarly()
{
    if (Camera::GetCurrent() is null) return;
    iso4 camLoc = Camera::GetCurrent().Location;
	Camera::g_direction = vec3(camLoc.xz, camLoc.yz, camLoc.zz);
}
