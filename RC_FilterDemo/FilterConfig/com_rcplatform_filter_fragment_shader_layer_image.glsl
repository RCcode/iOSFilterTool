precision lowp float;
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform sampler2D inputImageTexture3;

uniform lowp float specIntensity;
uniform lowp float specIntensity2;
uniform lowp float specIntensity3;
uniform lowp float specIntensity4;
uniform lowp float specIntensity5;
uniform lowp float specIntensity6;

uniform lowp float specIntensity7;
uniform lowp float specIntensity8;
uniform lowp float specIntensity9;
uniform lowp float specIntensity10;
uniform lowp float specIntensity11;
uniform lowp float specIntensity12;
uniform lowp float vignetteFlag;


void main()
{
    
    vec3 luminancecoeff = vec3(0.2125, 0.7154, 0.0721);
    mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
    mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
    
    vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    vec4 texel1 = texture2D(inputImageTexture2, textureCoordinate);
    vec4 texel2 = texture2D(inputImageTexture3, textureCoordinate);
    float temp1 = specIntensity2;
    if (temp1 > 0.6){
        temp1 = 0.6;
    }
    vec4 filterResult1 = mix(texel , texel1, temp1) *(1.0 + 1.5*temp1);
    
    float temp2 = specIntensity3;
    if (temp2 > 0.6){
        temp2 = 0.6;
    }
    vec4 filterResult2 = mix(filterResult1 , texel2, temp2) *(1.0 + 1.5*temp2);
    vec4 filterResult3 = filterResult2 * (1.0 + specIntensity4);
    float intensityf = dot(filterResult3.rgb, luminancecoeff);
    vec3 intensity = vec3(intensityf, intensityf, intensityf);
    vec3 filterResult4 = filterResult3.rgb + specIntensity5 * (filterResult3.rgb - intensity);
    vec3 quFilter = vec3(specIntensity8, specIntensity9, specIntensity10);
    vec4 source = vec4(filterResult4, 1.0);
    vec3 yiq = RGBtoYIQ * source.rgb;
    yiq.b = clamp(yiq.b + specIntensity7*0.5226*0.1, -0.5226, 0.5226);
    vec3 rgb = YIQtoRGB * yiq;
    vec3 processed = vec3(
                          (rgb.r < 0.5 ? (2.0 * rgb.r * quFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - quFilter.r))),
                          (rgb.g < 0.5 ? (2.0 * rgb.g * quFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - quFilter.g))),
                          (rgb.b < 0.5 ? (2.0 * rgb.b * quFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - quFilter.b))));
    vec4 filterResult5 = vec4(mix(rgb, processed, specIntensity6), source.a);
    vec4 filterResult6 = vec4(((filterResult5.rgb - vec3(0.5)) * specIntensity11 + vec3(0.5)), filterResult5.w);
    vec4 filterResult7 = vec4((filterResult6.rgb + vec3(specIntensity12)), filterResult6.w);
    vec4 filterResult = filterResult7;
    
    if (vignetteFlag > .0){
        vec3 lumaCoeffs = vec3(.3, .59, .11);
        vec2 vignetteCenter = vec2( .5, .5);
        vec3 vignetteColor = vec3(.0, .0, .0);
        float vignetteStart = .3;
        float vignetteEnd = .70;
        float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
        float percent = smoothstep(vignetteStart, vignetteEnd, d);
        filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
    }
    
    gl_FragColor = vec4(mix(texel.rgb , filterResult.rgb, specIntensity),1.0);
    
    
}
