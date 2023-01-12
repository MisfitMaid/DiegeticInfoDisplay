namespace DID {
    
    // handles all of our transforms to screen space from car space

    class TypesetContext {
        // svg2nbg calls have a context object, to enable the laziest copy-pasting
        // possible we'll just use that to pass data

        float scale;
        vec2 offset;
        float z;
    }

    void nvgLineTo(TypesetContext context, float x, float y) {
        nvg::LineTo(nvgTrans(context, x, y));
    }

    void nvgMoveTo(TypesetContext context, float x, float y) {
        nvg::MoveTo(nvgTrans(context, x, y));

    }

    vec2 nvgTrans(TypesetContext context, float x, float y) {
        vec2 ws = (vec2(x,y)+context.offset)*context.scale*0.001*diegeticScale;
        return Camera::ToScreenSpace(projectHatSpace(vec3(ws.x*-1.0, ws.y*-1.0, context.z)));
    }

    // stolen from hats mod
    vec3 offsetHatPoint(vec3 point) {
        auto visState = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
        point += visState.Dir;
        point += visState.Up;
        return point;
    }

    // stolen from hats mod
    vec3 projectHatSpace(vec3 point) {
        auto visState = VehicleState::GetVis(GetApp().GameScene, VehicleState::GetViewingPlayer()).AsyncState;
        return offsetHatPoint(visState.Position + (visState.Left * point.x) + (visState.Up * point.y) + (visState.Dir * point.z));
    }

    vec3 projectHatSpace(vec2 point) {
        return projectHatSpace(vec3(point.x, point.y, 0));
    }
}

