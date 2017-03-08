package com.dub.site.depthFirstSearch;

import java.util.List;


/** POJO represents vertex for AJAX initialization request only */
public class JSONVertex {
	
	/**
	 * 
	 */
	private String name;    
	private List<Integer> adjacency;// all adjacent vertices indices from this vertex
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Integer> getAdjacency() {
		return adjacency;
	}
	public void setAdjacency(List<Integer> adjacency) {
		this.adjacency = adjacency;
	}
	
}
