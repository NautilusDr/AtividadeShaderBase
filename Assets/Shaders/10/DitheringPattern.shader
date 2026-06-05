Shader "AtividadeSup/10/DitheringPattern"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DitherPattern ("Dithering Pattern", 2D) = "white" {}
        _MinDistance ("Minimum Fade Distance", Float) = 0
        _MaxDistance ("Maximum Fade Distance", Float) = 1
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _DitherPattern;
            float4 _DitherPattern_TexelSize;

            float _MinDistance;
            float _MaxDistance;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;

                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                float2 ditherUV = screenUV * _ScreenParams.xy * _DitherPattern_TexelSize.xy;
                float ditherValue = tex2D(_DitherPattern, ditherUV).r;
                float relDistance = i.screenPos.w;
                relDistance = (relDistance - _MinDistance) / (_MaxDistance - _MinDistance);
                clip(relDistance - ditherValue);

                return texColor;
            }

            ENDCG
        }
    }
}