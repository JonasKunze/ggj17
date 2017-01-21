#include "sphericalWaves.h"
#include <cmath>

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
	amplitudes = new double[xSize * ySize];
	velocities = new double[xSize * ySize];
	previousAmplitudes = new double[xSize * ySize];
	for (int x = 0; x < xSize; ++x) {
		for (int y = 0; y < ySize; ++y) {
			setAmplitude(x, y, 0.0);
			setVelocity(x, y, 0.0);
			setPreviousAmplitude(x, y, 0.0);
		}
	}
}

SphericalWaves::~SphericalWaves() {
	delete[] amplitudes;
	delete[] velocities;
	delete[] previousAmplitudes;
}

double SphericalWaves::getAmplitude(int x, int y) {
	return amplitudes[x * ySize + y];
}

void SphericalWaves::setAmplitude(int x, int y, double value) {
	amplitudes[x * ySize + y] = value;
}

double SphericalWaves::getPreviousAmplitude(int x, int y) {
	return previousAmplitudes[x * ySize + y];
}

void SphericalWaves::setPreviousAmplitude(int x, int y, double value) {
	previousAmplitudes[x * ySize + y] = value;
}

double SphericalWaves::getVelocity(int x, int y) {
	return velocities[x * ySize + y];
}

void SphericalWaves::setVelocity(int x, int y, double value) {
	velocities[x * ySize + y] = value;
}

void SphericalWaves::update(double deltaT) {
	double tSquareHalf = deltaT * deltaT / 2.0;
	for (int x = 1; x < xSize - 1; ++x) {
		for (int y = 1; y < ySize -1; ++y) {
			double currentAmplitude = getAmplitude(x, y);
			double force = 0;
			for (int a = -1; a < 2; ++a) {
				for (int b = -1; b < 2; ++b) {
					double difference = getPreviousAmplitude(x + a, y + b) - currentAmplitude;
					if (abs(x) + abs(y) == 2) {
						force += twoSquareHalf * difference;
					}
					else {
						force += difference;
					}
				}
			}
			force *= springConstant * (1 - friction);
			double velocity = getVelocity(x, y);
			double newAmplitude = tSquareHalf * force + velocity * deltaT;
			setAmplitude(x, y, newAmplitude);
			setPreviousAmplitude(x, y, newAmplitude);
			setVelocity(x, y, velocity + force * deltaT);
		}
	}
}

void SphericalWaves::_bind_methods() {
	ObjectTypeDB::bind_method("init",&SphericalWaves::init);
	ObjectTypeDB::bind_method("update",&SphericalWaves::update);
	ObjectTypeDB::bind_method("getAmplitude",&SphericalWaves::getAmplitude);
	ObjectTypeDB::bind_method("setAmplitude",&SphericalWaves::setAmplitude);
}
