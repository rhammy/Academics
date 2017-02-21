import java.util.Iterator;
import java.util.NoSuchElementException;

public class BalancedSearchTree<T>{

public Node<T> root;
public int currentSize;
	/**
	 *
	 * @author Reed Hamilton
	 * Allows the node to have pointers to a left child, right child, and parent.
	 * @param <T>
	 */
	public class Node<T>{
	T data;
	Node<T> leftChild;
	Node<T> rightChild;
	Node<T> parent;
	public Node(T obj){
		data = obj;
		parent = leftChild = rightChild = null;
		}
	}
	/**
	 * Takes in an object and adds it to the tree.
	 * @param obj
	 */
	public void add(T obj){
		Node<T> node = new Node<T>(obj);
		if(root == null){
		root = node;
		currentSize++;
		return;
		}
		add(root,node);
	}
	/**
	 * Overloaded add class compares the object added to nodes in the tree in order to properly place
	 * it in the right spot.
	 * @param parent
	 * @param newNode
	 */
	public void add(Node<T> parent, Node<T> newNode){
		if(((Comparable<T>)newNode.data).compareTo(parent.data) < 0){
			if(parent.leftChild == null){
				parent.leftChild = newNode;
				newNode.parent = parent;
				currentSize++;
			}
			else{
				add(parent.leftChild,newNode);
			}
		}
		else{
			if(parent.rightChild == null){
				parent.rightChild = newNode;
				newNode.parent = parent;
				currentSize++;
			}
			else{
				add(parent.rightChild, newNode);
			}
		}
		checkBalance(newNode);
	}
	/**
	 * checks the height of the left and right subtrees of a node to determine whether it is evenly balanced.
	 * @param node
	 */
	public void checkBalance(Node<T> node){
		if(node == null)
			return;
		if((height(node.leftChild) - height(node.rightChild) > 1)||(height(node.leftChild) - height(node.rightChild) < -1))
			{rebalance(node);}
		checkBalance(node.parent);
	}
	/**
	 * Rotates the tree nodes for an imbalance in the left child's left subtree.
	 * @param node
	 * @return
	 */
	public Node<T> rightRotate(Node<T> node){
		Node<T> tmp = node.leftChild;
		node.leftChild = tmp.rightChild;
		if(node.leftChild != null){
			node.leftChild.parent = node;
		}
		tmp.rightChild = node;
		tmp.parent = node.parent;
		node.parent = tmp;
		return tmp;
	}
	/**
	 * Rotates the tree nodes if there is an imbalance in the right child's right subtree.
	 * @param node
	 * @return
	 */
	public Node<T> leftRotate(Node<T> node){
		Node<T> tmp = node.rightChild;
		node.rightChild = tmp.leftChild;
		if(node.rightChild != null)
			node.rightChild.parent = node;
		tmp.leftChild = node;
		tmp.parent = node.parent;
		node.parent = tmp;
		return tmp;
	}
	/**
	 * Rotates the tree if there is an imbalance in the left child's right subtree.
	 * @param node
	 * @return
	 */
	public Node<T> leftRightRotate(Node<T> node){
		node.leftChild = leftRotate(node.leftChild);
		return rightRotate(node);
	}
	/**
	 * Rotates the tree nodes if there is an imbalance in the right child's left subtree.
	 * @param node
	 * @return
	 */

	public Node<T> rightLeftRotate(Node<T> node){
		node.rightChild = rightRotate(node.rightChild);
		return leftRotate(node);
	}

