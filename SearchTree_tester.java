import java.util.Iterator;

public class test {
	public static void main(String[] args){
		BalancedSearchTree<Integer> tree = new BalancedSearchTree<Integer>();
		for( int i = 0; i < 10000; i++)
			tree.add(i);
		final long startTime = System.currentTimeMillis();
		System.out.println(tree.delete(700));
		final long endTime = System.currentTimeMillis();

		System.out.println("Total execution time: " + (endTime - startTime) );
		System.out.println(tree.size());
		tree.delete(7);
		tree.delete(45);
		tree.delete(67);
		tree.delete(33);

		/**Iterator yum = tree.allElements();
		while(yum.hasNext())
			System.out.println(yum.next());

		System.out.println(tree.get(98));

		for( int i = 0; i < 567; i++)
			tree.delete(i);

		System.out.println("The new size is " + tree.size());
		**/
	}
}
