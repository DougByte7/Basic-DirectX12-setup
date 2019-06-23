#pragma once

struct Vertex
{
	Vertex() {}
	Vertex(float px, float py, float pz, float nx, float ny, float nz) : position(px, py, pz), normal(nx, ny, nz) {}
	DirectX::XMFLOAT3 position;
	DirectX::XMFLOAT3 normal;
};