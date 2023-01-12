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
                default: break;
            }
        }
    }

    void draw0(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
        nvgMoveTo(context, 96.63930830411186, 100.63617764580441);
        nvgLineTo(context, 93.0903318814477, 138.29735607302973);
        nvgLineTo(context, 82.98009553360282, 170.22499112093513);
        nvgLineTo(context, 67.84686699649217, 191.55838351568534);
        nvgLineTo(context, 49.99615811018498, 199.04963400376363);
        nvgLineTo(context, 31.843087015344167, 191.3158134338892);
        nvgLineTo(context, 17.01600021437389, 170.22499112093513);
        nvgLineTo(context, 7.019149694728981, 138.94308836462946);
        nvgLineTo(context, 3.3530079162580932, 100.63617764580441);
        nvgLineTo(context, 7.019149694728981, 62.32915354115116);
        nvgLineTo(context, 17.01600021437389, 31.047137399017288);
        nvgLineTo(context, 31.843087015344167, 9.956617448271771);
        nvgLineTo(context, 49.99615811018498, 2.2225701067409034);
        nvgLineTo(context, 67.84686699649217, 9.713971775923511);
        nvgLineTo(context, 82.98009553360282, 31.047137399017288);
        nvgLineTo(context, 93.0903318814477, 62.97507480913123);
        nvgLineTo(context, 96.63930830411186, 100.63617764580441);
        nvgLineTo(context, 96.63930830411186, 100.63617764580441);
        nvg::Stroke();
    }

    void draw1(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
nvgMoveTo(context, 42.31691391895083, 18.0017955023838);
nvgLineTo(context, 57.67846371878056, 2.1864416023487365);
nvgLineTo(context, 57.67846371878056, 199.08793838219898);


        
        nvg::Stroke();
    }

    void draw2(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 96.09505632875118, 199.08792061841922);
nvgLineTo(context, 3.9010394192254125, 199.08792061841922);
nvgLineTo(context, 7.861984351016645, 183.7738794806054);
nvgLineTo(context, 18.30481912824871, 166.59290288620036);
nvgLineTo(context, 49.99615811018498, 128.44227563391115);
nvgLineTo(context, 81.691276619728, 88.26011449776023);
nvgLineTo(context, 92.13411139695995, 68.53929535167228);
nvgLineTo(context, 96.09505632875118, 49.670003775367306);
nvgLineTo(context, 92.59899329258042, 29.441972024464093);
nvgLineTo(context, 83.3845049875166, 14.82691672222802);
nvgLineTo(context, 70.35269379971498, 5.776837868054287);
nvgLineTo(context, 55.41222117054451, 2.2437354613382468);
nvgLineTo(context, 40.47552806898068, 4.1799874542358);
nvgLineTo(context, 27.443716881179057, 11.537593846142244);
nvgLineTo(context, 18.225449048508494, 24.268932589213506);
nvgLineTo(context, 14.72938601233784, 42.32638163560553);
        
        nvg::Stroke();
    }

    void draw3(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 13.674897810076686, 2.2203023901768972);
nvgLineTo(context, 95.01411143324322, 2.2203023901768972);
nvgLineTo(context, 30.913323224103124, 85.68323257553193);
nvgLineTo(context, 53.48844161874899, 87.75441370398762);
nvgLineTo(context, 70.88560719225563, 93.50042952440954);
nvgLineTo(context, 83.51678845375022, 102.21866585471753);
nvgLineTo(context, 91.80529249517974, 113.20764237111348);
nvgLineTo(context, 96.15552877045809, 125.76500945844967);
nvgLineTo(context, 96.98702484392572, 139.18902222599553);
nvgLineTo(context, 94.71552875231646, 152.77755783025978);
nvgLineTo(context, 89.75300900475747, 165.82867484507625);
nvgLineTo(context, 82.51143411037583, 177.64038648994756);
nvgLineTo(context, 73.4103316335121, 187.51066063004492);
nvgLineTo(context, 62.86167008329335, 194.7375331620366);
nvgLineTo(context, 51.27741796884675, 198.61899462825954);
nvgLineTo(context, 39.07710285451276, 198.4530355710506);
nvgLineTo(context, 26.66891372181192, 193.5377221232989);
nvgLineTo(context, 14.476157662691207, 183.1710070320653);
nvgLineTo(context, 2.903244131064639, 166.65091863496275);
        
        nvg::Stroke();
    }

    void draw4(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 76.81375844804302, 198.75783028355195);
