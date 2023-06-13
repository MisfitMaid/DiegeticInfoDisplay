namespace DID {

    class CameraSpecificSettings {
        uint diegeticHorizontalDistance;
        float diegeticLineSpacing;
        float diegeticLetterSpacing;
        vec3 diegeticCustomOffset;
        float diegeticScale;
        bool backwards;
    }

    CSceneVehicleVis@ vis = null;
    void ResetDrawState(CSceneVehicleVis@ _vis) {
        @vis = _vis;
    }

    class TypesetContext {
        float scale;
        vec2 offset;
        float z;
    }

    bool nvgLineTo(TypesetContext@ context, float x, float y) {
        vec3 line = nvgTrans(context, x, y);
        if (line.z < 0) {
            nvg::LineTo(line.xy);
            return true;
        }
        return false;
    }

    bool nvgMoveTo(TypesetContext@ context, float x, float y) {
        vec3 line = nvgTrans(context, x, y);
        if (line.z < 0) {
            nvg::MoveTo(line.xy);
            return true;
        }
        return false;
    }

    bool nvgBezierTo(TypesetContext@ context, const vec2 &in c1, const vec2 &in c2, const vec2 &in dest) {
        vec3 c1_3 = nvgTrans(context, c1);
        if (c1_3.z >= 0) return false;
        vec3 c2_3 = nvgTrans(context, c2);
        if (c2_3.z >= 0) return false;
        vec3 d_3 = nvgTrans(context, dest);
        if (d_3.z >= 0) return false;
        nvg::BezierTo(c1_3.xy, c2_3.xy, d_3.xy);
        return true;
    }

    vec3 nvgTrans(TypesetContext@ context, float x, float y) {
        return nvgTrans(context, vec2(x, y));
    }

    vec3 nvgTrans(TypesetContext@ context, const vec2 &in coords) {
        vec2 ws = (coords+context.offset)*context.scale;
        if (CSP.backwards) {
            return Camera::ToScreen(projectHatSpace(vec3(ws.x*-1, ws.y, context.z)));
        }
        return Camera::ToScreen(projectHatSpace(vec3(ws, context.z)));
    }

    // stolen from hats mod
    vec3 projectHatSpace(const vec3 &in point) {
        return vis.AsyncState.Position + (vis.AsyncState.Left * point.x) + (vis.AsyncState.Up * (point.y + 1.)) + (vis.AsyncState.Dir * (point.z + 1.));
    }
}
