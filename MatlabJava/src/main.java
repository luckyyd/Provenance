import java.io.BufferedReader;  
import java.io.BufferedWriter;  
import java.io.FileWriter;  
import java.io.FileReader;  
import monodex.Provenance;
import AntColonyDifference.AntColony;

public class main {
	public static final int row = 9;
	public static final int column = 21;
	
	static double[] tdata = null;
	static double[][] sumdata = null;
	static double[] positionx = null;
	static double[] positiony = null;
	static double[] positionz = null;
	static double[] x = null;
	static double[] y = null;
	static double[] z = null;
	
	
	public static void main(String[] args)
	{
		Provenance provenance = null;
		AntColony antcolony = null;
		
		//Input
		loadProvenanceDataFromCSV();
		loadPositionDataFromCSV();
		
		//Output initiated
		x = new double[row];
		y = new double[row];
		z = new double[row];
		
		//Provenance module
		Object[] provenanceResults = null;
		
		for (int i = 0; i < row; i++){
			//load data
			double[] cdata = new double[column];
			for(int j = 0; j < column; j++){
				cdata[j] = sumdata[i][j];
			}
			//calculate
			try{
				System.out.println("Procedure 1: Provenance...");
				provenance = new Provenance();
				provenanceResults = provenance.monodex(3,tdata, cdata);
				x[i] = Double.parseDouble(provenanceResults[0].toString());
				y[i] = Double.parseDouble(provenanceResults[1].toString());
				z[i] = Double.parseDouble(provenanceResults[2].toString());
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		
		//debug only
		for(int i = 0; i < row; i++){
			System.out.println(x[i]);
		}
		
		
		//AntColonyDifference module
		Object[] optimizationResults = null;
		for(int i = 0; i < x.length; i++){
			x[i] -= positionx[i];
			y[i] -= positiony[i];
			z[i] -= positionz[i];
			//System.out.println(x[i] + "  " + y[i] + "  " + z[i]);
		}
		
		try{
			System.out.println("Procedure 2: Optimization...");
			antcolony = new AntColony();
			optimizationResults = antcolony.AntColonyDifference(4, x, y, z);
			System.out.println(optimizationResults[0]);
			System.out.println(optimizationResults[1]);
			System.out.println(optimizationResults[2]);
			System.out.println(optimizationResults[3]);
			outputDataIntoCSV(optimizationResults);
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	public static void loadProvenanceDataFromCSV(){
		try{
			BufferedReader reader = new BufferedReader(new FileReader("input.csv"));
			String line = null;
			if((line=reader.readLine())!=null){
				String item[] = line.split(",");
				tdata = new double[item.length];
				for(int i = 0; i < item.length; i++){
					tdata[i] = new Double(item[i]);
				}
			}
			
			sumdata = new double[row][column];
			int iterator = 0;
			while((line=reader.readLine())!=null){
				String item[] = line.split(",");
				for(int i = 0; i < item.length; i++){
					sumdata[iterator][i] = new Double(item[i]);
				}
				iterator++;
			}	
			reader.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void loadPositionDataFromCSV(){
		try{
			BufferedReader reader = new BufferedReader(new FileReader("inputPosition.csv"));
			String line = null;
			if((line=reader.readLine())!=null){
				String item[] = line.split(",");
				positionx = new double[item.length];
				for(int i = 0; i < item.length; i++){
					positionx[i] = new Double(item[i]);
				}
			}
			
			if((line=reader.readLine())!=null){
				String item[] = line.split(",");
				positiony = new double[item.length];
				for(int i = 0; i < item.length; i++){
					positiony[i] = new Double(item[i]);
				}
			}
			
			if((line=reader.readLine())!=null){
				String item[] = line.split(",");
				positionz = new double[item.length];
				for(int i = 0; i < item.length; i++){
					positionz[i] = new Double(item[i]);
				}
			}
			reader.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void outputDataIntoCSV(Object[] results){
		try{
			BufferedWriter writer = new BufferedWriter(new FileWriter("outputResult.csv"));
			for(int i = 0; i < results.length; i++){
				writer.write(results[i].toString());
				writer.newLine();
			}
			writer.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}