nvgLineTo(context, 76.81375844804302, 2.1864416023487365);
nvgLineTo(context, 10.116283592015634, 150.46389581685946);
nvgLineTo(context, 90.37315389445985, 150.46389581685946);
        
        nvg::Stroke();
    }

    void draw5(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 82.74576482198916, 2.1749480588968595);
nvgLineTo(context, 24.832063304969438, 2.1749480588968595);
nvgLineTo(context, 17.590488410587795, 75.27441354676);
nvgLineTo(context, 36.18576423540901, 67.0478937580799);
nvgLineTo(context, 52.09001640428062, 65.4601142105174);
nvgLineTo(context, 65.36749688651582, 69.55447646682411);
nvgLineTo(context, 76.08245765142817, 78.37438208975155);
nvgLineTo(context, 84.30670972354426, 90.96361059481198);
nvgLineTo(context, 90.10072554457076, 106.36556354475698);
nvgLineTo(context, 93.52875708382146, 123.6236425023381);
nvgLineTo(context, 94.65505631060944, 141.78106005392658);
nvgLineTo(context, 91.61631611484597, 161.5312121137699);
nvgLineTo(context, 83.44119790161653, 178.00552665202804);
nvgLineTo(context, 71.53568594060289, 190.2969283816828);
nvgLineTo(context, 57.30576450148658, 197.4982513070534);
nvgLineTo(context, 42.16497690916253, 198.70240880253877);
nvgLineTo(context, 34.69285083077398, 196.7720906679837);
nvgLineTo(context, 27.519307433312406, 193.0023142425379);
nvgLineTo(context, 20.818204986684805, 187.27969369800127);
nvgLineTo(context, 14.77474034361785, 179.49080541089762);
nvgLineTo(context, 9.555212718805251, 169.5223391435789);
nvgLineTo(context, 5.341039437367044, 157.26083347729292);
        
        nvg::Stroke();
    }

    void draw6(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
nvgMoveTo(context, 95.64177783932405, 145.332674070312);
nvgLineTo(context, 92.16552247697774, 165.8988704592897);
nvgLineTo(context, 82.2712926014604, 183.3343982857773);
nvgLineTo(context, 67.46357754983649, 194.98602505443966);
nvgLineTo(context, 49.99734134024709, 199.07521030137093);
nvgLineTo(context, 32.230207263244836, 194.85482124972532);
nvgLineTo(context, 17.723036081542716, 183.3343982857773);
nvgLineTo(context, 7.941023410695834, 166.25239182199232);
nvgLineTo(context, 4.35432083113443, 145.332674070312);
nvgLineTo(context, 7.941023410695834, 124.4129563186317);
nvgLineTo(context, 17.723036081542716, 107.33094985484672);
nvgLineTo(context, 32.230207263244836, 95.81417144102966);
nvgLineTo(context, 49.99734134024709, 91.5901378392532);
nvgLineTo(context, 67.46357754983649, 95.67932308618447);
nvgLineTo(context, 82.2712926014604, 107.33094985484684);
nvgLineTo(context, 92.16552247697769, 124.76647768133432);
nvgLineTo(context, 95.64177783932399, 145.332674070312);
nvgLineTo(context, 95.64177783932399, 145.332674070312);
        nvg::Stroke();
        nvg::BeginPath();
        nvgMoveTo(context, 58.918078115311005, 2.196612227194919);
nvgLineTo(context, 39.547335403743716, 33.142487389131816);
nvgLineTo(context, 21.995077803823335, 66.87279885111809);
nvgLineTo(context, 9.264620029821458, 104.0508547369875);
nvgLineTo(context, 4.354320831134487, 145.332674070312);
        nvg::Stroke();
    }

    void draw7(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 0.8870551292857272, 2.241649162099378);
