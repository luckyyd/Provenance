// concertration.cpp : 定义控制台应用程序的入口点。
//

#include "StdAfx.h"
#include <stdio.h>
#include <iostream>
#include "definition.h"
#include <cmath>  
#include <map>      

using namespace std;

const int sample_point_sum = 9;
const int data_input_row_sum = 21;
Fish fish[sample_point_sum];
Shrimp shrimp[sample_point_sum];
Plankton plankton[sample_point_sum];
Algae algae[sample_point_sum];
double pollution_data[data_input_row_sum][sample_point_sum];
Water_direction_speed waterdirspd;

double* linearEquation();

double dabs(double i)
{
	if(i>=0)
		return i;
	else
		return -i;
}

void water_input()
{
	FILE *fp_water=fopen("water_input.txt","r");
	if(!fp_water)
	{
		printf("can't open file water_input\n");
		return;
	}
	else
	{
		double fish_speed_read,shrimp_speed_read,plankton_speed_read;
		double water_speed_x_read, water_speed_y_read;

		fscanf(fp_water,"%lf",&fish_speed_read);
		waterdirspd.fish_speed = fish_speed_read;
		fscanf(fp_water,"%lf",&shrimp_speed_read);
		waterdirspd.shrimp_speed = shrimp_speed_read;
		fscanf(fp_water,"%lf",&plankton_speed_read);
		waterdirspd.plankton_speed = plankton_speed_read;

		fscanf(fp_water,"%lf",&water_speed_x_read);
		waterdirspd.water_speed_x = water_speed_x_read;
		fscanf(fp_water, "%lf", &water_speed_y_read);
		waterdirspd.water_speed_y = water_speed_y_read;
	}
	fclose(fp_water);
}

void location_input()
{
	FILE *fp_location=fopen("location.txt","r");
	if(!fp_location)
	{
		printf("can't open file location.txt\n");
		return;
	}
	else
	{
		double location_read_x,location_read_y;
		//algae location read
		for(int i = 0;i<sample_point_sum;i++)
		{
			fscanf(fp_location,"%lf%lf",&location_read_x,&location_read_y);
			algae[i].x = location_read_x;
			algae[i].y = location_read_y;
		}
		//plankton location read
		for (int i = 0; i<sample_point_sum; i++)
		{
			fscanf(fp_location, "%lf%lf", &location_read_x, &location_read_y);
			plankton[i].x = location_read_x;
			plankton[i].y = location_read_y;
		}
		//shrimp location read
		for (int i = 0; i<sample_point_sum; i++)
		{
			fscanf(fp_location, "%lf%lf", &location_read_x, &location_read_y);
			shrimp[i].x = location_read_x;
			shrimp[i].y = location_read_y;
		}
		//fish location read
		for (int i = 0; i<sample_point_sum; i++)
		{
			fscanf(fp_location, "%lf%lf", &location_read_x, &location_read_y);
			fish[i].x = location_read_x;
			fish[i].y = location_read_y;
		}
		fclose(fp_location);
	}
}

//Depleted
void data_output()
{
	//Read pollution from algae
	FILE *fp_data_input = fopen("pollution_input.txt", "r");
	if (!fp_data_input)
	{
		printf("can't open file data_input.txt\n");
		return;
	}
	else
	{
		double data_read;
		for (int i = 0; i<data_input_row_sum; i++)
		{
			for (int j = 0; j < sample_point_sum; j++)
			{
				fscanf(fp_data_input, "%lf", &data_read);
				pollution_data[i][j] = data_read;
			}
		}
		fclose(fp_data_input);
	}
}

void pollution_input()
{
	//load fish assay result from file
	//all fish pollution data save in pollution_data array
	FILE *fp_fish_assay = fopen("fish_assay.txt", "r");
	if (!fp_fish_assay)
	{
		printf("can't open file fish_assay.txt\n");
		return;
	}
	else
	{
		double toxin_read;
		for (int i = 0; i < data_input_row_sum; i++)
		{
			for (int j = 0; j < sample_point_sum; j++)
			{
				fscanf(fp_fish_assay, "%lf", &toxin_read);
				pollution_data[i][j] = toxin_read;
			}
		}
		fclose(fp_fish_assay);
	}
}

