#ifndef SPHERICALWAVES_H
#define SPHERICALWAVES_H

#include "reference.h"
#include "scene/main/node.h"
#include "scene/3d/spatial.h"
#include "variant.h"
#include "object.h"
#include "scene/resources/mesh_data_tool.h"
#include "scene/resources/mesh.h"
#include "scene/3d/mesh_instance.h"


class SphericalWaves : public Reference {
	OBJ_TYPE(SphericalWaves, Reference);
	double* currentAmplitudes;
	double* nextAmplitudes;
	double* velocities;
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
	void setNodes(Vector<Variant> voxels, int index);
	void setMesh(Object* mesh, Object* meshInstance, Object* datatool, int index);
};

#endif
