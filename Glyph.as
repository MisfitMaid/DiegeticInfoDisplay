namespace DID {

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

    // todo: port funcs over to this with an array instead
    void drawGlyph(vec3[] points, const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;

        vec2 bez1, bez2;

        for (uint i = 0; i < points.Length; i++) {
            switch(int(points[i].x)) {
                case 0: // begin path
                    nvg::BeginPath();
                    break;
                case 1: // moveTo
                    nvgMoveTo(context, points[i].y,points[i].z);
                    break;
                case 2: // lineTo
                    nvgLineTo(context, points[i].y,points[i].z);
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
                    nvgBezierTo(context, bez1, bez2, vec2(points[i].y, points[i].z));
                    break;
                default: break;
            }
        }
    }
}
