#include "register_types.h"
#include "object_type_db.h"
#include "sphericalWaves.h"

void register_sphericalWaves_types() {
	ObjectTypeDB::register_type<SphericalWaves>();
}

void unregister_sphericalWaves_types() {
	//nothing to do here
}
