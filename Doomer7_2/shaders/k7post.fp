
// Initial KAEDE static shader created by Cherno
// Modified by Sage

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
	float in_ratio = clamp( static_timer / 30, 0, 1 );
	float scale = mix( 3.0, 0.5, in_ratio );
    vec2 coords = TexCoord;
    coords.x = ( round( coords.x * ( resX / scale ) ) / ( resX / scale ) );
    coords.y = ( round( coords.y * ( resY / scale ) ) / ( resY / scale ) );
    float noise = rand( coords.xy * static_timer );
	float alpha = mix( 0.66, 0.15, in_ratio );
    vec4 stat = vec4( 1, 1, 1, 1 ) * mod( static_timer * noise.x + ( TexCoord.y ), 1 );
	
	stat[0] = mod( noise.x * 45, 1 );
	stat[1] = mod( noise.x + 0.33, 1 );
	stat[3] = mod( noise.x + 0.66, 1 );
	
    FragColor = mix( vec4( texture( InputTexture, TexCoord ) ), stat, alpha );
}

void main()
{
	FragColor = vec4( texture( InputTexture, TexCoord ) );
	if ( static_timer > 0 )
	{
		kaede_static();
	}
}