precision lowp float;




varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

uniform highp float specIntensity;
uniform float specIntensity2;

void main()
{
    
    vec2 sampleDivisor = vec2(specIntensity, specIntensity / 1.0);
    
    vec2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
    if (specIntensity >= 0.001){
        gl_FragColor = texture2D(inputImageTexture, samplePos);
    }else{
        gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
    }
    
}