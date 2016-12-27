#include "StdAfx.h"
#include<iostream>
#include<math.h>
#include<fstream>
#include<stdlib.h>
using namespace std;

//Solve linear equation 
double* linearEquation() {
	int n, m;
	ifstream ifile;
	ifile.open("linearEquationInput.txt");
	ifile >> n;
	double linear[100][100];
	double result[100];
	int i, j;
	for (i = 0; i < 100; i++)
	{
		for (int j = 0; j < 100; j++)
		{
			linear[i][j] = 0;
		}
		result[i] = 0;
	}
	for (i = 1; i <= n; i++) {
		for (j = 1; j <= n + 1; j++) {
			ifile >> linear[i][j];
		}
	}

	//cout << "输入方程组介数：";
	//cout << n << endl;
	//cout << "输入增广矩阵：" << endl;
	for (i = 1; i <= n; i++) {
		for (j = 1; j <= n + 1; j++) {
			cout << linear[i][j] << "   ";
		}
		cout << endl;
	}


	for (j = 1; j <= n; j++) {
		double max, imax = 0;
		for (i = j; i <= n; i++) {
			if (imax<fabs(linear[i][j])) {
				imax = fabs(linear[i][j]);
				max = linear[i][j];
				m = i;
			}
		}

		if (fabs(linear[j][j]) != max) {
			double b;
			for (int k = j; k <= n + 1; k++) {
				b = linear[j][k];
				linear[j][k] = linear[m][k];
				linear[m][k] = b;
			}
		}

		for (int r = j; r <= n + 1; r++) {
			linear[j][r] = linear[j][r] / max;
		}


		for (i = j + 1; i <= n; i++) {
			double c = linear[i][j];
			if (c == 0)  continue;
			for (int s = j; s <= n + 1; s++) {
				linear[i][s] = linear[i][s] - linear[j][s] * c;
			}
		}

	}

	for (i = n - 1; i>0; i--) {
		for (j = i + 1; j <= n; j++) {
			linear[i][n + 1] = linear[i][n + 1] - linear[j][n + 1] * linear[i][j];
		}
	}

	for (int k = 1; k <= n; k++)
	{
		result[k] = linear[k][n + 1];
		if (result[k] < 0)
		{
			result[k] = 1.36887256351359E-09;
		}
	}

	return result;
}