#include "sphericalWaves.h"
#include <cmath>
#include <stdlib.h>
#include "math/vector3.h"

SphericalWaves::SphericalWaves() {
	twoSquareHalf = sqrt(2) / 2;
	xSize = 0;
	ySize = 0;
	amplifier = 0;
}

void SphericalWaves::init(int xSize, int ySize, double springConstant, double friction) {
	this->xSize = xSize;
	this->ySize = ySize;
	amplifier = springConstant * (1 - friction);
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
	double tSquareHalf = deltaT * deltaT / 2.0;
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
			force *= amplifier;
			double velocity = velocities[x * ySize + y];
			nextAmplitudes[x * ySize + y] = tSquareHalf * force + velocity * deltaT;
			velocities[x * ySize + y] += + force * deltaT;
		}
	}
	for (int i = 0; i < xSize * ySize; ++i) {
		currentAmplitudes[i] = nextAmplitudes[i];
	}
}

void SphericalWaves::applyAmplitude(Vector<Variant> voxels, int index) {
	for (int x = 1; x < xSize - 1; ++x) {
		for (int y = 1; y < ySize -1; ++y) {
			Spatial* node = (Spatial*)((Node*) voxels[x * ySize + y]);
			Vector3 translation = node->get_translation();
			translation[index] = currentAmplitudes[x * ySize + y];
			node->set_translation(translation);
		}
	}
}

void SphericalWaves::_bind_methods() {
	ObjectTypeDB::bind_method("init",&SphericalWaves::init);
	ObjectTypeDB::bind_method("update",&SphericalWaves::update);
	ObjectTypeDB::bind_method("applyAmplitude",&SphericalWaves::applyAmplitude);
	ObjectTypeDB::bind_method("getAmplitude",&SphericalWaves::getAmplitude);
	ObjectTypeDB::bind_method("setAmplitude",&SphericalWaves::setAmplitude);
}
