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
        if (!isBehind(context, x, y)) nvg::LineTo(nvgTrans(context, x, y));
    }

    void nvgMoveTo(TypesetContext context, float x, float y) {
        if (!isBehind(context, x, y)) nvg::MoveTo(nvgTrans(context, x, y));
    }

    void nvgBezierTo(TypesetContext context, vec2 c1, vec2 c2, vec2 dest) {
        if (isBehind(context, c1.x, c1.y)) return;
        if (isBehind(context, c2.x, c2.y)) return;
        if (isBehind(context, dest.x, dest.y)) return;

        nvg::BezierTo(nvgTrans(context, c1.x, c1.y), nvgTrans(context, c2.x, c2.y), nvgTrans(context, dest.x, dest.y));
    }

    vec2 nvgTrans(TypesetContext context, float x, float y) {
        vec2 ws = (vec2(x,y)+context.offset)*context.scale*0.001*diegeticScale;
        return Camera::ToScreenSpace(projectHatSpace(vec3(ws.x*-1.0, ws.y*-1.0, context.z)));
    }

    bool isBehind(TypesetContext context, float x, float y) {
        vec2 ws = (vec2(x,y)+context.offset)*context.scale*0.001*diegeticScale;
        return Camera::IsBehind(projectHatSpace(vec3(ws.x*-1.0, ws.y*-1.0, context.z)));
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

