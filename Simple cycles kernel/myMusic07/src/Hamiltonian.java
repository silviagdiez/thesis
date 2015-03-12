import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;



public class  {
public static int[][] adjacency = {
{0,1,0,0,0},
{1,0,1,1,0},
{0,1,0,1,1},
{0,1,1,0,0},
{0,0,1,0,0}
};
public static int n = adjacency.length;

public static void hp() {
	hp(new ArrayList<Integer>());
}

public static void hp(List<Integer> pathSoFar){ 
	if (pathSoFar.size() == n) {
		printSolution(pathSoFar);
		return;
	} else if (pathSoFar.size() == 0) {
		for (int i=0;i <n; i++ ) {
			pathSoFar.add(i);
			hp(pathSoFar);
			pathSoFar.remove(pathSoFar.size()-1);
		}
	} else {
		int currentNode = pathSoFar.get(pathSoFar.size()-1);
		for (int i=0;i <n; i++ ) {
			if (!pathSoFar.contains(i) && adjacency[currentNode][i] != 0) {
				pathSoFar.add(i);
				hp(pathSoFar);
				pathSoFar.remove(pathSoFar.size()-1);
			}
		}
	}

}

	public static void printSolution(List<Integer> pathSoFar) {
		Iterator<Integer> it = pathSoFar.iterator();
		while (it.hasNext()) {
			System.err.print(it.next()+" ");
		}
		System.err.println("  got it");
	}

	public static void main(String[] args) {	
		hp();
	}
}