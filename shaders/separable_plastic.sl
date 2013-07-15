class separable_plastic(

    float Ks = 0.5;
    float Kd = 0.5;
    float Ka = 1.0;
    float roughness = 0.1;
    color specularcolor = 1.0;

) {

    public void opacity(output color Oi) {

        Oi = Os;

    }

    public void diffuselighting(output color Ci, Oi) {

        normal Nf;

        Nf = faceforward(normalize(N), I);

        Oi = Os;
        Ci = Os * Cs * (Ka * ambient() + Kd * diffuse(Nf));
    }
    
    public void specularlighting(output color Ci, Oi) {

        normal Nf;
        vector V;

        Nf = faceforward(normalize(N), I);
        V = -normalize(I);

        Oi = Os;
        Ci = specularcolor * Ks * specular(Nf, V, roughness);

    }

}
