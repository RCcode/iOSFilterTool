attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;

uniform mat4 uMVPMatrix;
uniform mat4 uSTMatrix;
void main(){
    gl_Position = uMVPMatrix * position;
    textureCoordinate =(uSTMatrix*inputTextureCoordinate).xy;
}