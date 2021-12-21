
//Shader created by Cherno

highp float rand(vec2 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}


void main()
{
    vec2 coords = TexCoord;
    coords.x = round(coords.x * resX) / resX;
    coords.y = round(coords.y * resY) / resY;
    float noise = rand(coords.xy * timer);
    vec4 stat = vec4(1,1,1,1) * (noise.x > 0.5 ? 1 : 0);
    
    FragColor = mix(vec4(texture(InputTexture, TexCoord)),stat,0.07);
}