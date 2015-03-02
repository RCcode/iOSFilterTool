precision highp float; 

varying vec2 textureCoordinate; 

uniform float specIntensity;
uniform sampler2D inputImageTexture;

void main() 
{ 
  vec2 uv  = textureCoordinate.xy;

  float dx =specIntensity/10.0;
  float dy = specIntensity/10.0;
    if(dx<.001||dy<.001){
        gl_FragColor=texture2D(inputImageTexture, textureCoordinate);
    }else{
        vec2 coord = vec2(dx * floor(uv.x / dx), dy * floor(uv.y / dy));
        vec3 tc = texture2D(inputImageTexture, coord).xyz;
        gl_FragColor = vec4(tc, 1.0);
    }
}