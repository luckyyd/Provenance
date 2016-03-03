struct Fish
{
	double x,y;
	double toxin;
	double distance[10];
	double probability[10];
};

struct Shrimp
{
	double x,y;
	double toxin;
	double distance[10];
	double probability[10];
};

struct Plankton
{
	double x,y;
	double toxin;
	double distance[10];
	double probability[10];
};

struct Algae
{
	double x,y;
	double toxin;
	double distance[10];
	double probability[10];
};

struct Water_direction_speed
{
	double fish_speed;
	double shrimp_speed;
	double plankton_speed;
	//double water_speed;
	double water_speed_x;
	double water_speed_y;
};