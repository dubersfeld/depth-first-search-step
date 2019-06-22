package com.dub.spring.depthFirstSearch;

import java.util.ArrayList;
import java.util.List;


public class SimpleStack<T>  implements Stack<T> {
	
	/** A generic stack implementation */
	private List<T> list;
	
	public SimpleStack() {
		list = new ArrayList<T>();
	}
	
	@Override
	public T pop() {
		if (!list.isEmpty()) {
			T top = list.get(list.size()-1);
		
			list.remove(list.size()-1);
		
			return top;
		} else {
			return null;
		}
	}
	
	@Override
	public void push(T obj) {
		list.add(obj);
	}
	
	@Override
	public T top() {
		if (!list.isEmpty()) {
			return list.get(list.size()-1);
		} else {
			return null;
		}
	}
	
	@Override
	public boolean isEmpty() {
		return list.isEmpty();
	}

}
