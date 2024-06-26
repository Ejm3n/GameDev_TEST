Shader "Custom/CustomFillShader"
{
  Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FillAmount ("Fill Amount", Range(0,1)) = 0.5
        _Angle ("Angle", Range(0,90)) = 68
        _FillAmountMultiplier ("Fill Amount Multiplier", Range(0,5)) = 4.3
        _FillAmountMinus("Fill Amount Minus", Range(0,5)) = 2.2
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
            float _Angle;
            float _FillAmountMultiplier;
            float _FillAmountMinus;

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
                // �������������� ��������� UV � �������� �� -1 �� 1
                float2 centeredUV = (i.uv - 0.5) * 2.0;
                // ����������� ����������� ��������� � ������ �������� 66 ��������
                float diagonalUV = centeredUV.y - tan(_Angle * 3.14159265 / 180.0) * centeredUV.x;
                // ��������� _FillAmount, �������������� ��� ����, �� ������ ��� ��� ��������� ���������
                float alpha = step(-diagonalUV, _FillAmount * _FillAmountMultiplier - _FillAmountMinus);
                fixed4 texColor = tex2D(_MainTex, i.uv);
                texColor.a *= alpha;
                return texColor;
            }
            ENDCG
        }
    }
}




