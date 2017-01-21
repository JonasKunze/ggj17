#ifndef SPHERICALWAVES_H
#define SPHERICALWAVES_H

#include "reference.h"

class SphericalWaves : public Reference {
	OBJ_TYPE(SphericalWaves, Reference);
	double* amplitudes;
	double* velocities;
	double* previousAmplitudes;
	int xSize, ySize;
	double springConstant, friction, twoSquareHalf;
protected:
	static void _bind_methods();
public:
	SphericalWaves();
	~SphericalWaves();
	void init(int xSize, int ySize, double springConstant, double friction);
	double getAmplitude(int x, int y);
	void setAmplitude(int x, int y, double value);
	void update(double deltaT);
private:
	double getPreviousAmplitude(int x, int y);
	void setPreviousAmplitude(int x, int y, double value);
	double getVelocity(int x, int y);
	void setVelocity(int x, int y, double value);
};

#endif