nvgLineTo(context, 98.79700281948419, 2.241649162099378);
nvgLineTo(context, 39.66602884618396, 199.03273157835386);
        
        nvg::Stroke();
    }

    void draw8(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 90.17166320757497, 43.12301029811431);
nvgLineTo(context, 87.01508759205933, 59.04898756244063);
nvgLineTo(context, 78.40494800352258, 72.05563074211409);
nvgLineTo(context, 65.63597545714254, 80.82464935110909);
nvgLineTo(context, 49.999334215988824, 84.04142502174557);
nvgLineTo(context, 34.359126222727355, 80.82464935110909);
nvgLineTo(context, 21.5901536763472, 72.05563074211409);
nvgLineTo(context, 12.98001408781056, 59.04898756244063);
nvgLineTo(context, 9.82343847229481, 43.12301029811431);
nvgLineTo(context, 12.98001408781056, 27.19703303378799);
nvgLineTo(context, 21.5901536763472, 14.190389854114414);
nvgLineTo(context, 34.359126222727355, 5.421371245119417);
nvgLineTo(context, 49.999334215988824, 2.2045955744830508);
nvgLineTo(context, 65.63597545714254, 5.421371245119417);
nvgLineTo(context, 78.40494800352258, 14.190389854114414);
nvgLineTo(context, 87.01508759205933, 27.19703303378799);
nvgLineTo(context, 90.17166320757497, 43.12301029811431);
nvgLineTo(context, 90.17166320757497, 43.12301029811431);
        
        nvg::Stroke();
        nvg::BeginPath();

nvgMoveTo(context, 98.13265391246887, 141.45499535325177);
nvgLineTo(context, 94.34832992595796, 163.7741306570507);
nvgLineTo(context, 84.03328282983193, 182.00252612399004);
nvgLineTo(context, 68.73191628682355, 194.2931062262959);
nvgLineTo(context, 49.999334215988824, 198.79879543619415);
nvgLineTo(context, 31.263185393046342, 194.2931062262959);
nvgLineTo(context, 15.961818850037844, 182.00252612399004);
nvgLineTo(context, 5.646771753911935, 163.7741306570507);
nvgLineTo(context, 1.8660145195088944, 141.45499535325177);
nvgLineTo(context, 5.529068934350221, 119.51041612069139);
nvgLineTo(context, 15.961818850037844, 100.90746458251351);
nvgLineTo(context, 31.57705957854398, 88.47367186473423);
nvgLineTo(context, 49.99933421598894, 84.11119527030962);
nvgLineTo(context, 68.41804210132591, 88.47367186473423);
nvgLineTo(context, 84.03328282983205, 100.90746458251351);
nvgLineTo(context, 94.46603274551967, 119.51041612069139);
nvgLineTo(context, 98.13265391246898, 141.45499535325177);
nvgLineTo(context, 98.13265391246898, 141.45499535325177);

        nvg::Stroke();
    }

    void draw9(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 4.34848931427365, 55.936698358015065);
nvgLineTo(context, 7.825135163125651, 35.36819216025242);
nvgLineTo(context, 17.720476453901085, 17.93070613329928);
nvgLineTo(context, 32.529854850793186, 6.2777707595180345);
nvgLineTo(context, 49.99805303636953, 2.188126252360462);
nvgLineTo(context, 67.76718288910718, 6.408989299854511);
nvgLineTo(context, 82.27598365609344, 17.930706133299168);
nvgLineTo(context, 92.05909513688044, 35.01463109323424);
nvgLineTo(context, 95.64620060944344, 55.936698358015065);
nvgLineTo(context, 92.05909513688044, 76.85876562279589);
nvgLineTo(context, 82.27598365609344, 93.94269058273096);
nvgLineTo(context, 67.76718288910718, 105.4607624567218);
nvgLineTo(context, 49.99805303636953, 109.68527046366967);
nvgLineTo(context, 32.529854850793186, 105.5956259565121);
nvgLineTo(context, 17.720476453901142, 93.94269058273085);
nvgLineTo(context, 7.825135163125708, 76.50520455577771);
nvgLineTo(context, 4.348489314273706, 55.936698358015065);
nvgLineTo(context, 4.348489314273706, 55.936698358015065);
        
        nvg::Stroke();
        nvg::BeginPath();

