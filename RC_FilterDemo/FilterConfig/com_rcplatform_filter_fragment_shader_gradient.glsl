precision lowp float;
varying lowp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform float specIntensity;
uniform float specIntensity1;

void main()
{
    vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    vec4 bbTexel = texture2D(inputImageTexture2, textureCoordinate);

    vec4 filterResult = mix(texel , bbTexel, specIntensity) *(1.0 + 2.0*specIntensity);
    
    filterResult = vec4(((filterResult.rgb - vec3(0.5)) * specIntensity1 + vec3(0.5)), filterResult.w);
    gl_FragColor = filterResult;
}