namespace DID {
    
    // handles all of our transforms to screen space from car space

    class TypesetContext {
        // svg2nvg calls have a context object, to enable the laziest copy-pasting
        // possible we'll just use that to pass data

        float scale;
        vec2 offset;
        float z;
    }

    bool nvgLineTo(TypesetContext context, float x, float y) {
        vec3 line = nvgTrans(context, x, y);
        if (line.z < 0) {
            nvg::LineTo(line.xy);
            return true;
        }
        return false;
    }

    bool nvgMoveTo(TypesetContext context, float x, float y) {
        vec3 line = nvgTrans(context, x, y);
        if (line.z < 0) {
            nvg::MoveTo(line.xy);
            return true;
        }
        return false;
    }

    bool nvgBezierTo(TypesetContext context, vec2 c1, vec2 c2, vec2 dest) {
        vec3 c1_3 = nvgTrans(context, c1);
        vec3 c2_3 = nvgTrans(context, c2);
        vec3 d_3 = nvgTrans(context, dest);

        if (c1_3.z < 0 && c2_3.z < 0 && d_3.z < 0) {
            nvg::BezierTo(c1_3.xy, c2_3.xy, d_3.xy);
            return true;
        }
        return false;
    }

    vec3 nvgTrans(TypesetContext context, float x, float y) {
        return nvgTrans(context, vec2(x, y));
    }

    vec3 nvgTrans(TypesetContext context, vec2 coords) {
        vec2 ws = (coords+context.offset)*context.scale;
        return Camera::ToScreen(projectHatSpace(vec3(ws, context.z)));
    }

    // stolen from hats mod
    vec3 projectHatSpace(vec3 point) {
        auto visState = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
        vec3 localPos = vec3(visState.Left.x, visState.Up.y, visState.Dir.z) * point;
        return visState.Position + localPos + visState.Dir + visState.Up;
    }
}

