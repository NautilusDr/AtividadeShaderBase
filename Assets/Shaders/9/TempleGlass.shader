Shader "AtividadeSup/9/TempleGlass"
{
    Properties
    {
        _CellSize ("Cell Size", Range(.1, 2)) = 2
        _BorderColor ("Border Color", Color) = (0,0,0,1)
        _Offset ("Offset", Range(0, 100)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            float _CellSize;
            float _Offset;
            float3 _BorderColor;
            float rand3dTo1d(float3 value)
            {
                return frac(sin(dot(value,
                    float3(12.9898, 78.233, 37.719))) * 43758.5453);
            }

            float3 rand3dTo3d(float3 value)
            {
                return float3(
                    rand3dTo1d(value + float3(31.34, 47.77, 12.16)),
                    rand3dTo1d(value + float3(11.13, 83.17, 51.91)),
                    rand3dTo1d(value + float3(73.21, 19.42, 27.63))
                );
            }

            float3 rand1dTo3d(float value)
            {
                return float3(
                    frac(sin(value * 143.91) * 43758.5453),
                    frac(sin(value * 287.57) * 43758.5453),
                    frac(sin(value * 419.23) * 43758.5453)
                );
            }
            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            float3 voronoiNoise(float3 value)
            {
                float3 baseCell = floor(value);

                float minDistToCell = 10;
                float3 toClosestCell;
                float3 closestCell;

                [unroll]
                for(int x1 = -1; x1 <= 1; x1++)
                {
                    [unroll]
                    for(int y1 = -1; y1 <= 1; y1++)
                    {
                        [unroll]
                        for(int z1 = -1; z1 <= 1; z1++)
                        {
                            float3 cell = baseCell + float3(x1, y1, z1);
                            float3 cellPosition = cell + rand3dTo3d(cell);

                            float3 toCell = cellPosition - value;
                            float distToCell = length(toCell);

                            if(distToCell < minDistToCell)
                            {
                                minDistToCell = distToCell;
                                closestCell = cell;
                                toClosestCell = toCell;
                            }
                        }
                    }
                }

                float minEdgeDistance = 10;

                [unroll]
                for(int x2 = -1; x2 <= 1; x2++)
                {
                    [unroll]
                    for(int y2 = -1; y2 <= 1; y2++)
                    {
                        [unroll]
                        for(int z2 = -1; z2 <= 1; z2++)
                        {
                            float3 cell = baseCell + float3(x2, y2, z2);
                            float3 cellPosition = cell + rand3dTo3d(cell);

                            float3 toCell = cellPosition - value;

                            float3 diffToClosestCell = abs(closestCell - cell);
                            bool isClosestCell = diffToClosestCell.x + diffToClosestCell.y + diffToClosestCell.z < 0.1;

                            if(!isClosestCell)
                            {
                                float3 toCenter = (toClosestCell + toCell) * 0.5;

                                float3 cellDifference = normalize(toCell - toClosestCell);

                                float edgeDistance = dot(toCenter, cellDifference);

                                minEdgeDistance = min(minEdgeDistance, edgeDistance);
                            }
                        }
                    }
                }

                float random = rand3dTo1d(closestCell);

                return float3(minDistToCell, random, minEdgeDistance);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 value = i.worldPos / _CellSize;

                value.y +=  _Offset;

                float3 noise = voronoiNoise(value);

                float3 cellColor = rand1dTo3d(noise.y);

                float valueChange = fwidth(value.z) * 0.5;

                float isBorder = 1 - smoothstep(0.05 - valueChange, 0.05 + valueChange, noise.z);

                float3 color = lerp(cellColor, _BorderColor, isBorder);

                return float4(color, 1.0);
            }

            ENDCG
        }
    }
}