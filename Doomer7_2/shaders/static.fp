
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


void kaede_static()
{
    vec2 coords = TexCoord;
    coords.x = round( coords.x * resX ) / resX;
    coords.y = round( coords.y * resY ) / resY;
    float noise = rand( coords.xy * timer );
	float alpha = clamp( ( 1 - ( timer / 10 ) ), 0.33, 1.0 );
    vec4 stat = vec4(1,1,1,1) * mod( timer * noise.x, 1 );
	
    FragColor = mix( vec4( texture( InputTexture, TexCoord ) ), stat, alpha );
}

void main()
{
	if ( true )
	{
		kaede_static();
	}
}