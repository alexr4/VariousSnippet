#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec4 fk3f[32];
uniform vec4 fres;
uniform sampler2D tex0;
uniform sampler2D tex1;
uniform float rad;


varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void)
{
    vec4 zbu = texture2D( tex0, vertTexCoord);

    vec3 ep = zbu.x*vertTexCoord.xyz/vertTexCoord.z;

    vec4 pl = texture2D( tex1, vertColor.xy*fres.xy);
    pl = pl*2.0 - vec4(1.0);

    float bl = 0.0;
    for( int i=0; i<32; i++ )
    {
        vec3 se = ep + rad*reflect(fk3f[i].xyz,pl.xyz);

        vec2 ss = (se.xy/se.z)*vec2(.75,1.0);
        vec2 sn = ss*.5 + vec2(.5);
        vec4 sz = texture2D(tex0,sn);

        float zd = 50.0*max( se.z-sz.x, 0.0 );
        bl += 1.0/(1.0+zd*zd);
   }

   gl_FragColor = vec4(bl/32.0);
}
