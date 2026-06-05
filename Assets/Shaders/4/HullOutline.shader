Shader "AtividadeSup/4/HullOutline"
{
    Properties
    {
        _Tint ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineSize ("Size", range(1, 2)) = 1
        _YSize ("Y Strech", range(.75, 1.25)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Pass
        {
            Cull front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _OutlineSize;
            float _YSize;
            fixed4 _Tint;
            float4 _ScaledVertex;

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
                v2f o;
                _ScaledVertex = v.vertex * _OutlineSize;
                _ScaledVertex.y *= _YSize;
                o.vertex = UnityObjectToClipPos(_ScaledVertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Tint;
                return col;
            }
            ENDCG
        }
    }
}
