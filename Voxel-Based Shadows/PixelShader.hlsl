// Defaults for number of lights.
#ifndef NUM_DIR_LIGHTS
#define NUM_DIR_LIGHTS 1
#endif
#ifndef NUM_POINT_LIGHTS
#define NUM_POINT_LIGHTS 0
#endif
#ifndef NUM_SPOT_LIGHTS
#define NUM_SPOT_LIGHTS 0
#endif

// Include structures and functions for lighting.
#include "LightingUtil.hlsl"

// Constant data that varies per material.
cbuffer ConstantBuffer : register(b0)
{
	float4x4 World;
	float4x4 View;
	float4x4 InvView;
	float4x4 Proj;
	float4x4 InvProj;
	float4x4 ViewProj;
	float4x4 InvViewProj;
	float3 EyePosW;
	float cbPerObjectPad1;
	float2 RenderTargetSize;
	float2 InvRenderTargetSize;
	float NearZ;
	float FarZ;
	float TotalTime;
	float DeltaTime;
	float4 AmbientLight;
	Light Lights[MaxLights];
};

struct VertexOut
{
	float4 Position : SV_POSITION;
	float3 WorldPosition : POSITION;
	float3 Normal : NORMAL;
};

float4 main(VertexOut input) : SV_TARGET
{
	float4 DiffuseAlbedo = float4(0.3f,0.8f,0.3f,1.0f);
	float Roughness = 0.8f;
	float3 FresnelR0 = float3(0.1f, 0.1f, 0.1f);

	// Interpolating normal can unnormalize it, so renormalize it.
	input.Normal = normalize(input.Normal);

	// Vector from point being lit to eye.
	float3 toEyeW = normalize(EyePosW - input.WorldPosition);

	// Indirect lighting.
	float4 ambient = AmbientLight * DiffuseAlbedo;

	// Direct lighting.
	float shininess = 1.0f - Roughness;
	Material mat = { DiffuseAlbedo, FresnelR0, shininess };
	float3 shadowFactor = 1.0f;
	float4 directLight = ComputeLighting(Lights, mat, input.WorldPosition, input.Normal, toEyeW, shadowFactor);
	float4 litColor = ambient + directLight;

	// Common convention to take alpha from diffuse	material.
	litColor.a = DiffuseAlbedo.a;
	return litColor;
}