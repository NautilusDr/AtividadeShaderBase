Shader "AtividadeSup/8/ToonShader"
{
    Properties
    {
        _Color ("Tint", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Specular ("Specular Color", Color) = (1,1,1,1)
        [HDR] _Emission ("Emission", Color) = (0,0,0,1)
        _ShadowTint ("Shadow Color", Color) = (0.5,0.5,0.5,1)
        _StepAmount ("Shadow Steps", Range(1,16)) = 2
        _StepWidth ("Step Size", Range(0,1)) = 0.25
        _SpecularSize ("Specular Size", Range(0,1)) = 0.1
        _SpecularFalloff ("Specular Falloff", Range(0,2)) = 1
    }

    SubShader
    {
        Tags{ "RenderType"="Opaque" "Queue"="Geometry" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color;
            fixed4 _Specular;
            fixed4 _Emission;

            float4 _ShadowTint;

            float _StepWidth;
            float _StepAmount;
            float _SpecularSize;
            float _SpecularFalloff;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;

                float2 uv : TEXCOORD0;

                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

                fixed4 texColor = tex2D(_MainTex, i.uv) * _Color;

                float NdotL = dot(normal, lightDir);

                float stepped = NdotL / _StepWidth;

                float lightIntensity = floor(stepped);

                float change = fwidth(stepped);

                float smoothing = smoothstep(0, change, frac(stepped));

                lightIntensity += smoothing;

                lightIntensity /= _StepAmount;

                lightIntensity = saturate(lightIntensity);

                float3 reflectionDir = reflect(-lightDir, normal);

                float towardsReflection = dot(viewDir, reflectionDir);

                float specularFalloff = saturate(dot(viewDir, normal));

                specularFalloff = pow(specularFalloff, _SpecularFalloff);

                towardsReflection *= specularFalloff;

                float specularChange = fwidth(towardsReflection);

                float specularIntensity = smoothstep(1 - _SpecularSize, 1 - _SpecularSize + specularChange, towardsReflection);

                float3 shadowColor = texColor.rgb * _ShadowTint.rgb;

                float3 diffuse = texColor.rgb * lightIntensity * _LightColor0.rgb;

                diffuse = lerp(diffuse, _Specular.rgb * _LightColor0.rgb, saturate(specularIntensity));

                float3 finalColor = diffuse + shadowColor + _Emission.rgb;

                return fixed4(finalColor, texColor.a);
            }

            ENDCG
        }
    }
}