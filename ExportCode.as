namespace DID {
    void SetLane(uint lane, const string &in text) {
        while (foreignLanes.Length < 8) { return; }
        foreignLanes[lane] = text;
    }

    void SetLaneColor(uint lane, vec4 color) {
        while (foreignLaneColors.Length < 8) { return; }
        foreignLaneColors[lane] = color;
    }

    vec4 GetDefaultColor() {
        return diegeticColor;
    }
}
