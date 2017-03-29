package com.dub.site.depthFirstSearch;

import java.io.Serializable;


/** Graph has Vertices and Adjacency Lists */
public class Graph implements Serializable {
	
	/**
	 * This class implements an oriented graph
	 */
	protected static final long serialVersionUID = 1L;

	protected Vertex[] vertices;
	protected int N;
	
	public Graph(int N) {
		this.N = N;
		this.vertices = new Vertex[N];
	}
	
	
	
	public Vertex[] getVertices() {
		return vertices;
	}



	public void setVertices(Vertex[] vertices) {
		this.vertices = vertices;
	}



	public void display() {// used for debugging only
		for (Vertex v : vertices) {
			System.out.println(v);
		}
		
		System.out.println();
	}
	
	public void display2() {// used for debugging only
		for (int i1 = 0; i1 < N; i1++) {// for each vertex
			System.out.print(vertices[i1].getName() + " -> ");
			for (int i2 = 0; i2 < vertices[i1].getAdjacency().size(); i2++) {
				int lind = vertices[i1].getAdjacency().get(i2);
				System.out.print(vertices[lind].getName() + " ");
			}
			System.out.println();
		}
		System.out.println();	
	
	}	
}
