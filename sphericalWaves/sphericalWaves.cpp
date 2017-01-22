#include "sphericalWaves.h"
#include <cmath>
#include <stdlib.h>
#include "math/vector3.h"

SphericalWaves::SphericalWaves() {
	twoSquareHalf = sqrt(2) / 2;
	xSize = 0;
	ySize = 0;
}

void SphericalWaves::init(int xSize, int ySize, double springConstant, double friction) {
	this->xSize = xSize;
	this->ySize = ySize;
	this->springConstant = springConstant;
	this->friction = friction;
	nextAmplitudes = new double[xSize * ySize];
	currentAmplitudes = new double[xSize * ySize];
	velocities = new double[xSize * ySize];
	for (int i = 0; i < xSize * ySize; ++i) {
		currentAmplitudes[i] = 0.0;
		nextAmplitudes[i] = 0.0;
		velocities[i] = 0.0;
	}
}

SphericalWaves::~SphericalWaves() {
	delete[] nextAmplitudes;
	delete[] currentAmplitudes;
	delete[] velocities;
}

double SphericalWaves::getAmplitude(int x, int y) {
	return nextAmplitudes[x * ySize + y];
}

void SphericalWaves::setAmplitude(int x, int y, double value) {
	currentAmplitudes[x * ySize + y] = value;
}

void SphericalWaves::update(double deltaT) {
	for (int x = 1; x < xSize - 1; ++x) {
		for (int y = 1; y < ySize -1; ++y) {
			double force = 0;
			for (int a = -1; a < 2; ++a) {
				for (int b = -1; b < 2; ++b) {
					double difference = currentAmplitudes[(x + a) * ySize + y + b] - currentAmplitudes[x * ySize + y];
					if (abs(x) + abs(y) == 2) {
						force += twoSquareHalf * difference;
					}
					else {
						force += difference;
					}
				}
			}
			double velocity = velocities[x * ySize + y];
			force = force * springConstant - velocity * friction;
			velocity += deltaT * force;

			nextAmplitudes[x * ySize + y] = currentAmplitudes[x * ySize + y] + velocity * deltaT;
			velocities[x * ySize + y] = velocity;
		}
	}
	for (int i = 0; i < xSize * ySize; ++i) {
		currentAmplitudes[i] = nextAmplitudes[i];
	}
}

void SphericalWaves::setNodes(Vector<Variant> voxels, int index) {
	for (int x = 1; x < xSize - 1; ++x) {
		for (int y = 1; y < ySize -1; ++y) {
			Spatial* node = (Spatial*)((Node*) voxels[x * ySize + y]);
			Vector3 translation = node->get_translation();
			translation[index] = currentAmplitudes[x * ySize + y];
			node->set_translation(translation);
		}
	}
}

void SphericalWaves::setMesh(Object* meshObj, Object* meshInstanceObj, Object* datatoolObj, int index) {
	Mesh* mesh = (Mesh*) meshObj;
	MeshInstance* meshInstance = (MeshInstance*) meshInstanceObj;
	MeshDataTool* datatool = (MeshDataTool*) datatoolObj;
	datatool->create_from_surface(mesh, 0);
	mesh->surface_remove(0);
	for (int i = 0; i < datatool->get_vertex_count(); ++i) {
		Vector3 vertex = datatool->get_vertex(i);
		vertex.y = currentAmplitudes[(int)((vertex.x - xSize / 2.0) * ySize + vertex.z - ySize / 2.0)];
		datatool->set_vertex(i,  vertex);
	}
	datatool->commit_to_surface(mesh);
	meshInstance->create_trimesh_collision();
}

void SphericalWaves::_bind_methods() {
	ObjectTypeDB::bind_method("init",&SphericalWaves::init);
	ObjectTypeDB::bind_method("update",&SphericalWaves::update);
	ObjectTypeDB::bind_method("getAmplitude",&SphericalWaves::getAmplitude);
	ObjectTypeDB::bind_method("setAmplitude",&SphericalWaves::setAmplitude);
	ObjectTypeDB::bind_method("setNodes",&SphericalWaves::setNodes);
	ObjectTypeDB::bind_method("setMesh",&SphericalWaves::setMesh);
}
