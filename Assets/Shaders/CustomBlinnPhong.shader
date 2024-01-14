Shader "Custom/CustomBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecularIntensity ("Specular Intensity", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf CustomBlinnPhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        float _SpecularIntensity;

        half4 LightingCustomBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half3 h = normalize (lightDir + viewDir);
            half diffFactor = max (0, dot (s.Normal, lightDir));

            half nh = max (0, dot (s.Normal, h));
            half specFactor = pow (nh, s.Specular * 64.0);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diffFactor + _LightColor0.rgb * specFactor * _SpecularIntensity) * atten;
            c.a = s.Alpha;
            return c;
        }

        sampler2D _MainTex;
        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
