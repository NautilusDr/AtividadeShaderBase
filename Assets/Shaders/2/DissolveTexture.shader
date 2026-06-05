Shader "AtividadeSup/2/Dissolve"
{
    Properties {
        //Textura pré-dissolução e cor padrão dela.
        _Color ("Tint", Color) = (0, 0, 0, 1)
        _MainTex ("Texture", 2D) = "white" {}

        //Padrão na qual irá ocorrer a dissolução e porcentagem
        [Header(Dissolve)]
        _DissolveTex ("Dissolve Texture", 2D) = "black" {}
        _DissolveAmount ("Dissolve Amount", Range(0, 1)) = 0

        //Brilho que irá ocorrer ao redor do padrão de dissolução
        [Header(Glow)]
        //Cor do brilho
        _GlowColor("Color", Color) = (1, 1, 1, 1)
        //Tempo em que o brilho aparece antes do padrão
        _GlowRange("Range", Range(0, .3)) = 0.1
        //Tempo que ele dure após aparecer
        _GlowFalloff("Falloff", Range(0.001, .3)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _DissolveTex;

            fixed4 _Color;

            float _DissolveAmount;

            float3 _GlowColor;
            float _GlowRange;
            float _GlowFalloff;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float dissolve = tex2D(_DissolveTex, i.uv).r;
                dissolve *= 0.999;

                float isVisible = dissolve - _DissolveAmount;

                clip(isVisible);

                float isGlowing =
                    smoothstep(
                        _GlowRange + _GlowFalloff,
                        _GlowRange,
                        isVisible);

                float3 glow = isGlowing * _GlowColor;

                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;

                return fixed4(col.rgb + glow * 10, 1);
            }

            ENDCG
        }
    }
}