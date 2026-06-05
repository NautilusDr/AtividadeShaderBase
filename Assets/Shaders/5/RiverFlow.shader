Shader "AtividadeSup/5/RiverFlow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RiverSpeed ("Speed", range(.1, 2)) = .5
        _RiverWavesFrequency ("Frequency", range(.5, 2)) = .5
        _RiverWavesSize ("Size", range(.5, 2)) = .5
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
            float4 _MainTex_ST;
            float _RiverSpeed;
            float _RiverWavesFrequency;
            float _RiverWavesSize;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                float4 vertexChanger = v.vertex;
                vertexChanger.y += (sin(vertexChanger.x * _Time.y * _RiverWavesFrequency) * _RiverWavesSize);
                v2f o;
                o.vertex = UnityObjectToClipPos(vertexChanger);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x += _Time.y * _RiverSpeed;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
