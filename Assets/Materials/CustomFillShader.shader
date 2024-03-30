Shader "Custom/CustomFillShader"
{
  Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FillAmount ("Fill Amount", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _FillAmount;

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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Преобразование координат UV в диапазон от -1 до 1
                float2 centeredUV = (i.uv - 0.5) * 2.0;
                // Инвертируем направление диагонали с учётом тангенса 66 градусов
                float diagonalUV = centeredUV.y - 2.246 * centeredUV.x;
                // Применяем _FillAmount, адаптированный под угол
                float alpha = step(diagonalUV, _FillAmount * 4 - 2.0);
                fixed4 texColor = tex2D(_MainTex, i.uv);
                texColor.a *= alpha;
                return texColor;
            }
            ENDCG
        }
    }
}


