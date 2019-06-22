package com.dub.spring.depthFirstSearch;

import java.io.Serializable;
import java.util.List;

/** Graph has Vertices and Adjacency Lists */
public class DFSGraph extends Graph implements Serializable {
	
	/**
	 * This subclass of Graph implements a Depth First Search algorithm
	 */
	private static final long serialVersionUID = 1L;

	private Stack<Integer> stack;
	
	private boolean finished;
	
	private int lastFound = 0;
	
	private Integer index;// main search loop current index
	
	int time = 0;
	
	
	public DFSGraph(int N) {
		super(N);
		stack = new SimpleStack<>();
		index = 0;
		finished = false;
	}
	

	public Stack<Integer> getStack() {
		return stack;
	}

	public boolean isFinished() {
		return finished;
	}

	public void setFinished(boolean finished) {
		this.finished = finished;
	}

	public void setStack(Stack<Integer> stack) {
		this.stack = stack;
	}

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}
	
	
	public void searchStep() {
		/** one vertex is visited at each step */
			
		StepResult result = new StepResult();// empty container
		result.setStatus(StepResult.Status.STEP);// default
		
		DFSVertex u = (DFSVertex)this.vertices[index];
		
		// begin with coloring
		if (u.getColor().equals(DFSVertex.Color.BLACK)) {// vertex has just been discovered
			u.setColor(DFSVertex.Color.GREEN);// visited
			time++;
			u.setD(time);
		}
			
		List<Integer> conn = u.getAdjacency();// present vertex successors 
		
	    Integer first = null;// first successor index if present
	    boolean finish = false;
	    
	    if (conn.isEmpty() || (first = this.findNotVisitedAndMark(conn, index)) == null) {
	    	finish = true;
	    }
	       
	    if (!finish) {// prepare to descend
	    
	        ((DFSVertex)vertices[first]).setParent(index);// only change here
	             
	        stack.push(index);// push present vertex before descending 	
	        index = first;// save u for the next step
	        
	    } else {// finish present vertex
	    	u.setColor(DFSVertex.Color.BLUE);
	    	time++;
	    	u.setF(time);
	    	
	    	if (!stack.isEmpty()) {
	    		index = stack.pop(); 	
	    	} else {
	    		index = this.findNotVisited();// can be null
	    		if (index == null) {
	    			result.setStatus(StepResult.Status.FINISHED);
	    			finished = true;
	    		}	
	    	}
	    }
		    
	}// searchStep
			
	
	// look for a non visited vertex to begin a new tree
	public Integer findNotVisited() {
		int nind = 0;
		DFSVertex v = null;
		for (nind = this.lastFound + 1; nind < N; nind++) {
			v = (DFSVertex)vertices[nind];
			if (v.getColor().equals(DFSVertex.Color.BLACK)) {
				break;
			}
		}
		
		if (nind < N) {
			this.lastFound = nind;// save as initial value for next lookup 
		
			return nind;
		} else {
			return null;
		}
				
	}// findNotVisited
	
	
	public Integer findNotVisitedAndMark(List<Integer> list, int from) {
		// successor lookup		
		int nind = 0;
		DFSVertex v = null;
		
		for (nind = 0; nind < list.size(); nind++) {
			int to = list.get(nind);
			v = (DFSVertex)vertices[to];
	 		
			if (v.getColor().equals(DFSVertex.Color.BLACK)) {
				break;
			}
		}
		if (nind < list.size()) {
			return list.get(nind);
		} else {
			return null;
		}
		
	}// findNotVisited
	
}

