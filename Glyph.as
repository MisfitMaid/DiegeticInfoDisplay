namespace DID {
    const string LOOOOOOOOOOOOOOONG = "                         ";

    void drawString(const string &in str, const vec2 &in start, const float &in z) {
        for (int i = 0; i < str.Length; i++) {
            string l = str.SubStr(i, 1);
            vec2 offset = start + vec2(i*diegeticLetterSpacing, 0);
            if (l == " ") continue; // space

            if (font.Exists(l)) {
                dictionaryValue dv = font[l];
                drawGlyph(cast<vec3[]>(dv), offset, z);
            } else {
                warn("no glyph for char "+l);
            }
        }

    }

    // just one object is fine thx. saves .1ms mb
    TypesetContext _context;

    // saves 0.02 mb
    // void drawGlyph(const vec3[] &in points, const vec2 &in start, float z) {
    void drawGlyph(const vec3[] &in points, const vec2 &in start, float z) {
        _context.scale = -0.001*diegeticScale;
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
