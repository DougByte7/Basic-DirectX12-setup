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

struct VertexIn
{
	float3 Position : POSITION;
	float3 Normal : NORMAL;
};

struct VertexOut
{
	float4 Position : SV_POSITION;
	float3 WorldPosition : POSITION;
	float3 Normal : NORMAL;
};

VertexOut main(VertexIn vin)
{
	VertexOut vout;
	// Transform to world space.
	float4 posW = mul(float4(vin.Position, 1.0f), World);
	vout.WorldPosition = posW.xyz;
	vout.Position = posW;
	// Assumes nonuniform scaling; otherwise, need to use 
	// inverse-transpose of world matrix.
	vout.Normal = mul(vin.Normal, (float3x3)World);

	return vout;
}
