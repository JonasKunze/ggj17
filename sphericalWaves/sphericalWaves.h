#ifndef SPHERICALWAVES_H
#define SPHERICALWAVES_H

#include "reference.h"

class SphericalWaves : public Reference {
	OBJ_TYPE(SphericalWaves, Reference);
	double* currentAmplitudes;
	double* nextAmplitudes;
	double* velocities;
	int xSize, ySize;
	double amplifier, twoSquareHalf;
protected:
	static void _bind_methods();
public:
	SphericalWaves();
	~SphericalWaves();
	void init(int xSize, int ySize, double springConstant, double friction);
	double getAmplitude(int x, int y);
	void setAmplitude(int x, int y, double value);
	void update(double deltaT);
};

#endif