nvgMoveTo(context, 41.076314198174884, 199.08883594634256);
nvgLineTo(context, 60.44923281825464, 168.13948522417286);
nvgLineTo(context, 78.00346205691352, 134.4053854793043);
nvgLineTo(context, 90.73534983862601, 97.22315409114606);
nvgLineTo(context, 95.64620060944338, 55.936698358015065);

        nvg::Stroke();
    }

    
    void drawSlash(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
nvgMoveTo(context, 12.305726139284047, 199.08793838219898);
nvgLineTo(context, 87.68961370317129, 2.1864416023487365);
        
        nvg::Stroke();
    }
    
    void drawPlus(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 49.99768491661962, 63.56097251510957);
nvgLineTo(context, 49.99768491661962, 155.80994765866407);
        
        nvg::Stroke();
        nvg::BeginPath();
nvgMoveTo(context, 94.79867708717916, 109.68544118530474);
nvgLineTo(context, 5.196657776102711, 109.68544118530474);

        nvg::Stroke();
    }
    
    void drawMinus(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();

nvgMoveTo(context, 94.79867708717916, 109.68544118530474);
nvgLineTo(context, 5.196657776102711, 109.68544118530474);
        
        nvg::Stroke();
    }
    
    void drawPeriod(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
        nvgMoveTo(context, 58.700410188348314, 190.19684649065817);
nvgLineTo(context, 56.15300858145201, 196.53307334213784);
nvgLineTo(context, 49.99615811018498, 199.1576529027623);
nvgLineTo(context, 43.8430871665247, 196.53307334213784);
nvgLineTo(context, 41.295685559628396, 190.19684649065817);
nvgLineTo(context, 43.8430871665247, 183.8606196391785);
nvgLineTo(context, 49.99615811018498, 181.23604007855403);
nvgLineTo(context, 56.15300858145201, 183.8606196391785);
nvgLineTo(context, 58.700410188348314, 190.19684649065817);
nvgLineTo(context, 58.700410188348314, 190.19684649065817);
        
        nvg::Stroke();
    }
    
    void drawColon(const vec2 &in start, float z) {
        TypesetContext context;
        context.scale = 1;
        context.offset = start;
        context.z = z;
        
        nvg::BeginPath();
nvgMoveTo(context, 58.70242236375634, 138.26285338057514);
nvgLineTo(context, 56.15311243591623, 144.59908493032222);
nvgLineTo(context, 49.99839985292806, 147.22363980853396);
nvgLineTo(context, 43.84368726994012, 144.59908493032222);
nvgLineTo(context, 41.29437734209978, 138.26285338057514);
nvgLineTo(context, 43.84368726994012, 131.926611029924);
nvgLineTo(context, 49.99839985292806, 129.30206335231497);
nvgLineTo(context, 56.15311243591623, 131.926611029924);
nvgLineTo(context, 58.70242236375634, 138.26285338057514);
nvgLineTo(context, 58.70242236375634, 138.26285338057514);

        nvg::Stroke();
        nvg::BeginPath();

nvgMoveTo(context, 58.70242236375634, 81.1081774695586);
nvgLineTo(context, 56.15311243591623, 87.44434781418273);
nvgLineTo(context, 49.99839985292806, 90.06896749781875);
nvgLineTo(context, 43.84368726994012, 87.44434781418273);
nvgLineTo(context, 41.29437734209978, 81.1081774695586);
nvgLineTo(context, 43.84368726994012, 74.77200712493443);
nvgLineTo(context, 49.99839985292806, 72.14738744129843);
nvgLineTo(context, 56.15311243591623, 74.77200712493443);
nvgLineTo(context, 58.70242236375634, 81.1081774695586);
nvgLineTo(context, 58.70242236375634, 81.1081774695586);
        nvg::Stroke();
    }


}
