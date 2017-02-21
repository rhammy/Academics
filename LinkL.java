import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * @author Reed
 * @param <E> the type of object used in this list
 */
public class LinkedList<E> implements ListI<E> {
	/**
	 * Nodes that point to the top and bottom of the list
	 * an integer that counts the current size of the list
	 */
	private Node<E> head,tail;
	int currentSize;
	/**
	 *This class is the skeleton for the Node object in the linked list
	 *makes it possible for Nodes to point at each other.
	 * @param <T>
	 */
	private class Node<T> {
		T data;
		Node<T> next;
		public Node(T obj) {
			data = obj;
			next = null;
			}
		}
	/**
	 * Takes in an object and adds it to the front of the list.
	 * @param obj that is added to the list
	 */

	  public void addFirst(E obj) {
		Node<E> node = new Node<E>(obj);
		node.next = head;
		head = node;
		currentSize++;
		return;
	}
	/**
	 * Adds an object to the end of the list.
	 * @param obj the object to be added to the list.
	 */
	public void addLast(E obj) {
		Node <E> node = new Node(obj);
		if (head == null) {
			head = tail = node;
			currentSize++;
			return;
			}
		tail.next = node;
		tail = node;
		currentSize++;
		return;
}
	/**
	 * Removes the last Object in the list and returns it.
	 * Returns null if the list is empty.
	 * @return the object removed.
	 */
	public E removeFirst() {
	    if (head == null)
		{
		return null;
		}
	    Node<E> tmp = head;
		head = head.next;
	    currentSize--;
		return tmp.data;
	}
	/**
	 * Removes the last Object in the list and returns it.
	 * Returns null if the list is empty.
	 * @return the object removed.
	 */
	public E removeLast() {
		if(head == null)
		{
			return null;
		}

		if (head == tail)
		{
			return removeFirst();
		}
		Node<E> current = head;
		Node<E> previous = null;
		while(current != tail)
		{
		    previous = current;
		    current = current.next;
		}
			tail = previous;
			previous.next = null;
			currentSize--;
			return current.data;
	}
	/**
	 * Returns the first Object in the list, but does not remove it.
	 * Returns null if the list is empty.
	 * @return the object at the beginning of the list.
	 */
	public E peekFirst() {
		return head.data;
	}
	/**
	 * Returns the last Object in the list, but does not remove it.
	 * Returns null if the list is empty.
	 * @return the object at the end of the list.
	 */
	public E peekLast() {
		return tail.data;
	}
	/**
	 * Return the list to an empty state.
	 */
	public void makeEmpty() {
		head = tail = null;
		currentSize = 0;
	}
	/**
	 * Test whether the list is empty.
	 * @return true if the list is empty, otherwise false
	 */
	public boolean isEmpty() {
		return (head == null);
	}
	/**
	 * Test whether the list is full.
	 * @return true if the list is full, otherwise false
	 */
	public boolean isFull() {
		return false;
	}
	/**
	 * Returns the number of Objects currently in the list.
	 * @return the number of Objects currently in the list.
	 */
	public int size() {
		return currentSize;
	}
	/**
	 * Test whether the list contains an object. This will use the object's
	 * compareTo method to determine whether two objects are the same.
	 *
	 * @param obj The object to look for in the list
	 * @return true if the object is found in the list, false if it is not found
	 */
	public boolean contains(E obj)
	{
		Node<E> tmp = head;
		while( tmp != null)
		{
			if(((Comparable<E>)tmp.data).compareTo(obj) == 0)
			{
				return true;
			}
			tmp = tmp.next;
		}
			return false;
	}
	/**
	 * Reverse the order of the list.
	 * This will exactly reverse the order of the list, so the first element is
	 * last, and vice-versa.
	 */
	public void reverse() {
		if(head == tail || head == null)
			return;
		Node<E> second = head.next;
		Node<E> third = second.next;
		second.next = head;
		head.next = null;
		if(third == null)
			return;
		Node<E> current = third;
		Node<E> previous = second;
		Node<E> next;

		while(current != null){
			next = current.next;
			current.next = previous;
			previous = current;
			current = next;
		}
		head = previous;
		return;
	}
	/**
	 * Returns an Iterator of the values in the list, presented in
	 * the same order as the list.
	 * @see java.lang.Iterable#iterator()
	 */
	public class IteratorHelper implements Iterator<E>{
		Node<E> index;
		public IteratorHelper() {
			index = head;
			}
		public boolean hasNext() {
				return index != null;
				}
		public E next() {
				if (!hasNext())
					throw new NoSuchElementException();
				E top = index.data;
				index = index.next;
				return top;
			}
		public void remove() {
			throw new UnsupportedOperationException();
			}
	}

	public Iterator<E> iterator(){
		return new IteratorHelper();
	}
}