void initialization()
{
	double vector_x, vector_y, scalar_x, scalar_y;
	double time_x, time_y, length;
	//output in a file
	FILE *fp_max_toxin = fopen("max_toxin.txt", "w");
	FILE *fp_fish_shrimp = fopen("fish_shrimp.txt", "w");
	FILE *fp_shrimp_plankton = fopen("shrimp_plankton.txt", "w");
	FILE *fp_plankton_algae = fopen("plankton_algae.txt", "w");
	double max_algae_probability(0), max_plankton_probability(0), max_shrimp_probability(0);

	//Algae
	for (int i = 0; i<sample_point_sum; i++)
	{
		double distance_sum = 0;
		for (int j = 0; j<sample_point_sum; j++)
		{
			scalar_x = dabs(algae[j].x - plankton[i].x);
			scalar_y = dabs(algae[j].y - plankton[i].y);
			length = sqrt(scalar_x * scalar_x + scalar_y * scalar_y);

			algae[i].distance[j] = sqrt(scalar_x*scalar_x + scalar_y*scalar_y);
			distance_sum += 1 / (algae[i].distance[j]);
		}
		for (int j = 0; j<sample_point_sum; j++)
		{
			algae[i].probability[j] = (1 / algae[i].distance[j]) / distance_sum;
			fprintf(fp_plankton_algae, "%d %d %d %d %lf\n", i, j, algae[i].probability[j]);
			if (algae[i].probability[j] > max_algae_probability)
			{
				max_algae_probability = algae[i].probability[j];
			}
		}
	}
	fprintf(fp_max_toxin, "%lf\n", max_algae_probability);
	fclose(fp_plankton_algae);

	//Plankton
	for (int i = 0; i<sample_point_sum; i++)
	{
		double distance_sum = 0;
		for (int j = 0; j<sample_point_sum; j++)
		{
			scalar_x = dabs(plankton[j].x - shrimp[i].x);
			scalar_y = dabs(plankton[j].y - shrimp[i].y);
			length = sqrt(scalar_x * scalar_x + scalar_y * scalar_y);


			plankton[i].distance[j] = sqrt(scalar_x*scalar_x + scalar_y*scalar_y);
			distance_sum += 1 / (plankton[i].distance[j]);
		}
		for (int j = 0; j<sample_point_sum; j++)
		{
			plankton[i].probability[j] = (1 / plankton[i].distance[j]) / distance_sum;
			fprintf(fp_shrimp_plankton, "%d %d %lf\n", i, j, plankton[i].probability[j]);
			if (plankton[i].probability[j] > max_plankton_probability)
			{
				max_plankton_probability = plankton[i].probability[j];
			}
		}
	}
	fprintf(fp_max_toxin, "%lf\n", max_plankton_probability);
	fclose(fp_shrimp_plankton);

	//Fish
	for (int i = 0; i<sample_point_sum; i++)
	{
		double distance_sum = 0;
		for (int j = 0; j<sample_point_sum; j++)
		{
			scalar_x = dabs(shrimp[j].x - fish[i].x);
			scalar_y = dabs(shrimp[j].y - fish[i].y);
			length = sqrt(scalar_x * scalar_x + scalar_y * scalar_y);

			shrimp[i].distance[j] = sqrt(scalar_x*scalar_x + scalar_y*scalar_y);
			distance_sum += 1 / (shrimp[i].distance[j]);
		}
		for (int j = 0; j<sample_point_sum; j++)
		{
			shrimp[i].probability[j] = (1 / shrimp[i].distance[j]) / distance_sum;
			fprintf(fp_fish_shrimp, "%d %d %lf\n", i, j, shrimp[i].probability[j]);
			if (shrimp[i].probability[j] > max_shrimp_probability)
			{
				max_shrimp_probability = shrimp[i].probability[j];
			}
		}
	}
	fprintf(fp_max_toxin, "%lf\n", max_shrimp_probability);
	fclose(fp_fish_shrimp);

	fclose(fp_max_toxin);

}

void fish_assay(int row)
{
	//read fish assay result from pollution data
	for(int i = 0;i<sample_point_sum;i++)
	{
		fish[i].toxin = pollution_data[row][i];
	}
}

void shrimp_assay()
{
	//read shrimp assay result from file
	//shrimp_assay 说明了虾体内污染的质量，此处不使用 Deprecated...
	FILE *fp_shrimp_assay=fopen("shrimp_assay.txt","r");
	if(!fp_shrimp_assay)
	{
		printf("can't open file shrimp_assay.txt\n");
		return;
	}
	else
	{
		double toxin_read;
		for(int i = 0;i<sample_point_sum;i++)
		{
			fscanf(fp_shrimp_assay,"%lf",&toxin_read);
			shrimp[i].toxin = toxin_read;
		}
		fclose(fp_shrimp_assay);
	}
}