	/**
	 * Calls the rotate methods if there are any imbalances in the heights of each subtree.
	 * @param node
	 */
	public void rebalance(Node<T> node){
		if((height(node.leftChild)-height(node.rightChild)) > 1){
			if(height(node.leftChild.leftChild) > height(node.leftChild.rightChild)){
				node = rightRotate(node);
			}
			else{
				node = leftRightRotate(node);
			}
		}
		if((height(node.rightChild)-height(node.leftChild)) > 1){
			if(height(node.rightChild.rightChild) > height(node.rightChild.leftChild)){
				node = leftRotate(node);
			}
			else{
				node = rightLeftRotate(node);
			}
		}
		if(node.parent == null){
			root = node;
		}
		else{
			if(((Comparable<T>)node.data).compareTo(node.parent.data) > 0){
				node.parent.rightChild = node;
				}
			else{
				node.parent.leftChild = node;
			}
		}
	}
	/**
	 * Deletes the desired node
	 * @param obj
	 * @return
	 */
	public boolean delete(T obj){
			Node<T> newNode = new Node(obj);
			return delete(newNode, root);
	}
	public boolean delete(Node<T> node, Node<T> parent){
		if(parent == null)
			return false;
		if(((Comparable<T>)node.data).compareTo(parent.data) == 0){
			if(parent.rightChild == null && parent.leftChild == null){
				Node<T> grandparent = parent.parent;
				if(grandparent.leftChild == parent)
					grandparent.leftChild = null;
				else
					grandparent.rightChild = null;
				currentSize--;
				checkBalance(parent);
				return true;
			}
			if(parent.leftChild == null && parent.rightChild != null){
				Node<T> grandparent = parent.parent;
				if(grandparent.leftChild == parent){
					grandparent.leftChild = parent.rightChild;
					parent.rightChild.parent = grandparent;
				}
				else{
					grandparent.rightChild = parent.rightChild;
					parent.rightChild.parent = grandparent;
				}
				currentSize--;
				checkBalance(parent);
				return true;
			}
			if(parent.leftChild != null && parent.rightChild == null){
				Node<T> grandparent = parent.parent;
				if(grandparent.leftChild == parent){
					grandparent.leftChild = parent.leftChild;
					parent.leftChild.parent = grandparent;
				}
				else{
					grandparent.rightChild = parent.leftChild;
					parent.leftChild.parent = grandparent;
				}
				currentSize--;
				checkBalance(parent);
				return true;
			}
			if(parent.leftChild != null && parent.rightChild != null){
				Node<T> grandparent = parent.parent;
				currentSize -= 2;

				if(grandparent.leftChild == parent){
					grandparent.leftChild = parent.rightChild;
					parent.rightChild.parent = grandparent;
					add(parent.rightChild, parent.leftChild);
				}
				else{
					grandparent.rightChild = parent.rightChild;
					parent.rightChild.parent = grandparent;
					add(parent.rightChild, parent.leftChild);
				}
				checkBalance(parent);
				return true;
			}
		}
		if(((Comparable<T>)node.data).compareTo(parent.data) > 0)
			 {delete(node, parent.rightChild);}
		delete(node, parent.leftChild);
		return false;
	}
	/**
	 * returns the desired node
	 * @param obj
	 * @return
	 */
	public T get(T obj){
		Node<T> newNode = new Node(obj);
		return get(newNode, root);
	}
	public T get(Node<T> node, Node<T> parent){
		if(parent == null)
			return null;
		if(((Comparable<T>)node.data).compareTo(parent.data) == 0)
			return node.data;
		if(((Comparable<T>)node.data).compareTo(parent.data) > 0)
			return get(node, parent.rightChild);
		return get(node, parent.leftChild);
	}
	public int size(){
		return currentSize;// return the current size of the tree
	}
	/**
	 * Returns the height of that node
	 * @param node
	 * @return
	 */
	public int height(Node<T> node){
		 if (node == null)
		    {
		        return 0;
		    }
		    else
		    {
		        return 1 +
		        Math.max(height(node.leftChild),
		            height(node.rightChild));
		    }
		}
	/**
	 * Returns the height below a certain node
	 * @param node
	 * @return
	 */
	public int heightBelow(Node<T> node){
		return height(node);
	}
	/**
	 * checks if empty
	 * @return
	 */
	public boolean isEmpty(){
		return (currentSize == 0);
	}
	/**
	 * checks if full
	 */
	public boolean isFull(){
		return false;
	}

	public Iterator<T> allElements(){
		return new IteratorHelper(root);
	}

	class IteratorHelper implements Iterator<T> {
		private Node<T> next;

		public IteratorHelper(Node<T> root) {
			next = root;
			if (next == null)
				return;
			while (next.leftChild != null)
				next = next.leftChild;
		}

		public boolean hasNext() {
			return next != null;
		}

		public T next() {
			if (!hasNext())
				throw new NoSuchElementException();
			Node<T> n = next;
			if (next.rightChild != null) {
				next = next.rightChild;
				while (next.leftChild != null)
					next = next.leftChild;
				return n.data;
			} else {
				while (true) {
					if (next.parent == null) {
						next = null;
						return n.data;
					}
					if (next.parent.leftChild == next) {
						next = next.parent;
						return n.data;
					}
					next = next.parent;
				}
			}
		}
	}
	/**
	 * Finds next node in the tree
	 * @param obj
	 * @return
	 */
	public T findNext(T obj){
		Node<T> node = new Node(obj);
		return findNext(node, root);
		// Returns the next object in the structure.  Next is defined as the key that would follow the parameter object in an ordered list of objects, as determined by the Comparable interface.  Returns null if the parameter object is the last object in the tree.
	}
	public T findNext(Node<T> next, Node<T> parent){
		Node<T> n = next;
		if(parent == null)
			return null;
		if(((Comparable<T>)next.data).compareTo(parent.data) == 0)
			if (next.rightChild != null) {
				next = next.rightChild;
				while (next.leftChild != null)
					next = next.leftChild;
				return n.data;
			} else {
				while (true) {
					if (next.parent == null) {
						next = null;
						return n.data;
					}
					if (next.parent.leftChild == next) {
						next = next.parent;
						return n.data;
					}
					next = next.parent;
				}
			}
		if(((Comparable<T>)next.data).compareTo(parent.data) > 0)
			return findNext(next, parent.rightChild);
		return findNext(next, parent.leftChild);


	}
	/**
	 * Finds Previous node in the tree
	 * @param obj
	 * @return
	 */
	public T findPrevious(T obj){
		Node<T> node = new Node(obj);
		return findPrevious(node, root);// Returns the previous object in the structure.  Previous is defined as the key that would precede the parameter object in an ordered list of objects, as determined by the Comparable interface.  Returns null if the parameter object is the first object in the tree
	}
	public T findPrevious(Node<T> node, Node<T> parent){
		if(parent == null)
			return null;
		if(((Comparable<T>)node.data).compareTo(parent.data) == 0)
			return node.parent.data;
		if(((Comparable<T>)node.data).compareTo(parent.data) > 0)
			return findPrevious(node, parent.rightChild);
		return findPrevious(node, parent.leftChild);
	}
	/**
	 * Returns the root node
	 * @return
	 */
	public Node<T> rootNode(){
		return root;
	}
}
