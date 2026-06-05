Shader "AtividadeSup/3/Strech"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Velocity ("Y Velocity", range(.75, 1.25)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Velocity;
            float4 _Streched;

            v2f vert (appdata v)
            {
                v2f o;
                _Streched = v.vertex;
                _Streched.y *= _Velocity;
                o.vertex = UnityObjectToClipPos(_Streched);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
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