void init()
{
	//Top down approach
	//from algae to plankton
	for (int i = 0; i<sample_point_sum; i++)
	{
		for (int j = 0; j<sample_point_sum; j++)
		{
			algae[i].toxin = 0;
		}
	}
	//from plankton to shrimp
	for (int i = 0; i<sample_point_sum; i++)
	{
		for (int j = 0; j<sample_point_sum; j++)
		{
			plankton[i].toxin = 0;
		}
	}

	//from plankton to shrimp
	for (int i = 0; i<sample_point_sum; i++)
	{
		for (int j = 0; j<sample_point_sum; j++)
		{
			shrimp[i].toxin = 0;
		}
	}
}

void workflow_provenance()
{
	//enrichment factor
	const double enrichment_algae_plankton = 100;
	const double enrichment_plankton_shrimp = 100;
	const double enrichment_shrimp_fish = 100;

	//Write to File for linear equation to solve
	FILE *fp_linear_equation = fopen("linearEquationInput.txt", "w");
	fprintf(fp_linear_equation, "%d\n", sample_point_sum);
	//from fish to shrimp
	for(int i = 0;i<sample_point_sum;i++)
	{
		for(int j = 0;j<sample_point_sum;j++)
		{
			fprintf(fp_linear_equation, "%lf ", shrimp[j].probability[i]);
		}
		fprintf(fp_linear_equation, "%lf\n", fish[i].toxin);
	}
	fclose(fp_linear_equation);
	//Solve the equation
	double* result = linearEquation();
	for (int i = 0; i < sample_point_sum; i++)
	{
		shrimp[i].toxin = result[i + 1] / enrichment_shrimp_fish;
	}
	
	//Write to File for linear equation to solve
	fp_linear_equation = fopen("linearEquationInput.txt", "w");
	fprintf(fp_linear_equation, "%d\n", sample_point_sum);
	//from shrimp to plankton
	for (int i = 0; i<sample_point_sum; i++)
	{
		for (int j = 0; j<sample_point_sum; j++)
		{
			fprintf(fp_linear_equation, "%lf ", plankton[j].probability[i]);
		}
		fprintf(fp_linear_equation, "%lf\n", shrimp[i].toxin);
	}
	fclose(fp_linear_equation);
	//Solve the equation
	result = linearEquation();
	for (int i = 0; i < sample_point_sum; i++)
	{
		plankton[i].toxin = result[i + 1] / enrichment_plankton_shrimp;
	}

	//Write to File for linear equation to solve
	fp_linear_equation = fopen("linearEquationInput.txt", "w");
	fprintf(fp_linear_equation, "%d\n", sample_point_sum);
	//from plankton to algae
	for (int i = 0; i<sample_point_sum; i++)
	{
		for (int j = 0; j<sample_point_sum; j++)
		{
			fprintf(fp_linear_equation, "%lf ", algae[j].probability[i]);
		}
		fprintf(fp_linear_equation, "%lf\n", plankton[i].toxin);
	}
	fclose(fp_linear_equation);
	//Solve the equation
	result = linearEquation();
	for (int i = 0; i < sample_point_sum; i++)
	{
		algae[i].toxin = result[i + 1] / enrichment_algae_plankton;
	}
}

void toxin_sort()
{
	map<double,int> toxin_list;
	for(int i = 0;i<sample_point_sum;i++)
	{
		toxin_list.insert(pair<double,int>(algae[i].toxin,i));
	}
	cout<<"The toxin contained       No."<<endl;
	cout<<"in the algae sensor:       "<<endl;
	map<double, int>::iterator  iter;
    for(iter = toxin_list.end();iter != toxin_list.begin();)
	{
		iter--;
		cout<<iter->first<<"                    "<<iter->second<<endl;
	}	
}

void output_to_file()
{
	FILE *fp_output = fopen("output.txt", "a");
	//Output
	for (int i = 0; i<sample_point_sum; i++)
	{
		cout << "No. " << i + 1 << "   Toxin: " << algae[i].toxin << endl;
		fprintf(fp_output, "%lf\n", algae[i].toxin);
	}
	fprintf(fp_output, "\n");
	fclose(fp_output);
}

int main()
{
	//water data input
	water_input();
	//sensor location
	location_input();
	//calculate probability
	initialization();
	//load fish pollution data
	pollution_input();
	for (int i = 0; i < data_input_row_sum; i++)
	{
		//check the fish
		fish_assay(i);
		//check the shrimp
		//shrimp_assay();
		init();
		//provenance
		workflow_provenance();
		//sort according to toxin
		//toxin_sort();
		output_to_file();
	}
	
	
	system("pause");
}
