namespace DID {
    const string LOOOOOOOONG = "                         ";

    void drawString(const string &in str, const vec2 &in start, const float &in z) {
        for (int i = 0; i < str.Length; i++) {
            auto char = str[i];
            // skip space
            if (char == 0x20) continue;
            vec2 offset = start + vec2(i*CSP.diegeticLetterSpacing, 0);
            // All unit8s have an array associated with it (even if empty)
            drawGlyph(GetFontGlyph(char), offset, z);
        }

    }

    TypesetContext _context;

    void drawGlyph(const vec3[] &in points, const vec2 &in start, float z) {
        _context.scale = -0.001*CSP.diegeticScale;
        _context.offset = start;
        _context.z = z;

        vec2 bez1, bez2;

        for (uint i = 0; i < points.Length; i++) {
            bool didRender = true;
            switch(int(points[i].x)) {
                case 0: // begin path
                    nvg::BeginPath();
                    break;
                case 1: // moveTo
                    didRender = nvgMoveTo(_context, points[i].y,points[i].z);
                    break;
                case 2: // lineTo
                    didRender = nvgLineTo(_context, points[i].y,points[i].z);
                    break;
                case 3: // stroke
                    nvg::Stroke();
                    break;
                case 4: // set bezier y1
                    bez1 = vec2(points[i].y, points[i].z);
                    break;
                case 5: // set bezier y2
                    bez2 = vec2(points[i].y, points[i].z);
                    break;
                case 6: // bezierTo
                    didRender = nvgBezierTo(_context, bez1, bez2, vec2(points[i].y, points[i].z));
                    break;
                default: break;
            }
            if (!didRender) return;
        }
    }
}
